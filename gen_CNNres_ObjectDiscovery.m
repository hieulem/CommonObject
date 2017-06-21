clear;close all;
addpath('./matconvnet-1.0-beta21');
run matconvnet-1.0-beta21/matlab/vl_setupnn ;
net = load('../MatconvCNNmodels/imagenet-vgg-verydeep-16.mat') ;
net = vl_simplenn_tidy(net) ;

%setname = 'Car100.mat';
setname = 'Horse100.mat';
%load(['../dataset/ObjectDiscovery/ObjectDiscovery-data/',setname]);



mkdir(option.cnnrespath);

for i=1:option.nim
    genCNNODim(option,i,net);
end


