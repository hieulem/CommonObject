function[stat] = runObjectDiscovery(cls,K,distance)
addpath('auxiliaries');
addpath('pgp_clustering');
warning('off');
setname = {'Airplane100','Car100','Horse100'};
%option.dataset = setname{cls};
load(['../dataset/ObjectDiscovery/ObjectDiscovery-data/',setname{cls}]);
option.bdE =1;      % Boundary weight
option.layer = 36;
option.show =0;
option.netmeta = 'netmeta.mat';
option.prop_w =0.5; %0.2 is good for Be 1 % was testing with 1
option.threshold = 0.25;
option.K=K;
option.aK = K+1;
option.distance = distance;

option.basepath =  fullfile('ObjectDiscovery',option.dataset);
mkdir(option.spbasepath);
option.respath =  fullfile(option.basepath,'corlocCP');
mkdir(option.respath);
option.corlocrespath = fullfile(option.respath,'%s_K%d_d%s_th_%0.3f_W%0.1f.mat');
option.resultsfile = sprintf(option.corlocrespath,option.dataset ,option.K,option.distance,option.threshold,option.prop_w);

clpath = fullfile(option.basepath,'cluster');mkdir(clpath);
option.Kmeansfile = sprintf('%s/%d_%s.mat',clpath,K,option.distance);

if ~exist(option.resultsfile,'file')
    clear meta windows u_score stats cu_score cn_window windows;
    gen_maxOD(option);
    load(option.Kmeansfile);
    option.maxres = maxres;
    IDX = pgpClustering(maxres, 'orig', 0.6);
    option.K = numel(unique(IDX));
    option.aK = option.K +1;
    option.uIDX(:,1) = zeros(1,512);
    for i=1:option.K
        option.uIDX(:,i+1) = [IDX == i];
        if sum(option.uIDX(:,1)) < 30
            option.uIDX(:,1)  = option.uIDX(:,1) + [IDX == i];
        end
    end
    
    parfor i=1:option.nim
        [score,nwinds,wds] = running_funcOD( option,i);
        cu_score{i} =  score;
%        cn_window{i} =  nwinds;
   %     windows{i} = wds;
        %pause
    end
    
    u_score=vertcat(cu_score{:});
    u_score = u_score(option.validim==1,:);
    stat = sum(u_score>0.5) / size(u_score,1);
    save(option.resultsfile,'stat')
    
end