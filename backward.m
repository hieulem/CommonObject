function [ res ] = backward( layers, map, truesize )

if strcmp(layers{1}.type,'relu')
    res = map;
    return
end;


if strcmp(layers{1}.type,'conv') || strcmp(layers{1}.type,'pool')
    res = imresize(map,[size(map,1) *layers{1}.stride(1) ,size(map,2) * layers{1}.stride(2)]);
        
    res(1:layers{1}.pad(1),:) = [];
    res((end-layers{1}.pad(2)+1):end,:) = [];
    
    res(:,1:layers{1}.pad(3)) = [];
    res(:,(end-layers{1}.pad(4) +1) : end) = [];
     
end;

if strcmp(layers{1}.type,'conv') 
    shiftx = (layers{1}.size(1)-1) /2;
    shifty = (layers{1}.size(2)-1) /2;
    res = padarray(res,[shiftx,shifty],'both');
    
%     res =[zeros(shiftx,size(res,2));res];
%     res =[res;zeros(shiftx,size(res,2))];
%     res =[zeros(size(res,1),shifty),res];
%     res =[res,zeros(size(res,1),shifty)];
end

if strcmp(layers{1}.type,'pool') 
    res((end+1):(end+layers{1}.pool(1)-1),:) =0;
     res(:,(end+1):(end+layers{1}.pool(2)-1)) =0;
end

res(truesize(1)+1:end,:) = [];
res(:,truesize(2)+1:end) = [];


end

