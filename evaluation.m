function rate = evaluation(Netout, y, num)
row = size(Netout,1);
col = size(Netout,2);

Net_mir = zeros(row,col);
total = 0;

for i = 1:row
    j = find( Netout(i,:) == max(Netout(i,:)) );
    if Netout(i,j)==min(Netout(i,:))
        Net_mir(i,j) = 0;   %防止出现等概率，不过基本上不存在吧
    else
        Net_mir(i,j) = 1;
    end
end

for i = 1:row
    if sum(Net_mir(i,:)) ~= 0
        if Net_mir(i, :) == y(i, :)
            total = total + 1;
        end
    end
end

rate = total/sum(num);
end