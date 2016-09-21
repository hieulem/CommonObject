function [ res ] = get_netres( net,bim,bsize )

ndata = size(bim,4);

nbatch = ceil(ndata / bsize);

for i =1:nbatch
    s = bsize*(i-1) + 1;
    e = min(s + bsize-1,ndata);
    t = vl_simplenn(net,bim(:,:,:,s:e)) ;
    nlayers = size(t,2);
    for i=1:nlayers
        res(i).x(:,:,:,s:e) = t(i).x; 
    end
end


end

