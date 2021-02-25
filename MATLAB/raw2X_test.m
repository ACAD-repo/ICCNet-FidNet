clear all;clc

% Process simulated example data for testing (see raw2X_right.m for comments)

% Packs data from ACT and random Haar simulations into MATLAB cell files
% for use with Python scripts.

m=50;
D=16;
std_basis=pom_gen(D,D,1);

Kmin=1; 
Kmax=10;

labels={'test_ex_Haar_N_1000','test_ex_Haar','test_ex_ACT_N_1000','test_ex_ACT'};

for rnk_st=1:3
    
    for labs=1:4
        work_dir=labels{labs}

        stor_proc=strcat('../raw_test_examples/',work_dir,'_rnk_',int2str(rnk_st),'/D',int2str(D),...
            '/proc_data/',int2str(m),'_ex/') 
        mkdir(stor_proc);

        Xcell=cell(Kmax-Kmin+1,1);
        ycell=cell(Kmax-Kmin+1,1);

        ctm=0;
        for j=1:m
            j
            ctm=ctm+1;

            load(strcat('../raw_test_examples/',work_dir,'_rnk_',int2str(rnk_st),'/D',int2str(D),...
                '/raw_data/raw_data_',int2str(j),'.mat'));
            load(strcat('../raw_test_examples/',work_dir,'_rnk_',int2str(rnk_st),'/D',int2str(D),...
                '/raw_data/state_info_',int2str(j),'.mat'));
            rho_ref=state_info{1};

            for k=Kmin:Kmax
                if j==1
                    Xcell{k}=zeros(m,k.*(D.^2+D)+D.^2);
                    ycell{k}=zeros(m,2);
                end
                pom=zeros(D,D,k.*D);
                Uvec=[];
                ct=0;
                for k2=1:k
                    U=raw_data{k2,7};
                    for k3=1:D
                        ct=ct+1;
                        pom(:,:,ct)=U*std_basis(:,:,k3)*U'./k;
                    end
                    if k2==1
                        rvec=zeros(1,D.^2);
                    else
                        [V,Diag]=eig(U);
                        Diag=diag(log(diag(Diag)));
                        H=-i.*V*Diag*V';
                        rvec=Herm2vec(H);
                    end
                    Uvec=[Uvec,rvec];
                end
                pvec=raw_data{k,9}';
                rootML=sqrtm(raw_data{k,5});

                fid=real(trace(sqrtm(rootML*rho_ref*rootML')).^2);
                rvec2=Herm2vec(rho_ref);
                X=real([Uvec,pvec,rvec2]);
                y_cont=[real(raw_data{k,6}),fid];
                Xcell{k}(ctm,:)=X;
                ycell{k}(ctm,:)=y_cont;
            end

        end

        for k=Kmin:Kmax
            X=Xcell{k};
            y_cont=ycell{k};
            save(strcat(stor_proc,'X_',int2str(k),'.mat'),'X');
            save(strcat(stor_proc,'y_cont_',int2str(k),'.mat'),'y_cont');
        end
    end
end