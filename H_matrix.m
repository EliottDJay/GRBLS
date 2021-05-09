function  D = H_matrix(W, x, y)
num = size(y,1);
E = y - x*W;

e = sqrt(sum(E.^2,2));
e = 1./e;

D = diag(e);

end