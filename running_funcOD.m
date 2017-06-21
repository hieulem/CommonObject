function [ u_score,jaccard_score,Allbox  ] = running_funcOD( option,imn,net )
%RUNNING_FUNC Summary of this function goes here
%   Detailed explanation goes here

if option.validim(imn) ==0
    u_score = ones(1,option.aK+1);
    jaccard_score = ones(1,option.aK+1);
    Allbox =[];
    return
end

option.im = imread(option.impath{imn});
option.oimsize =size(option.im);
option.resized = 0;
if(size(option.im ,1)<224)
    option.im  = imresize(option.im ,[224,NaN]);
    option.resized =1;
end;
if size(option.im ,2)<224
    option.im  =imresize(option.im ,[NaN,224]);
    option.resized =2;
end;
option.nfilter = 512;
option.imsize = size(option.im);
option.imsize(3) = [];
option.imgname= option.imname{imn};
meta = im2geodesicaff2(option);
if option.bdE ~=1
    meta.E = meta.E.^option.bdE +meta.E;
end;
option.CNNrespath = option.imcnnres{imn};

[meta,option] = genbackmapping(option,option.imcnnres{imn},meta,net);%toc;
meta.spen = meta.spen ./ repmat(sum(meta.spen),[size(meta.spen,1),1]);
meta = geopropagate(option,meta);
meta.spen_proped = meta.spen_proped ./ repmat(max(meta.spen_proped),[size(meta.spen_proped,1),1]);
u_score = zeros(1,option.aK+1);
jaccard_score = zeros(1,option.aK+1);

allgtboxes = [];

gtboxes = option.objectbb{imn};
allgtboxes  = [allgtboxes ;gtboxes];
for detectorK=1:2
    allbox =[];
    A =meta.spen_proped(:,detectorK);
    
    if option.show ==1
        figure(detectorK);subplot(1,4,3);
        [~,r] = g_visdistance(option.im,meta.spind,A);
        imagesc(r);axis image;
    end;
    
    if max(A) ==0 continue;
    end
    [energy,~] = sort(A,'descend');
    if energy(1) ==0
        continue;
    end
    
    if option.show
        subplot(1,4,1); imshow(option.im);axis image;
        subplot(1,4,2);[~,r] = g_visdistance(option.im,meta.spind,meta.spen(:,detectorK));
        imagesc(r);axis image;
    end
    
    
    detected_box = [];
    
    flag= true;
    C= A>=option.threshold;
    while flag
        lnode = find(C==1);
        partialgeodist = min(meta.geodist(lnode,:),[],1);
        lnode2 = find(partialgeodist<option.smooththreshold);
        flag = false;
        if length(lnode2) > length(lnode)
            flag =true;
        end;
        C(lnode2) =1;
    end
    
    
    allind =cat(1, meta.spind{(C==1)});
    
    detected_segment = zeros(option.imsize);
    detected_segment(allind) = 1;
    detected_segment = imresize(detected_segment,option.oimsize(1:2));
    imwrite(detected_segment,['./test/',option.imname{imn}]);
    if isempty(allind) continue
    end;
    detected_box = ind2bb(option.imsize,allind);
    
    
    if option.show
        subplot(1,4,3);
        
        [visim,~] = g_visdistance(option.im,meta.spind,C);
        imagesc(visim);axis image;
        
        box = detected_box;
        rectangle( 'Position', [box(1),box(2),box(3)-box(1)+1,box(4)-box(2)+1], 'LineWidth',2, 'EdgeColor',[1,0,0] );
        
        boxex = gtboxes;
        if ~isempty(boxex)
            for b=1:size(boxex,1)
                box = boxex(b,:);
                rectangle( 'Position', [box(1),box(2),box(3)-box(1)+1,box(4)-box(2)+1], 'LineWidth',2, 'EdgeColor',[0,1,0] );
            end
        end
    end
    
    
   
    
    ovmax =0;
    for j=1:size(allgtboxes,1)
    
            bb = detected_box;
            % bb= finalbox;
            bbgt=allgtboxes(j,:);
            if size(allgtboxes,1) ==1 bbgt=allgtboxes; end
            bi=[max(bb(1),bbgt(1)) ; max(bb(2),bbgt(2)) ; min(bb(3),bbgt(3)) ; min(bb(4),bbgt(4))];
            iw=bi(3)-bi(1)+1;
            ih=bi(4)-bi(2)+1;
            if iw>0 && ih>0
                % compute overlap as area of intersection / area of union
                ua=(bb(3)-bb(1)+1)*(bb(4)-bb(2)+1)+...
                    (bbgt(3)-bbgt(1)+1)*(bbgt(4)-bbgt(2)+1)-...
                    iw*ih;
                ov=iw*ih/ua;
                if ov>ovmax
                    ovmax=ov;
              
                end
            end

    end
    
    GTsegmentation = imread(fullfile(option.datapath,option.class,'GroundTruth',[option.imgname(1:end-4),'.png']));
    object_ind = unique(GTsegmentation);
    c=0;
    jaccard = zeros(1,size(object_ind,1)-1);
    for j=1:size(object_ind,1)
        if object_ind(j) ~=0  
            c=c+1;
             jaccard(c) =  jaccard_coefficient(detected_segment>0,GTsegmentation==object_ind(j) );
        end
    end
    %jaccard
    jaccard_score(detectorK) =max(jaccard);
     
    for j=1:size(allgtboxes,1)
        
    end
    
    u_score(detectorK) =  ovmax;
    Allbox{detectorK} = allbox;
end


if isempty(Allbox)
    return;
end
rallbox = vertcat(Allbox{:});
rallbox= rmredundantwd(rallbox);

Allbox{detectorK+1} = rallbox;

n_window(detectorK+1) = size(rallbox,1);
u_score(end) = max(u_score);
jaccard_score(end)  = max(jaccard_score);
%disp(sum(u_score>=0.5)/imn);



end

