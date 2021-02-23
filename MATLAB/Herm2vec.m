function r=Herm2vec(H)

% Obtains the pseudo Bloch vector parametrization of a Hermitian matrix.

D=length(H);
uH=triu(H+(1+i).*1e-8-i.*eye(D).*1e-8,1);
r=nonzeros([real(diag(H)'),reshape(real(uH),[1 D.^2]),...
    reshape(imag(uH),[1 D.^2])])';

end