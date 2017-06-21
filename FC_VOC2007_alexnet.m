function[] = FC_VOC2007_alexnet(cls,K,idistance)


ldistance ={'cityblock','sqeuclidean'};
distance =ldistance{idistance};
poolobj = gcp('nocreate');
delete(poolobj);
addpath('auxiliaries');
addpath('pgp_clustering');
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
option.layer = 17;
option.fc  = 1; % 1 if using fc layer.
option.nfilter = 4096;
option.bordercut = 0.1;
option.show =0;
option.show =0;
option.saveflag = true;
option.CNNrespath =fullfile(option.data,'trainval','CNNres_full_alexnet');
option.netmeta = '../MatconvCNNmodels/imagenet-caffe-alex.mat';
option.sppath = fullfile(option.data,'sp','%s_%d.mat');
option.prop_w =0.5; %0.2 is good for Be 1 % was testing with 1
option.threshold = 0.3;
option.smooththreshold = 0;
option.K=K;
option.aK = K+1;
option.distance = distance;
option.basepath =  fullfile(option.data,option.dataset,'FC_alexnet');
option.respath =  fullfile(option.basepath,'corloc');
mkdir(option.respath);
option.corlocrespath = fullfile(option.respath,'%s_K%d_d%s_th_%0.3f_sth_%0.3f_W%0.1f.mat');
option.resultsfile = sprintf(option.corlocrespath,option.cls,option.K,option.distance,option.threshold,option.smooththreshold,option.prop_w);

clpath = fullfile(option.basepath,'cluster',option.cls);mkdir(clpath);
option.Kmeansfile = sprintf('%s/%d_%d_%s.mat',clpath,option.layer,K,option.distance);

if option.fc==1
    net = load(option.netmeta);
    ww = net.layers{16}.weights{1};
    %temp = min(reshape(ww,[],size(ww,4)),[],1);
    %temp = reshape(temp,1,1,1,4096);
    %ww = ww - repmat(temp,size(ww,1),size(ww,2),size(ww,3));
    
    option.simplifed_w_from_conv_2_fc = squeeze(sum(squeeze(sum(ww,1)),1));
    
    
    %option.simplifed_w_from_conv_2_fc(option.simplifed_w_from_conv_2_fc<0.3) = 0;
    temp1 = max(option.simplifed_w_from_conv_2_fc);
    temp1 = repmat(temp1,256,1);
     temp2 = min(option.simplifed_w_from_conv_2_fc);
    temp2 = repmat(temp2,256,1);
    option.simplifed_w_from_conv_2_fc = (option.simplifed_w_from_conv_2_fc- temp2)./(temp1-temp2)*10 -5;
    
end

%if ~exist(option.resultsfile,'file')
if true
    clear meta windows u_score stats cu_score cn_window windows;
    clustering_features(option);
    load(option.Kmeansfile);
    option.maxres = maxres;
    % IDX = pgpClustering(maxres, 'orig', 0.6);
    option.K = numel(unique(IDX));
    option.aK = option.K ;
    option.uIDX(:,1) = zeros(1,option.nfilter);
    for i=1:option.K
        temp = single(IDX==i);
        temp(temp>0) = mean(maxres(IDX==i,:),2);
        temp= temp./max(temp);
        option.uIDX(:,i) = temp;
        option.uIDX(:,i) = [IDX==i];
        %    if sum(option.uIDX(:,1)) < 30
        %      option.uIDX(:,1)  = option.uIDX(:,1) + [IDX == i];
        %  end
        
    end
    net = load(option.netmeta);
    if option.show ==1
        
        for imn=1:option.nim
            [ score,nwinds,wds ] = running_funcVOC( option,imn,net);
            score
            cu_score{imn} =  score;
            cn_window{imn} =  nwinds;
            windows{imn} = wds;
            pause;
        end;
    end;
    
    if option.show == 0
        parfor imn=1:option.nim
            [ score,nwinds,wds ] = running_funcVOC( option,imn,net);
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
    stats.corloc
    save(option.resultsfile,'u_score','windows','n_window','stats','option');
end

