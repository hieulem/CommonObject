addpath(fullfile('..','dataset','VOCdevkit'));
addpath(fullfile('..','dataset','VOCdevkit','VOCcode'));
VOCinit;
gtids=textread(sprintf(VOCopts.imgsetpath,VOCopts.trainset),'%s');
 tic
 for i=1:length(gtids)
     recs(i)=PASreadrecord(sprintf(VOCopts.annopath,gtids{i}));
 end
 
save('VOC_train_info.mat','recs','gtids');
%load('VOC_train_info.mat');


ind = zeros(length(VOCopts.classes),length(recs));
ind2 = zeros(length(VOCopts.classes),length(recs));


for i=1:length(gtids)
    % display progress
    if toc>1
        fprintf('%d/%d\n',i,length(gtids));
        drawnow;
        tic;
    end
    
    
    % find objects of class and extract difficult flags for these objects
    for clsi =1:20
        cls = VOCopts.classes{clsi};
        clsinds=strmatch(cls,{recs(i).objects(:).class},'exact');
        diff=[recs(i).objects(clsinds).difficult];
        
        % assign ground truth class to image
        if isempty(clsinds)
            gt=-1;          % no objects of class
        elseif any(~diff)
            gt=1;           % at least one non-difficult object of class
        else
            gt=0;           % only difficult objects
        end
        
        if gt==1
            ind(clsi,i)=1;
        end
        
        if gt>=0
            ind2(clsi,i) =1;
        end
    end
end


for clsi =1:20
    cls = VOCopts.classes{clsi};
    path = fullfile('VOC2012','train','imlist',cls);
       mkdir(path);
    cp=sprintf(VOCopts.annocachepath,VOCopts.trainset);
    recs_class = recs(ind2(clsi,:)>0);
    recs_class_nd = recs(ind(clsi,:)>0);
    save(fullfile(path,'imlist.mat'),'recs_class','recs_class_nd');
end;
