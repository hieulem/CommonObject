function [maxres] = gen_max(option)
%clsi =1;

addpath(fullfile('..','dataset',option.devkit,'VOCcode'));

VOCinit;
%clsi = option.clsi;

cls = option.cls;%VOCopts.classes{clsi};
K=option.K;



if ~exist(option.Kmeansfile,'file')
    load(fullfile(option.data,option.dataset,'imlist',cls,'imlist.mat'));
    layer = 36;

    %Uscore =  cell(nlayer,1);
    
    %dummy code to get meta
    imgname = recs_class(1).filename(1:end-4);
    cpath = fullfile(option.data,option.dataset,'CNNres');
    res = load(fullfile(cpath,imgname));
    
    %for i =1:nlayer
    %Uscore = zeros(size(res.X(layer).x,3),1);
    %end
    %%end of dummy code
    
    tic
    %max_activation = zeros(1,length(recs_class));
    % if true
    %     k= [recs_class(:).segmented];
    %     k = k==true;
    %     recs_class = recs_class(k);
    % end
    maxres = zeros(512,length(recs_class));
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

        for filt=1:nfilter
            maxres(filt,i) = max(max(res.X(layer).x(:,:,filt)));
            %  Uscore(filt) = Uscore(filt) + max(max(res.X(layer).x(:,:,filt))) /  max_activation(i) / numi  ;
        end;
        %    end;
    end
    
    b = repmat(max(maxres,[],1),[512,1]);
    aa = maxres./b;
    %aa= aa.^2;
    Uscore =  mean(aa,2);
    IDX2 = kmeans(maxres, K,'Replicates',5,'Distance',option.distance);
    for i=1:K
        mK(i) = mean(mean(maxres(IDX2==i,:)));
    end
    [~,id] = sort(mK,'descend');
    IDX = IDX2;
     for i=1:K
        IDX(IDX2==id(i)) = i;
     end
    
    save(option.Kmeansfile,'Uscore','IDX','maxres');

end
%save(fullfile(path,'maxres'),'maxres');
