clear;close all;
addpath('./matconvnet-1.0-beta21');
run matconvnet-1.0-beta21/matlab/vl_setupnn ;
net = load('../MatconvCNNmodels/imagenet-vgg-verydeep-19.mat') ;
net = vl_simplenn_tidy(net) ;

addpath(fullfile('..','dataset','VOCdevkit'));
addpath(fullfile('..','dataset','VOCdevkit','VOCcode'));

load('VOC_val_info.mat');
load('VOC_opts.mat');

cpath = fullfile('VOC2012','val','CNNres');
mkdir(cpath);

for i=1:1%length(recs)
    fprintf('%d/%d \n',i,length(recs));
    %    figure(i)
    imgname = recs(i).filename(1:11)
    im = imread(sprintf(VOCopts.imgpath,recs(i).filename(1:11)));
	size(im)
    
    if size(im,1) < net.meta.normalization.imageSize(1)
	    im = imresize(im,'OutputSize', [net.meta.normalization.imageSize(1),NaN]);
	end;
	if size(im,2) < net.meta.normalization.imageSize(2)
	    im = imresize(im,'OutputSize', [NaN,net.meta.normalization.imageSize(2)]);
	end;
    size(im)
    im = single(im);      
    im = im - repmat(  net.meta.normalization.averageImage,[size(im,1),size(im,2),1]);
%    figure(i);
 %   image(im);
    X = vl_simplenn(net,im);
    size(X)
    for i=1:length(X)
        X(i).sz = size(X(i).x);
        if i<20
            X(i).x = [];
        end
    end
    save(fullfile(cpath,imgname),'X');
end;
