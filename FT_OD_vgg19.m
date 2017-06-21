function[ss] = FT_OD_vgg19(cls,K,kd,iter,th1,th2,just_checking)
addpath('auxiliaries');
addpath(genpath('GoPCode'));
warning('off');
setname = {'Airplane100','Car100','Horse100'};
colormap jet
CNNmodel = 'vgg19';
load(['../dataset/ObjectDiscovery/ObjectDiscovery-data/',CNNmodel,setname{cls}]);
option.class=setname{cls};
if exist('th1','var')    option.prop_w = th1;
else    option.prop_w = 0.5;
end;

if exist('th2','var')    option.threshold= th2;
else    option.threshold = 0.3;
end;

switch kd
    case 1
        distance = 'sqeuclidean';
    case 2
        distance ='cityblock';
end;
option.bdE =1;      % Boundary weight
option.layer = 36;
option.show =0;

option.fc=0;
option.bordercut =0.0;

option.netmeta = '../MatconvCNNmodels/imagenet-vgg-verydeep-19.mat';
option.smooththreshold = 0.1;
option.K=K;
option.aK = K+1;
option.distance = distance;

option.nfilter = 512;
%option.filter = 36;
option.layer = 36;

option.basepath =  fullfile('ObjectDiscovery',option.class,'vgg19');
mkdir(option.spbasepath);
option.respath =  fullfile(option.basepath,'corloc');
mkdir(option.respath);
option.corlocrespath =fullfile(option.respath,'%s_K%d_d%s_th_%0.3f_sth%0.3f_W%0.3f_BC_%0.3f.mat');
option.resultsfile = sprintf(option.corlocrespath,option.class,option.K,option.distance,option.threshold,option.smooththreshold,option.prop_w,option.bordercut);

if exist('just_checking','var') && exist(option.resultsfile,'file')
    load(option.resultsfile);
    ss = stats.corloc
    return;
end

clpath = fullfile(option.basepath,'cluster');mkdir(clpath);
option.Kmeansfile = sprintf('%s/%d_%s.mat',clpath,K,option.distance);
net =load(option.netmeta);
%if ~exist(option.resultsfile,'file')
cmax =0;

for it=1:iter
    if exist(option.resultsfile,'file')
        load(option.resultsfile);
        cmax = max(stats.corloc(1:2))
        
    end;
    clear meta windows u_score stats cu_score cn_window windows;
    gen_maxOD(option);
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
    corloc_score = zeros(option.nim,size(option.uIDX,2));
    J_score = zeros(option.nim,size(option.uIDX,2));
    if option.show ==0
        for i=1:option.nim
            [CorLoc,Jaccard,~] = running_funcOD( option,i,net);
            % score
            Jaccard;
            J_score(i,:) =Jaccard;
            corloc_score(i,:) =  CorLoc;
            %pause;
        end
    end;
    
    if option.show ==1
        for i=1:option.nim
            [CorLoc,Jaccard,~] = running_funcOD( option,i,net);
            J_score(i,:) =Jaccard;
            corloc_score(i,:) =  CorLoc;
            pause;
        end
    end
    corloc_score = corloc_score(option.validim==1,:);
    J_score = J_score(option.validim==1,:);
    stats.corloc = sum(corloc_score>=0.5) / size(corloc_score,1);
    stats.Jaccard = mean(J_score);
    ss =mean(J_score)
    
    if max( stats.corloc(1:2)) > cmax
        KmeanID = option.uIDX;
        disp('saving');
        save(option.resultsfile,'corloc_score','Jaccard','stats','KmeanID');
    end
end

%end

