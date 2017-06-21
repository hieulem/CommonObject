%function[] = geodesic_propaganda(cls,i)
clear;
addpath('auxiliaries');
%addpath(genpath('objectness-release-v2.2'));
warning('off');
%profile on;
option.data = 'VOC2012';
for cls=1:20
    
    
    option.dataset = 'trainval';
    option.clsi =cls;
    
    option.sm =0;
    option.corlocrespath = fullfile(option.data,option.dataset,'corloc','%s_%d_%d.mat');
    VOCclassoption;
    
    option.bdE =1;      % Boundary weight
    option.layer = 36;
    option.show =0;
    option.saveflag = true;
    option.CNNrespath =fullfile(option.data,'trainval','CNNres');
    option.netmeta = 'netmeta.mat';
    option.sppath = fullfile(option.data,'sp','%s_%d.mat');
    option.vispath = fullfile(option.data,'vis','%s');
    option.visfile = fullfile(option.data,'vis','%s','%s_%s.png');
    option.prop_w =1; %0.2 is good for Be 1
    option.K=4;
    if ~exist(sprintf(option.corlocrespath,option.cls,option.K,1),'file')
        clear meta windows u_score stats cu_score cn_window windows;
        gen_max(option);
       % u_score = zeros(option.nim,option.K+1);
       % n_window = zeros(option.nim,option.K+1);
       parfor imn=1:option.nim
            [ score,nwinds,wds ] = running_func( option,imn);
            cu_score{imn} =  score;
            cn_window{imn} =  nwinds;
            windows{imn} = wds;
        end;
        u_score=vertcat(cu_score{:});
        n_window = vertcat(cn_window{:});
        stats.corloc = sum(u_score>0.5) / option.nim;
        stats.nwindows  = mean(n_window) 
        save(sprintf(option.corlocrespath,option.cls,option.K,1),'u_score','windows','n_window','stats');
        datasetstats.corloc(cls,:) = stats.corloc;
        datasetstats.nwindows(cls,:) = stats.nwindows;
    else
        load(sprintf(option.corlocrespath,option.cls,option.K,1));
        datasetstats.corloc(cls,:) = stats.corloc;
        datasetstats.nwindows(cls,:) = stats.nwindows;
    end
end
  datasetstats.corloc(end+1,:) =   mean(datasetstats.corloc);
datasetstats.corloc(end,:) 
