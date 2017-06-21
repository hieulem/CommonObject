clear;
 addpath('./matconvnet-1.0-beta21');
 run matconvnet-1.0-beta21/matlab/vl_setupnn ;
net = load('../MatconvCNNmodels/imagenet-caffe-alex.mat') ;
%imagenet-caffe-ref
 net = vl_simplenn_tidy(net) ;


option.clsi =8;
option.dataset = 'trainval';

option.sm =0;

option.data = 'VOC2007';
option.devkit ='VOCdevkit2007';
kkkkk=pwd;
cd(fullfile('..','dataset',option.devkit));
addpath(fullfile('VOCcode'));VOCinit;

option.VOCopts = VOCopts;
cd(kkkkk);
option.cls = VOCopts.classes{option.clsi};
option.CNNrespath =fullfile(option.data,'trainval','CNNres_full_alexnet');

    disp('kmean-ing');
    load(fullfile(option.data,option.dataset,'imlist',option.cls,'imlist.mat'));
    layer = 17;
    option.nfilter = 4096;

    %Uscore =  cell(nlayer,1);
    

option.recs_class = recs_class;
        maxres = zeros(option.nfilter,length(recs_class));
    numi = length(recs_class);
    

    %Fdist = zeros(512,512,length(recs_class));
    tic;
    for i=1:length(recs_class)
        
        a = toc;
        if a>10
            fprintf('%d / %d \n',i,numi);
            tic;
        end
        imgname = recs_class(i).filename(1:end-4);
        res = load(fullfile(option.CNNrespath,imgname));
        res.X(layer).x(res.X(layer).x<0) = 0;
        
        
        nfilter = size(res.X(layer).x,3);

      %  for filt=1:nfilter
            maxres(:,i) = squeeze(max(max(res.X(17).x,[],1),[],2));
            %  Uscore(filt) = Uscore(filt) + max(max(res.X(layer).x(:,:,filt))) /  max_activation(i) / numi  ;
        %end;
        %    end;
    end
    K=5;
    b = repmat(max(maxres,[],1),[option.nfilter,1]);
    aa = maxres./b;
    %aa= aa.^2;
    Uscore =  mean(aa,2);
    IDX2 = kmeans(maxres, K,'Distance','sqeuclidean','EmptyAction','drop');
    for i=1:K
        mK(i) = mean(mean(maxres(IDX2==i,:)));
    end
    [~,id] = sort(mK,'descend');
    IDX = IDX2;
     for i=1:K
        IDX(IDX2==id(i)) = i;
     end
     
    find(IDX==1) 
     
    
    
testing_fcAlex
    
    
    
    
     
