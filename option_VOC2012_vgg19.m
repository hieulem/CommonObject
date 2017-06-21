

ldistance = {'cityblock','sqeuclidean','cosine'};
distance = ldistance{idistance};
addpath('auxiliaries');
warning('off');
option.dataset = 'trainval';
option.clsi =cls;
option.sm =1;
option.data = 'VOC2012';
option.devkit ='VOCdevkit2012';
kkkkk=pwd;
cd(fullfile('..','dataset',option.devkit));
addpath(fullfile('VOCcode'));VOCinit;
cd(kkkkk);
option.cls = VOCopts.classes{option.clsi};
option.imlistpath = fullfile(option.data,option.dataset,'imlist',option.cls); load(fullfile(option.imlistpath,'imlist.mat'));

option.recs_class = recs_class;
option.VOCopts = VOCopts;
option.nim = length(recs_class);
option.bdE =2;      % Boundary weight
option.layer = 36;
option.fc  = 0; % 1 if using fc layer.
option.nfilter = 512;
option.show =1;
option.saveflag = true;
option.CNNrespath =fullfile(option.data,'trainval','CNNres_vgg19');
option.netmeta = '../MatconvCNNmodels/imagenet-vgg-verydeep-19';
option.sppath = fullfile(option.data,'sp','%s_%d.mat');
option.prop_w =1; %0.2 is good for Be 1 % was testing with 1
option.threshold = 0.25;
option.smooththreshold = 0.2;
option.bordercut = 0;
option.K=K;
option.aK = K+1;
option.distance = distance;
option.basepath =  fullfile(option.data,option.dataset,'vgg19');
option.respath =  fullfile(option.basepath,'corloc');
mkdir(option.respath);
option.corlocrespath =fullfile(option.respath,'%s_K%d_d%s_th_%0.3f_sth_%0.3f_W%0.3f.mat');
option.resultsfile = sprintf(option.corlocrespath,option.cls,option.K,option.distance,option.threshold,option.smooththreshold,option.prop_w);

clpath = fullfile(option.basepath,'cluster',option.cls);mkdir(clpath);
option.Kmeansfile = sprintf('%s/%s_%d_%d_%s.mat',clpath,option.cls,option.layer,K,option.distance);

if option.fc==1
    net = load(option.netmeta);
    ww = net.layers{16}.weights{1};
    option.simplifed_w_from_conv_2_fc = squeeze(sum(squeeze(sum(ww,1)),1));
    
    
    temp1 = max(option.simplifed_w_from_conv_2_fc);
    temp1 = repmat(temp1,256,1);
     temp2 = min(option.simplifed_w_from_conv_2_fc);
    temp2 = repmat(temp2,256,1);
    option.simplifed_w_from_conv_2_fc = (option.simplifed_w_from_conv_2_fc- temp2)./(temp1-temp2)*4 -2;
end



