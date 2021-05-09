function [contaminated_y, C_id, contamination_num] = contaminate_label(y,proportion,NN)

total = sum(NN);
contamination_num = ceil(proportion * total);

C_id = randperm(total);

new_y = zeros(size(y));
new_y(C_id(contamination_num+1:total),:) = y(C_id(contamination_num+1:total),:);

load('category_map.mat');

for i = 1:contamination_num
    j = find(y(C_id(i), :) == max(y(C_id(i), :))); %1
    pol_label = randperm(category); %1,2 2,1
    if pol_label(1) ~= j
        new_y(C_id(i),:) = category_rule(pol_label(1),:);
    else 
        new_y(C_id(i),:) = category_rule(pol_label(2),:);
    end
    
end

contaminated_y = new_y;

end