function[] = FT_2007_alex(cls,K,kd,iter)
%poolobj = gcp('nocreate');
%delete(poolobj);i
switch kd
case 1
    distance = 'sqeuclidean';
case 2
    distance ='cityblock';
end;

addpath('auxiliaries');
%addpath('pgp_clustering');
%addpath(genpath('objectness-release-v2.2'));
warning('off');

option.dataset = 'trainval';
option.clsi =cls;

option.sm =0;
option.data = 'VOC2007';
option.devkit ='VOCdevkit2007';
kkkkk=pwd;
cd(fullfile('..','dataset',option.devkit));
addpath(fullfile('VOCcode'));VOCinit;
cd(kkkkk);
option.cls = VOCopts.classes{option.clsi};
option.imlistpath = fullfile(option.data,option.dataset,'imlist',option.cls); load(fullfile(option.imlistpath,'imlist.mat'));
if option.sm
    k= [recs_class(:).segmented];
    k = find(k==true);
    option.imn = k(option.imn);
end
option.recs_class = recs_class;
option.VOCopts = VOCopts;
option.nim = length(recs_class);
option.bdE =1;      % Boundary weight
option.layer = 14;
option.show =0;
option.saveflag = true;
option.CNNrespath =fullfile(option.data,'trainval','CNNres_vggs');
option.netmeta = 'netmeta_vggs.mat';
option.sppath = fullfile(option.data,'sp','%s_%d.mat');
option.prop_w =0.5; %0.2 is good for Be 1 % was testing with 1
option.threshold = 0.3;
option.smooththreshold = 0.01;
option.nfilter = 512;
option.K=K;
 option.aK = K+1;
option.distance = distance;

option.basepath =  fullfile(option.data,option.dataset,'vggs');
option.respath =  fullfile(option.basepath,'corloc');
mkdir(option.respath);
option.corlocrespath = fullfile(option.respath,'%s_K%d_d%s_th_%0.3f_W%0.1f.mat');
option.resultsfile = sprintf(option.corlocrespath,option.cls,option.K,option.distance,option.threshold,option.prop_w);

clpath = fullfile(option.basepath,'cluster',option.cls);mkdir(clpath);
option.Kmeansfile = sprintf('%s/%d_%s.mat',clpath,K,option.distance);

%if ~exist(option.resultsfile,'file')
cmax =0;
for it=1:iter
    if exist(option.resultsfile,'file')
        load(option.resultsfile);
        cmax = max(stats.corloc(1:2))
        
   end;
    clear meta windows u_score stats cu_score cn_window windows;
    Rebuttal_gen_max(option);
    load(option.Kmeansfile);
    option.maxres = maxres;
  %  IDX = pgpClustering(maxres, 'orig', 0.6);
   % option.K = numel(unique(IDX))+1;
    option.aK = option.K+1;
    option.uIDX(:,1) = zeros(1,option.nfilter);
%     tr = find([IDX == 1]);
%     option.uIDX= zeros(512,1);
%     option.uIDX([451]) = 1;

    
%     for i=1:length(tr)
%         option.uIDX(tr(i),i) =1;
%     end
%     
    for i=1:option.aK
        option.uIDX(:,i+1) = [IDX == i];
        if sum(option.uIDX(:,1)) < 30
            option.uIDX(:,1)  = option.uIDX(:,1) + [IDX == i];
        end        
    end
    parfor imn=1:option.nim
       % close all
        %running_funcVOC( option,imn);
        [ score,nwinds,wds ] = running_funcVOC( option,imn);
%        score
        cu_score{imn} =  score;
        cn_window{imn} =  nwinds;
        windows{imn} = wds;
    %    pause;
    end;
    u_score=vertcat(cu_score{:});
    n_window = vertcat(cn_window{:});
    stats.corloc = sum(u_score>=0.5) / option.nim;
    stats.nwindows  = mean(n_window);
    datestr(now)
    stats.corloc
    if max(stats.corloc(1:2)>cmax)
        KmeanID = option.uIDX;
        disp('saving')
        save(option.resultsfile,'u_score','windows','n_window','stats','KmeanID');
    end
end
    
    %end

