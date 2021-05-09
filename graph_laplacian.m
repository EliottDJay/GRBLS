function L = graph_laplacian(y,x,k)

num = size(y,1);
Vw = zeros(num, num);
Nt = 1;

for i=1:num
    for j=1:num
        if y(i,:) == y(j,:)
            Vw(i,j) = Nt;
        else
            Vw(i,j) = 0;
        end
    end
end

Sw=sum(Vw,2);
Dw=diag(Sw);
Lw=Dw-Vw;
Lp = nlkn(x,y,k);
L = (Lp^(-1/2))'*Lw*(Lp^(-1/2));
end