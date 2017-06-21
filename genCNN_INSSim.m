function [ ] = genCNN_INSSim( option,imn,net )

im = imread(option.impath{imn});


if size(im,1) >2000 || size(im,2) >2000
    im = imresize(im,'OutputSize', [net.meta.normalization.imageSize(1),NaN]);
end;
size(im);
if size(im,3) ==1
    im = repmat(im,[1,1,3]);
end

if size(im,1) < net.meta.normalization.imageSize(1)
    im = imresize(im,'OutputSize', [net.meta.normalization.imageSize(1),NaN]);
end;
if size(im,2) < net.meta.normalization.imageSize(2)
    im = imresize(im,'OutputSize', [NaN,net.meta.normalization.imageSize(2)]);
end;
%size(im)
im = single(im);
if length(size(net.meta.normalization.averageImage)) ==3
     net.meta.normalization.averageImage = mean(mean(net.meta.normalization.averageImage,1),2);
end;
im = im - repmat(  net.meta.normalization.averageImage,[size(im,1),size(im,2),1]);
%    figure(i);
%   image(im);
X = vl_simplenn(net,im);
%size(X)
for ii=1:length(X)
    X(ii).sz = size(X(ii).x);
    if ii~=option.layer
        X(ii).x = [];
    end
end
save(option.imcnnres{imn},'X');

end

