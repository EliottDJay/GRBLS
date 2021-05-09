function [train_rate,test_rate,C_train_rate,NetoutTrain,NetoutTest] = GRBLS_train(train_x,train_y,contaminated_train_y,test_x,test_y,lambda1,lambda2,WF,WeightEnhan,NumFea,NumWin,NN,options)

%L_train = graph_laplacian(contaminated_train_y, train_x,k);
W = constructW(train_x, options);
DCol = full(sum(W,2));
D = spdiags(DCol,0,speye(size(W,1)));
L_train = D - W;


H1 = [train_x,  0.1 * ones(size(train_x,1),1)];   
y=zeros(size(train_x,1),NumWin*NumFea);
for i=1:NumWin
    WeightFea=WF{i};
    A1 = H1 * WeightFea;
    clear WeightFea;
    WeightFeaSparse  = sparse_bls(A1,H1,1e-3,50)';
    WFSparse{i}=WeightFeaSparse;
    T1 = H1 * WeightFeaSparse;
    y(:,NumFea*(i-1)+1:NumFea*i)=T1;
end
clear T1 H1 A1;

H2 = [y,  ones(size(y,1),1)];
T2 = H2 * WeightEnhan;
T2 = 1./(1+exp(-T2));
clear H2 ;
A = [y, T2];
clear T2;
W_ini = (A'  *  A) \ ( A'  *  contaminated_train_y); 

D = H_matrix(W_ini,A,contaminated_train_y);

Weight = (A' * D *  A + lambda1 * A' * L_train *  A + lambda2 * eye( size(A,2) )) \ ( A'* D * contaminated_train_y); 
disp('Training has been finished!');
NetoutTrain = A * Weight;

train_rate = evaluation(NetoutTrain, train_y, NN.train);
C_train_rate = evaluation(NetoutTrain, contaminated_train_y, NN.train);
clear A;

HH1 = [test_x .1 * ones(size(test_x,1),1)];
yy1=zeros(size(test_x,1),NumWin*NumFea);
for i=1:NumWin
    WeightFeaSparse=WFSparse{i};
    TT1 = HH1 * WeightFeaSparse;
    clear WeightFeaSparse;
    yy1(:,NumFea*(i-1)+1:NumFea*i)=TT1;
end

clear TT1 HH1;
HH2 = [yy1 1 * ones(size(yy1,1),1)];
TT2 = 1./(1+exp(-HH2 * WeightEnhan));
TT3=[yy1 TT2];
clear HH2 TT2;

NetoutTest = TT3 * Weight;
test_rate = evaluation(NetoutTest, test_y, NN.test);
disp('Testing has been finished!');

end