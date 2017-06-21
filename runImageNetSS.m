function[stat] = runImageNetSS(cls,K,distance)
addpath('auxiliaries');
warning('off');
cl = { 'n02360282','n02391994','n02442336','n02508021','n04050066','n04576002'};
setname =[cl{cls},'.mat'];

%option.class = setname{cls};
load(['../dataset/SubsetImagenet/',setname]);
option.bdE =1;      % Boundary weight
option.layer = 36;
option.show =1;
option.netmeta = '../MatconvCNNmodels/imagenet-vgg-s.mat';
option.prop_w =0.5; %0.2 is good for Be 1 % was testing with 1
option.threshold = 0.5;
option.smooththreshold = 0.0;
option.K=K;
option.aK = K+1;
option.distance = distance;

option.nfilter = 256;
option.filter = 15;

option.basepath =  fullfile('ImagenetSS',option.class,'vggs');
mkdir(option.spbasepath);
option.respath =  fullfile(option.basepath,'corloc');
mkdir(option.respath);
option.corlocrespath = fullfile(option.respath,'%s_K%d_d%s_th_%0.3f_sth%0.3f_W%0.1f.mat');
option.resultsfile = sprintf(option.corlocrespath,option.class ,option.K,option.distance,option.threshold,option.smooththreshold ,option.prop_w);

clpath = fullfile(option.basepath,'cluster');mkdir(clpath);
option.Kmeansfile = sprintf('%s/%d_%s.mat',clpath,K,option.distance);

if ~exist(option.resultsfile,'file') || option.show ==1
    clear meta windows u_score stats cu_score cn_window windows;
    gen_max_INSS(option);
    load(option.Kmeansfile);
    find(IDX==1)
    option.maxres = maxres;
    %IDX = pgpClustering(maxres, 'orig', 0.6);
    option.K = numel(unique(IDX));
    option.aK=1;
    option.uIDX(:,1) = [IDX == 1];
    
%     option.aK = option.K +1;
%     option.uIDX(:,1) = zeros(1,512);
%     for i=1:option.K
%         option.uIDX(:,i+1) = [IDX == i];
%         if sum(option.uIDX(:,1)) < 30
%             option.uIDX(:,1)  = option.uIDX(:,1) + [IDX == i];
%         end
%     end
    
   
    for i=1:option.nim
        
        i;
        [score,nwinds,wds] = running_func_INSS( option,i,net);
        score
        cu_score{i} =  score;
        if option.show ==1 
            figure(1);
            print(sprintf('qual/%s_1.png',option.imname{i}),'-dpng')
                        figure(2);
            print(sprintf('qual/%s_2.png',option.imname{i}),'-dpng')
            %pause
        end;
    end
    
    u_score=vertcat(cu_score{:});
    
    stat = sum(u_score>0.5) / size(u_score,1);
    save(option.resultsfile,'stat','u_score')
else
    load(option.resultsfile);
    stat
end