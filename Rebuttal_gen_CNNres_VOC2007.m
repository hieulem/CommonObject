clear;close all;
addpath('./matconvnet-1.0-beta21');
run matconvnet-1.0-beta21/matlab/vl_setupnn ;
net = load('../MatconvCNNmodels/imagenet-caffe-alex.mat') ;
%imagenet-caffe-ref
net = vl_simplenn_tidy(net) ;

addpath(fullfile('..','dataset','VOCdevkit2007'));
addpath(fullfile('..','dataset','VOCdevkit2007','VOCcode'));

load('VOC2007_trainval_info.mat');
load('VOC2007_opts.mat');

cpath = fullfile('VOC2007','trainval','AlexNetFull');
mkdir(cpath);
parfor i=1:length(recs)
    fprintf('%d/%d \n',i,length(recs));
    extractCNNVOC(i,recs,cpath,net,VOCopts);
end;

