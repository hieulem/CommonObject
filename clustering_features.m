function [maxres] = clustering_features(option)
addpath(fullfile('..','dataset',option.devkit,'VOCcode'));
VOCinit;
cls = option.cls;%VOCopts.classes{clsi};
K=option.K;
%if ~exist(option.Kmeansfile,'file')
    disp('kmean-ing');
    load(fullfile(option.data,option.dataset,'imlist',option.cls,'imlist.mat'));
    layer = option.layer;
    cpath = option.CNNrespath;
    
    maxres = zeros(option.nfilter,length(recs_class));
    %meanres = zeros(option.nfilter,length(recs_class));
    numi = length(recs_class);
    fprintf('%s : %d images \n',cls,numi);
    tic;
    for i=1:length(recs_class)
        
        a = toc;
        if a>10
            fprintf('%d / %d \n',i,numi);
            tic;
        end
        imgname = recs_class(i).filename(1:end-4);
        res = load(fullfile(cpath,imgname));
        
        ftmap = res.X(layer).x;
        sz = size(ftmap);
        ftmap(ftmap<0) = 0;
        border= floor(sz(1:2)*0.2);
        ftmap(1:border(1),:,:) =0;
        ftmap(end-border(1):end,:,:) =0;
        ftmap(:,1:border(2),:) =0;
        ftmap(:,end-border(2):end,:) =0;
        
        
        maxres(:,i) = [squeeze(max(max(ftmap,[],1),[],2))];
        
    end
    
    % maxres(isnan(maxres)) = 0
    %maxres = maxres./repmat(max(maxres,[],1),[size(maxres,1),1]);
    %maxres = maxres./repmat(max(maxres,[],2),[1,size(maxres,2)]);
    
    
    IDX2 = kmeans([maxres], K,'Distance',option.distance,'Replicates' ,1,'Start','cluster');
    for i=1:K
        mK(i) = mean(mean(maxres(IDX2==i,:)));
    end
    [~,id] = sort(mK,'descend');
    IDX = IDX2;
    for i=1:K
        IDX(IDX2==id(i)) = i;
    end
    
    find(IDX==1);
    save(option.Kmeansfile,'IDX','maxres');
    
%end
%save(fullfile(path,'maxres'),'maxres');
