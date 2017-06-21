function []=gen_CNNres_ImageNetSS(k,CNNpath)
addpath('./matconvnet-1.0-beta21');

run matconvnet-1.0-beta21/matlab/vl_setupnn ;
net = load('../MatconvCNNmodels/imagenet-vgg-verydeep-19.mat') ;

net = vl_simplenn_tidy(net) ;

cl = { 'n02360282','n02391994','n02442336','n02508021','n04050066','n04576002'};

setname =[cl{k},'.mat'];
here =pwd;
cd('../dataset/SubsetImagenet/');
INsubsetreadinput(k,'CNNres_vgg19');
cd(here);
load(['../dataset/SubsetImagenet/',[CNNpath,setname]]);
mkdir(option.cnnrespath);
option.layer =36;

for i=1:option.nim
    fprintf('%d/ %d \n',i,option.nim);
    if ~exist(option.imcnnres{i},'file')
        genCNN_INSSim(option,i,net);
    end;
end

% runImageNetSS(k,5,'cityblock');
