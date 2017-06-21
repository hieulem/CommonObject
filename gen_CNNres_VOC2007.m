clear;close all;
addpath('./matconvnet-1.0-beta21');
run matconvnet-1.0-beta21/matlab/vl_setupnn ;
net = load('../MatconvCNNmodels/imagenet-vgg-verydeep-19.mat') ;
net = vl_simplenn_tidy(net) ;

addpath(fullfile('..','dataset','VOCdevkit2007'));
addpath(fullfile('..','dataset','VOCdevkit2007','VOCcode'));

load('VOC2007_trainval_info.mat');
%VOCinit;
load('VOC2007_opts.mat');

cpath = fullfile('VOC2007','trainval','CNNres');
mkdir(cpath);
for i=1:length(recs)
    i
    extractCNNVOC(i,recs,cpath,net,VOCopts);
    
%     fprintf('%d/%d \n',i,length(recs));
%     %    figure(i)
%     imgname = recs(i).filename(1:6);
%     if ~exist(fullfile(cpath,[imgname,'.mat']),'file')
%         im = imread(sprintf(VOCopts.imgpath,imgname));
%         size(im);
%         
%         if size(im,1) < net.meta.normalization.imageSize(1)
%             im = imresize(im,'OutputSize', [net.meta.normalization.imageSize(1),NaN]);
%         end;
%         if size(im,2) < net.meta.normalization.imageSize(2)
%             im = imresize(im,'OutputSize', [NaN,net.meta.normalization.imageSize(2)]);
%         end;
%         %size(im)
%         im = single(im);
%         im = im - repmat(  net.meta.normalization.averageImage,[size(im,1),size(im,2),1]);
%         %    figure(i);
%         %   image(im);
%         X = vl_simplenn(net,im);
%         %size(X)
%         for ii=1:length(X)
%             X(ii).sz = size(X(ii).x);
%             if ii~=36
%                 X(ii).x = [];
%             end
%         end
%         save(fullfile(cpath,imgname),'X');
%     end;
end;
