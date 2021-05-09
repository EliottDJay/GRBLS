function [train_x,train_y,test_x,test_y,NN] = shuffle_index(x,y,train_num,test_num)
rng('shuffle');
x = x';
gross = train_num + test_num ;

category_box = unique(y);
category_box = sort(category_box);
category = size(category_box,1);

category_rule = zeros(category, category);
for i=1:category
    category_rule(i,i)=1;
end
save('category_map.mat','category','category_box','category_rule')

len = size(y);
rand_id = randperm(len(1));

train_x = x(:, rand_id(1:train_num));
train_y = y(rand_id(1:train_num), :);

test_x = x(:, rand_id(train_num+1:gross));
test_y = y(rand_id(train_num+1:gross), :);

[train_x, PS] = mapminmax(train_x);
test_x = mapminmax('apply', test_x, PS);

train_x = train_x';
test_x = test_x';

train_y1 = zeros(size(train_y, 1), category);
test_y1 = zeros(size(test_y, 1), category);

NN.train = zeros(1,category);   % number of two category
NN.test = zeros(1,category);


for i=1:size(train_y, 1)
    for j=1:category
        if train_y(i, 1) == category_box(j, 1)
           train_y1(i, j) = 1; 
           NN.train(1,j) = NN.train(1,j)+1;
        end
    end
end

for i=1:size(test_y, 1)
    for j=1:category
        if test_y(i, 1) == category_box(j, 1)
           test_y1(i, j) = 1; 
           NN.test(1,j) = NN.test(1,j)+1;
        end
    end
end

train_y = train_y1;
test_y = test_y1;

end