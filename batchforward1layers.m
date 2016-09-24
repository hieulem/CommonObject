function [ res ] = batchforward1layers( net,bim,bsize,layer )

ndata = size(bim,4);

nbatch = ceil(ndata / bsize);
res =[];
for i =1:nbatch
    s = bsize*(i-1) + 1;
    e = min(s + bsize-1,ndata);
    t = vl_simplenn(net,bim(:,:,:,s:e)) ;
    if isempty(res)
        res = single(zeros(size(t(2).x,1),size(t(2).x,2),size(t(2).x,3),ndata));
    end;
    res(:,:,:,s:e) = t(layer).x; 
end


end

