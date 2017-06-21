function [ ] = genCNNODim( option,imn,net )

im = imread(option.impath{imn});
size(im);

if size(im,1) < net.meta.normalization.imageSize(1)
    im = imresize(im,'OutputSize', [net.meta.normalization.imageSize(1),NaN]);
end;
if size(im,2) < net.meta.normalization.imageSize(2)
    im = imresize(im,'OutputSize', [NaN,net.meta.normalization.imageSize(2)]);
end;
%size(im)
im = single(im);
im = im - repmat(  net.meta.normalization.averageImage,[size(im,1),size(im,2),1]);
%    figure(i);
%   image(im);
X = vl_simplenn(net,im);
%size(X)
for ii=1:length(X)
    X(ii).sz = size(X(ii).x);
    if ii~=36
        X(ii).x = [];
    end
end
save(option.imcnnres{imn},'X');

end

