function [Lp]=nlkn(x,y,k)
load('category_map.mat');
num = size(y,1);
Vp=zeros(num,num);
Nt=1;
for i=1:num
    A=[];
    for j=1:num
        Dist=sqrt((x(i,:)-x(j,:))*(x(i,:)-x(j,:))');
        if y(i, :)==y(j, :)
            Dist=Inf;
        end
        A=[A;Dist];
    end
    [~,pos]=sort(A','ASCEND');
    for h=1:k
        Vp(i,pos(1,h))=Nt;
    end
    clear A;
end
Sp=sum(Vp,2);
Dp=diag(Sp);
Lp=Dp-Vp;

end