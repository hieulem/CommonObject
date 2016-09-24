function [ res ] = get_netres( net,bim,bsize,layer )

ndata = size(bim,4);

nbatch = ceil(ndata / bsize);

for i =1:nbatch
    i
    s = bsize*(i-1) + 1;
    e = min(s + bsize-1,ndata);
    t = vl_simplenn(net,bim(:,:,:,s:e)) ;
    res(:,:,:,s:e) = t(layer).x; 

end


end

