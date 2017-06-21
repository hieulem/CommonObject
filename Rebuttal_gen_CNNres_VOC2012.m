clear;close all;
addpath('./matconvnet-1.0-beta21');
run matconvnet-1.0-beta21/matlab/vl_setupnn ;
net = load('../MatconvCNNmodels/imagenet-vgg-verydeep-16.mat') ;
%imagenet-caffe-ref
net = vl_simplenn_tidy(net) ;

addpath(fullfile('..','dataset','VOCdevkit'));
addpath(fullfile('..','dataset','VOCdevkit','VOCcode'));

load('VOC_trainval_info.mat');
load('VOC2012opts.mat');

cpath = fullfile('VOC2012','trainval','CNNres_vgg16');
mkdir(cpath);

for i=1:length(recs)
    fprintf('%d/%d \n',i,length(recs));
    extractCNNVOC(i,recs,cpath,net,VOCopts);
end;


for i=1:size(net.layers,2)
    net.layers{i}.weights=[];
end
save('netmeta_vgg16','net');
