clear;close all;
addpath('./matconvnet-1.0-beta21');
run matconvnet-1.0-beta21/matlab/vl_setupnn ;
net = load('../MatconvCNNmodels/imagenet-caffe-alex.mat') ;
%imagenet-caffe-ref
net = vl_simplenn_tidy(net) ;


for i=1:size(net.layers,2)
    if i~=16
        net.layers{i}.weights = [];
    end
end

%save('netmeta_alexnet_fc.mat','net')
