function[] = FT_6ho_alex(cls,K,kd,iter)
%poolobj = gcp('nocreate');
%delete(poolobj);i
switch kd
case 1
    distance = 'sqeuclidean';
case 2
    distance ='cityblock';
end;
addpath('auxiliaries');
warning('off');
cl = { 'n02360282','n02391994','n02442336','n02508021','n04050066','n04576002'};
setname =[cl{cls},'.mat'];

%option.class = setname{cls};
load(['../dataset/SubsetImagenet/',setname]);
option.bdE =1;      % Boundary weight

option.show =0;
option.netmeta = 'netmeta_alexnet.mat';


option.prop_w =0.5; %0.2 is good for Be 1 % was testing with 1
option.threshold = 0.5;
option.smooththreshold = 0.0;
option.K=K;
option.aK = K+1;
option.distance = distance;

option.nfilter = 256;
option.filter = 15;
option.layer = 15;


option.basepath =  fullfile('ImagenetSS',option.class,'alexnet');
mkdir(option.spbasepath);
option.respath =  fullfile(option.basepath,'corloc');
mkdir(option.respath);
option.corlocrespath = fullfile(option.respath,'%s_K%d_d%s_th_%0.3f_sth%0.3f_W%0.1f.mat');
option.resultsfile = sprintf(option.corlocrespath,option.class ,option.K,option.distance,option.threshold,option.smooththreshold ,option.prop_w);

clpath = fullfile(option.basepath,'cluster');mkdir(clpath);
option.Kmeansfile = sprintf('%s/%d_%s.mat',clpath,K,option.distance);

%if ~exist(option.resultsfile,'file')
cmax =0;

for it=1:iter
        if exist(option.resultsfile,'file')
        load(option.resultsfile);
        cmax = max(stats.corloc(1:2))
        
   end;
    clear meta windows u_score stats cu_score cn_window windows;
    gen_max_INSS(option);
    load(option.Kmeansfile);
    option.maxres = maxres;

    option.aK = option.K+1;
    option.uIDX(:,1) = zeros(1,option.nfilter);

    for i=1:option.aK
        option.uIDX(:,i+1) = [IDX == i];
        if sum(option.uIDX(:,1)) < 30
            option.uIDX(:,1)  = option.uIDX(:,1) + [IDX == i];
        end        
    end
    
    parfor imn=1:option.nim

        [score,nwinds,wds] = running_func_INSS( option,imn);
        score;
        cu_score{imn} =  score;
        cn_window{imn} =  nwinds;
        windows{imn} = wds;
        %pause

    end;
    u_score=vertcat(cu_score{:});
    n_window = vertcat(cn_window{:});
    stats.corloc = sum(u_score>=0.5) / option.nim;
    stats.nwindows  = mean(n_window);
    stats.corloc
    if max( stats.corloc(1:2)) > cmax
        KmeanID = option.uIDX;
        disp('saving');
        save(option.resultsfile,'u_score','windows','n_window','stats','KmeanID');
    end
end
    
    %end

