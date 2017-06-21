function[ss] = FT_6ho_vgg19(cls,K,kd,iter,th1,th2,just_checking)
%poolobj = gcp('nocreate');
%delete(poolobj);i

addpath('auxiliaries');
warning('off');
cl = { 'n02360282','n02391994','n02442336','n02508021','n04050066','n04576002'};
setname =[cl{cls},'.mat'];
CNNrespath = 'vgg19';
load(['../dataset/SubsetImagenet/',setname]);

%option.class = setname{cls};
if exist('th1','var')
    option.prop_w = th1;
else
    option.prop_w = 0.5;
end;


if exist('th2','var')
    disp('dcm');
    option.threshold= th2;
else
    option.threshold = 0.25;
end;


switch kd
    case 1
        distance = 'sqeuclidean'
    case 2
        distance ='cityblock'
end;
option.bdE =1;      % Boundary weight

option.show =1;

option.fc=0;
option.bordercut =0.0;

option.netmeta = '../MatconvCNNmodels/imagenet-vgg-verydeep-19.mat';
option.smooththreshold = 0.05;
option.K=K;
option.aK = K+1;
option.distance = distance;

option.nfilter = 512;
%option.filter = 36;
option.layer = 36;

option.basepath =  fullfile('ImagenetSS',option.class,'vgg19');
mkdir(option.spbasepath);
option.respath =  fullfile(option.basepath,'corloc');
mkdir(option.respath);
option.corlocrespath = fullfile(option.respath,'%s_K%d_d%s_th_%0.3f_sth%0.3f_W%0.1f.mat');
option.resultsfile = sprintf(option.corlocrespath,option.class ,option.K,option.distance,option.threshold,option.smooththreshold ,option.prop_w);

if exist('just_checking','var') && exist(option.resultsfile,'file')
    load(option.resultsfile);
    ss = stats.corloc
    return;
end

clpath = fullfile(option.basepath,'cluster');mkdir(clpath);
option.Kmeansfile = sprintf('%s/%d_%s.mat',clpath,K,option.distance);
addpath(fullfile('GoPCode'));
addpath(genpath(fullfile('GoPCode')));
init_gop;
gop_mex( 'setDetector', 'MultiScaleStructuredForest("GoPCode/lib/gop_1.3/data/sf.dat")' );


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
    
    option.aK = option.K;
    option.uIDX(:,1) = zeros(1,option.nfilter);
    
    for i=1:option.aK
        option.uIDX(:,i+1) = [IDX == i];
        if sum(option.uIDX(:,1)) < 30
            option.uIDX(:,1)  = option.uIDX(:,1) + [IDX == i];
        end
    end
    net=load(option.netmeta);
    if option.show ==1
        for imn=1:option.nim
            
            [score,nwinds,wds] = running_func_INSS( option,imn,net);
            score;
            cu_score{imn} =  score;
            cn_window{imn} =  nwinds;
            windows{imn} = wds;
            %pause
            
        end;
    else
       parfor imn=1:option.nim
            
            [score,nwinds,wds] = running_func_INSS( option,imn,net);
            score;
            cu_score{imn} =  score;
            cn_window{imn} =  nwinds;
            windows{imn} = wds;
            
            
        end;
    end
    u_score=vertcat(cu_score{:});
    n_window = vertcat(cn_window{:});
    stats.corloc = sum(u_score>=0.5) / option.nim;
    stats.nwindows  = mean(n_window);
    ss= stats.corloc;
    disp(ss);
    if max( stats.corloc(1:2)) > cmax
        KmeanID = option.uIDX;
        disp('saving');
        save(option.resultsfile,'u_score','windows','n_window','stats','KmeanID');
    end
end

%end

