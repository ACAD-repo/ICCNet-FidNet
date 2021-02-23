function [rho_opt,opt_fval]=ICC_sdp(pom_meas, data_vec, Z, opt)

% Executes an SDP that either minimizes or maximizes the linear function
% f=tr{rho Z} depending on the value of opt. If opt=0, SDP minimizes the
% linear function. Otherwise, a maximization is carried out. The CVX
% package is needed.

dims=size(pom_meas);
if length(dims)==3
    M=dims(3); % Number of measurement outcomes
else
    M=1;
end
dim=length(pom_meas(:,:,1)); % Hilbert-space dimension

% Executes semidefinite programming.
cvx_solver sedumi
cvx_begin quiet
    variable X(dim,dim) hermitian
    if opt==0
        minimize(real(sum(sum(X.*Z.'))));
    else
        maximize(real(sum(sum(X.*Z.'))));
    end
    subject to
    X==hermitian_semidefinite(dim); % Positivity constraint
    trace(X)==1; % Unit-trace constraint
    for l=1:M
        % ML-probability constraints
        real(sum(sum(X.*pom_meas(:,:,l).')))==data_vec(l);
    end
cvx_end

rho_opt=X;
opt_fval=real(sum(sum(rho_opt.*Z.')));

end