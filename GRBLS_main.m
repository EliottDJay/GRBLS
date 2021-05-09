clear;
warning off all;
format compact;

if ~exist('num.mat','file')
   experiment_num=0;
else 
    load('num.mat');  %记录实验次数，这样生成数据的时候就不会覆盖之前的数据了
end

prop  = 0.4  ;
train_num = 430;
test_num = 253;

load('dataset\breast_cancer.mat');
[train_x,train_y,test_x,test_y,NN] = shuffle_index(x,y,train_num,test_num);
[contaminated_train_y, C_id, contamination_num] = contaminate_label(train_y,prop,NN.train);
save('C_id.mat','C_id','contamination_num');
clear x y C_id

lambda1 = 2^(0);  %------manifold learning criterion
lambda2 = 2^(-5);   %------the regularization parameter
best_test = 0 ;
result = [];
k = 10;             %-------k-NN
options = [];
options.NeighborMode = 'KNN';
options.k = k;
options.WeightMode = 'Binary';
options.t = 1;
file_name_1 = ['test_result/test_result ',num2str(experiment_num),'/contamination_proportion ', num2str(prop)];

for NumFea= 1:7              %searching range for feature nodes  per window in feature layer
    for NumWin=1:8           %searching range for number of windows in feature layer
        file_name = [file_name_1 ,'/NumFea ',num2str(NumFea),'/NumWin ', num2str(NumWin)];
            if ~isfolder(file_name)
                mkdir(file_name);
            end
            
        for NumEnhan=2:50     %searching range for enhancement nodes
            
            clc;
            rng('shuffle');
            for i=1:NumWin
                WeightFea=2*rand(size(train_x,2)+1,NumFea)-1;
                %   b1=rand(size(train_x,2)+1,N1);  % sometimes use this may lead to better results, but not for sure!
                WF{i}=WeightFea;
            end                                                          %generating weight and bias matrix for each window in feature layer
             WeightEnhan=2*rand(NumWin*NumFea+1,NumEnhan)-1;
             fprintf(1, 'Fea. No.= %d, Win. No. =%d, Enhan. No. = %d\n', NumFea, NumWin, NumEnhan);
             [train_rate,test_rate,C_train_rate,NetoutTrain,NetoutTest] = GRBLS_train(train_x,train_y,contaminated_train_y,test_x,test_y,lambda1,lambda2,WF,WeightEnhan,NumFea,NumWin,NN,options);
             result = [result;NumEnhan, train_rate, test_rate, C_train_rate];
             if test_rate > best_test
                 best_test = test_rate;
                 load('C_id.mat');
                 save(fullfile(file_name_1,['contamination_proportion ', num2str(prop), ' best_result.mat']),'best_test','train_rate','C_train_rate','NumFea','NumWin','NumEnhan','lambda1','lambda2','k',...
                     'train_x','train_y','test_x','test_y','contaminated_train_y','NetoutTrain','NetoutTest','C_id','prop');
             end
             clearvars -except train_x train_y test_x test_y lambda1 lambda2 WF WeightEnhan NumFea NumWin NumEnhan NN best_test experiment_num ...
             k result file_name file_name_1 contaminated_train_y prop options
        end
        result_plot(result,file_name);
        clear result
        result = [];
    end
end

experiment_num=experiment_num+1;
save('num.mat','experiment_num');