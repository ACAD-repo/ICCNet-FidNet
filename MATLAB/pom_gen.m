function [pom] = pom_gen(dim,M,rnk)

% Generates random basis measurements with Haar unitaries.
% First basis is always the standard computational one.

%%
Nbas=round(M/dim); % Number of bases
pom=zeros(dim,dim,M); % Defines the full POM
ident_mat=eye(dim);
gop=zeros(dim,dim);
ct=0;
for j=1:Nbas
    if j==1
        U_mat=eye(dim);
    else
        Amat=randn(dim,dim)+i*randn(dim,dim);
        [Q,R]=qr(Amat);
        r=diag(R);
        L=diag(r./abs(r));
        U_mat=Q*L;
    end
    for k=1:dim
        ct=ct+1;
        pom(:,:,ct)=U_mat*ident_mat(:,k)*ident_mat(:,k)'*U_mat'./Nbas;
        gop=gop+pom(:,:,ct);
    end
end

gop;
    
end