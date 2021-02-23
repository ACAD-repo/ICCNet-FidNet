clear all; clc;

% ============================================================
% Generates simulation training examples for ICCNet and FidNet
% ============================================================

% This script generates simulated test datasets of all four data types
% that are used for evaluating trained models of ICCNet and FidNet.

numqubits=4; % number of qubits
dim = round(2.^numqubits); % Hilbert-space dimension
num_ex=50; % number of test examples per data type and rank (1<=r<=3)
copies=1000; % number of copies assigned for statistically noisy simulations

root_dir='../raw_test_examples/';

for rand_or_ACT=1:2 %1 for rand and 2 for ACT
    for perf_or_noisy=1:2 %1 for perfect and 2 for statistically noisy examples
        for rnk_st=1:3 %true-state rank for the simulations
            
            if perf_or_noisy==1
                if rand_or_ACT==2
                    par_dir=strcat(root_dir,'test_ex_ACT_rnk_',int2str(rnk_st),'/D',...
                        int2str(dim),'/raw_data/');
                elseif rand_or_ACT==1
                    par_dir=strcat(root_dir,'test_ex_Haar_rnk_',int2str(rnk_st),'/D',...
                        int2str(dim),'/raw_data/');
                end
            elseif perf_or_noisy==2
                if rand_or_ACT==2
                    par_dir=strcat(root_dir,'test_ex_ACT_N_',int2str(copies),'_rnk_',...
                        int2str(rnk_st),'/D',int2str(dim),'/raw_data/');
                elseif rand_or_ACT==1
                    par_dir=strcat(root_dir,'test_ex_Haar_N_',int2str(copies),'_rnk_',...
                        int2str(rnk_st),'/D',int2str(dim),'/raw_data/');
                end
            end
            
            mkdir(par_dir);
            load(strcat('Z_d',int2str(dim),'/linmat.mat')) % Z must be the 
                                                           % same as that 
                                                           % used in the
                                                           % training
                                                           % examples!
            save(strcat(par_dir,'linmat.mat'),'linmat');
            
            K=10;
            
            time_bank=zeros(num_ex,K);
            for ex=1:num_ex
                
                fprintf('Generating test example %i...',ex)
                
                % Generates random state of rank rnk
                rnk=rnk_st;
                rho_r=randn(dim,rnk)+i.*randn(dim,rnk);
                rho_r=rho_r*rho_r';
                rho_r=rho_r./trace(rho_r);
                rho=rho_r;
                
                % Stores generated random state
                state_info=cell(1,3);
                state_info{1}=rho;
                state_info{2}=rnk;
                
                % Initializes measurement basis to the computational one
                pom=pom_gen(dim,dim,1);
                dims=size(pom);
                M=dims(3);
                pom_meas=pom;
                
                % Computes true probabilities for the measurement basis
                probs=zeros(M,1);
                for l=1:M
                    probs(l) = abs(sum(sum(rho.'.*pom_meas(:,:,l))));
                end
                
                raw_data=cell(K,9);
                clicks_meas=[];
                pom_next=zeros(dim,dim,dim);
                Urot=eye(dim);
                
                % Loops over K bases
                for k=1:K
                    
                    % Accumulates measurement relative frequencies
                    if perf_or_noisy==2
                        click_probs=probs((k-1)*dim+1:k*dim);
                        click_probs=click_probs./sum(click_probs);
                        clicks=mnrnd(copies,click_probs)';
                        clicks_meas=[clicks_meas;clicks];
                        freqs_meas=clicks_meas./(k.*copies);
                        data_vec=freqs_meas;
                    elseif perf_or_noisy==1
                        data_vec=probs;
                    end
                    
                    tic;
                    % Performs ML starting from the maximally-mixed state
                    % always, and computes the ML probabilities
                    rhoML = qse_apg(pom_meas,data_vec);
                    probsML=zeros(k.*dim,1);
                    for j=1:k.*dim
                        probsML(j) = abs(sum(sum(rhoML.'.*pom_meas(:,:,j))));
                    end
                    
                    % Performs two SDPs to compute scvx (normalized to unity
                    % for k=1)                     
                    [rhoMLmax,s_max]=ICC_sdp(pom_meas, probsML, linmat, 1);
                    [rhoMLmin,s_min]=ICC_sdp(pom_meas, probsML, linmat, 0);
                    timeElapsed=toc;
                    time_bank(ex,k)=timeElapsed;                    
                    if k==1
                        s_max0=s_max-s_min;
                    end
                    size_cvx=abs((s_max-s_min)./s_max0)
                    
                    % Stores all output variables
                    raw_data{k,1}=probsML.*k;
                    raw_data{k,2}=rhoMLmax;
                    raw_data{k,3}=s_max;
                    raw_data{k,4}=s_min;
                    raw_data{k,5}=rhoMLmin;
                    raw_data{k,6}=size_cvx;
                    raw_data{k,7}=Urot;
                    raw_data{k,8}=timeElapsed;
                    raw_data{k,9}=data_vec./sum(data_vec).*k;
                    
                    pom_tmp=pom_meas.*k/(k+1);
                    
                    if rand_or_ACT==2
                        
                        % Performs minimum-entropy ACT
                        Smin_fin=log(dim);
                        for lll=1:1
                            rho0=randn(dim,dim)+i.*randn(dim,dim);
                            rho0=rho0*rho0';
                            rho0=rho0./trace(rho0);
                            opts.rho0=rho0;
                            
                            for ll=1:1
                                rhopost=MLME_apg(pom_meas,data_vec,-5e-4,opts);
                                opts.rho0=rhopost;
                                if lll==1
                                    rhopost_fin=rhopost;
                                end
                            end
                            [Vl,Dl]=eig(rhopost);
                            Smin=-diag(Dl)'*log(diag(Dl));
                            
                            if Smin<Smin_fin
                                Smin_fin=Smin;
                                rhopost_fin=rhopost;
                            end
                        end
                        rhopost=rhopost_fin;
                        [Urot,D]=eig(rhopost);
                        [D,I] = sort(diag(D));
                        Urot = Urot(:, I);
                        
                    elseif rand_or_ACT==1
                        
                        % Generates Haar-distributed random unitary                        
                        A=randn(dim,dim)+i*randn(dim,dim);
                        [Q,R]=qr(A);
                        r=diag(R);
                        L=diag(r./abs(r));
                        Urot=Q*L;
                    end
                    
                    for l=1:dim
                        pom_next(:,:,l)=Urot*pom(:,:,l)*Urot';
                    end
                    pom_meas=cat(3,pom_tmp,pom_next./(k+1));
                    probs=zeros((k+1).*dim,1);
                    for l=1:(k+1).*dim
                        probs(l) = abs(sum(sum(rho.'.*pom_meas(:,:,l))));
                    end
                end
                
                save(strcat(par_dir,'raw_data_',int2str(ex),'.mat'),'raw_data')
                save(strcat(par_dir,'state_info_',int2str(ex),'.mat'),'state_info')
                
                fprintf('done!\n')
            end
            
            % Stores elapsed time separately for convenience
            save(strcat(par_dir,'time_bank.mat'),'time_bank')
            
        end
    end
end