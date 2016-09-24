clear;close all;
addpath('./matconvnet-1.0-beta21');
run matconvnet-1.0-beta21/matlab/vl_setupnn ;
net = load('../MatconvCNNmodels/imagenet-vgg-verydeep-19.mat') ;
net = vl_simplenn_tidy(net) ;
datasetpath = 'caltech';
dataset = dir(datasetpath);
parfor c =1:length(dataset)
if dataset(c).name(1) ~= '.'
    path = ['caltech/', dataset(c).name]
    for i=35:37
        gen_res(net,path,i)
    end
end
end

