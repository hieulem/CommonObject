clear;close all;
addpath('./matconvnet-1.0-beta21');
run matconvnet-1.0-beta21/matlab/vl_setupnn ;
net = load('../MatconvCNNmodels/imagenet-vgg-verydeep-19.mat') ;
net = vl_simplenn_tidy(net) ;
datasetpath = 'caltech';
dataset = dir(datasetpath);
for c =64:64
if dataset(c).name(1) ~= '.'
    path = ['caltech/', dataset(c).name]
    gen_res_all_layers(net,path);
end
end

