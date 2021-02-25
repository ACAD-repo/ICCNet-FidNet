clear all;clc

% Process simulated example data for training

% Packs data from ACT and random Haar simulations into MATLAB cell files
% for use with Python scripts.

batch=cell(4,1);
batch{1}=1:2000; % Noisy random Haar (N=1000)
batch{2}=1:2000; % Noiseless random Haar (N=Inf)
batch{3}=1:2000; % Noisy ACT (N=1000)
batch{4}=1:2000; % Noiseless ACT (N=Inf)
batch_vec=1:4; % Chooses which batch to include for training.

M=0;
for l=batch_vec
    M=M+length(batch{l});
end

D=16; % Hilbert-space dimension
Kmin=1; % Minimum K value
Kmax=10; % Maximum K value
std_basis=pom_gen(D,D,1); % Initializes computational basis

% Defines raw-data storage directories

batch_raw=cell(4,1);
batch_raw{1}=strcat('../raw_training_examples/train_ex_Haar_N_1000/D',int2str(D),'/raw_data/');
batch_raw{2}=strcat('../raw_training_examples/train_ex_Haar/D',int2str(D),'/raw_data/');
batch_raw{3}=strcat('../raw_training_examples/train_ex_ACT_N_1000/D',int2str(D),'/raw_data/');
batch_raw{4}=strcat('../raw_training_examples/train_ex_ACT/D',int2str(D),'/raw_data/');

stor_proc=strcat('../training/',int2str(M),'_perf_noisy_ex/')
mkdir(stor_proc);

Xcell=cell(Kmax-Kmin+1,1);
ycell=cell(Kmax-Kmin+1,1);

% Proceeds to store unitary configurations and ML probabilities into X.
ctm=0;
for l=batch_vec
    
    batch_idx=batch{l};
    m=length(batch_idx);
    
    for j=1:m
        
        ctm=ctm+1;
        
        if mod(j,round(0.1*m))==0
            fprintf('%d percent completed for Batch %i\n',j/m*100,l)
        end
        
        load(strcat(batch_raw{l},'raw_data_',int2str(batch_idx(j)),'.mat'));
        load(strcat(batch_raw{l},'state_info_',int2str(batch_idx(j)),'.mat'));
        rho_true=state_info{1}; % Sets target state as true state (right)

        for k=Kmin:Kmax
            if l==1 && j==1
                Xcell{k}=zeros(M,k.*(D.^2+D)+D.^2); % Saves POVM, relative
                                                    % frequencies and
                                                    % target state per row
                ycell{k}=zeros(M,2);
            end
            pom=zeros(D,D,k.*D);
            Uvec=[];
            ct=0;
            for k2=1:k
                U=raw_data{k2,7}; % Loads unitary U that defines the kth 
                                  % basis                
                for k3=1:D
                    ct=ct+1;
                    pom(:,:,ct)=U*std_basis(:,:,k3)*U'./k;
                end
                if k2==1
                    rvec=zeros(1,D.^2);
                else
                    [V,Diag]=eig(U);
                    Diag=diag(log(diag(Diag)));
                    H=-i.*V*Diag*V'; % Hermitian parametrization of U
                    rvec=Herm2vec(H); % Pseudo Bloch vector for H
                end
                Uvec=[Uvec,rvec]; % Stores all measured POVM per row
            end

            pvec=raw_data{k,9}'; % Extracts relative frequencies data            
            
            scvx=real(raw_data{k,6}); % Extracts scvx
            rootML=sqrtm(raw_data{k,5}); % Defines rhoMLmin as a reference 
                                         % ML estimator and computes its root
                                         
            % Computes fidelity between true state and ML estimator
            fid=real(trace(sqrtm(rootML*rho_true*rootML')).^2);
            
            % Extracts the pseudo Bloch vector of the true state
            rvec2=Herm2vec(rho_true); % Extracts target states
            X=real([Uvec,pvec,rvec2]); % Stores POVM, rel. freqs. and tgt.
            y_cont=[scvx,fid]; % Stores scvx and fidelity as outputs
            Xcell{k}(ctm,:)=X;
            ycell{k}(ctm,:)=y_cont;
        end

    end

end

% Saves all results.
for k=Kmin:Kmax
    X=Xcell{k};
    y=ycell{k};
    save(strcat(stor_proc,'X_',int2str(k),'.mat'),'X');
    save(strcat(stor_proc,'y_',int2str(k),'.mat'),'y');
end
