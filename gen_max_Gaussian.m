function [maxres] = gen_max_Gaussian(option)
%clsi =1;

addpath(fullfile('..','dataset',option.devkit,'VOCcode'));

VOCinit;
%clsi = option.clsi;

cls = option.cls;%VOCopts.classes{clsi};
K=option.K;


tic
%if ~exist(option.Kmeansfile,'file')
if true
    disp('kmean-ing');
    load(fullfile(option.data,option.dataset,'imlist',cls,'imlist.mat'));
    layer = option.layer;

    %Uscore =  cell(nlayer,1);
    
    %dummy code to get meta
    imgname = recs_class(1).filename(1:end-4);
    if option.data=='VOC2007'
        imgname = [imgname,'.mat'];
    end
    cpath = option.CNNrespath;
    res = load(fullfile(cpath,imgname));
    
    %for i =1:nlayer
    %Uscore = zeros(size(res.X(layer).x,3),1);
    %end
    %%end of dummy code
    
  %  tic
    %max_activation = zeros(1,length(recs_class));
    % if true
    %     k= [recs_class(:).segmented];
    %     k = k==true;
    %     recs_class = recs_class(k);
    % end
    maxres = zeros(option.nfilter,length(recs_class));
    meanres = zeros(option.nfilter,length(recs_class));
    numi = length(recs_class);
    
    fprintf('%s : %d images \n',cls,numi);
    %Fdist = zeros(512,512,length(recs_class));
    for i=1:length(recs_class)
        
        a = toc;
        if a>10
            fprintf('%d / %d \n',i,numi);
            tic;
        end
        imgname = recs_class(i).filename(1:end-4);
        res = load(fullfile(cpath,imgname));
        res.X(layer).x(res.X(layer).x<0) = 0;
        
        
        nfilter = size(res.X(layer).x,3);
     %   res.X(layer).x  = imfilter(res.X(layer).x,fspecial('laplacian',0.5));
        res.X(layer).x  = imfilter(res.X(layer).x,fspecial('gaussian',5,3));
        
        for filt=1:nfilter
            maxres(filt,i) = max(max(res.X(layer).x(:,:,filt))) ;
            meanres(filt,i) = mean(mean(res.X(layer).x(:,:,filt)));
            %  Uscore(filt) = Uscore(filt) + max(max(res.X(layer).x(:,:,filt))) /  max_activation(i) / numi  ;
        end;
        %    end;
    end
    
    b = repmat(mean(meanres,2),[1,option.nim]);
  %  aa = maxres -b;
    %aa= aa.^2;

    IDX2 = kmeans([maxres], K,'Distance',option.distance,'Replicates' ,5,'Start' ,'uniform');
    for i=1:K
        mK(i) = mean(mean(maxres(IDX2==i,:)));
    end
    [~,id] = sort(mK,'descend');
    IDX = IDX2;
     for i=1:K
        IDX(IDX2==id(i)) = i;
     end
%    IDX(133) = 0;
  %  IDX(39) = 0;
    find(IDX==1)
    save(option.Kmeansfile,'IDX','maxres');

end
%save(fullfile(path,'maxres'),'maxres');
