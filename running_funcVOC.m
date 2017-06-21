function [ u_score,n_window,Allbox ] = running_funcVOC( option,imn,net)
RUNNING_FUNC Summary of this function goes here
  Detailed explanation goes here
option.imn =imn;
VOCimageoption;
option.cls;

[~,selected]  = max((option.maxres(:,1)' * option.uIDX)./sum(option.uIDX));
option.uIDX(:,end) = option.uIDX(:,selected);
selected;

meta = im2geodesicaff2(option);
cnnfile =fullfile(option.CNNrespath,option.imgname);
[meta,option] = genbackmapping(option,cnnfile,meta,net);%toc;
meta.spen = meta.spen ./ repmat(max(meta.spen),[size(meta.spen,1),1]);
 meta.geodist = meta.geodist./ repmat(max(meta.spen_proped),[size(meta.spen_proped,1),1]);

fprintf('%s %d\\%d ',option.cls,imn,size(option.recs_class,2));

meta = geopropagate(option,meta);
meta.spen_proped = meta.spen_proped ./ repmat(max(meta.spen_proped),[size(meta.spen_proped,1),1]);
meta.spen_proped = meta.spen ./ repmat(max(meta.spen),[size(meta.spen,1),1]);
u_score = zeros(1,option.aK+1);
n_window = zeros(1,option.aK+1);

Allbox =[];
for detectorK=1:1
    allbox =[];
    A =meta.spen_proped(:,detectorK);
    
   if detectorK>1 option.show =0;
    end

    
    if option.show
        figure(detectorK);subplot(4,1,3);
        [~,r] = g_visdistance(option.im,meta.spind,A);
        imagesc(r,[0,1]);axis image;
        axis off;
    end;
    
    [energy,id] = sort(A,'descend');
    
    nticks = 100;
    
    otick = (log(energy(1)) - log(max(1.e-40,energy(end)))) / (nticks-1);
    i = [0,(1:(nticks-1)) * otick];
    tickvalues = energy(1) -i;
    if energy(1) ==0
        continue;
    end
     tickvalues= exp(log(energy(1)):-otick:log(max(1.e-40,energy(end))));
    tickvalues=tickvalues(1:2:nticks);
       tickvalues=tickvalues([1:5,6:2:10,11:10:50]);
    tickvalues = [0.3,0.6,0.9];
    tickvalues = option.threshold;
    [~,tickindex] = min(abs(repmat(energy,[1,length(tickvalues)]) - repmat(tickvalues,[meta.numsp,1])));
    considerate_th = sort(unique(energy(tickindex)),'descend');
    
    ar(1) = 0;
    S =[];
    for i=1:length(considerate_th)
        S{i} = A>=considerate_th(i);
    end
    
    
    if option.show
         subplot(4,1,1); imshow(option.im);axis image;
        subplot(4,1,2);[~,r] = g_visdistance(option.im,meta.spind,meta.spen(:,detectorK));
        imagesc(r);axis image;
        axis off;
    end
    for i=1:length(tickvalues)
        boxes = [];
        C=S{min(i*2,length(S))};
        
        flag= true;
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
        
        bmask = zeros(option.imsize);
        bmask(allind) = 1;
        
        if isempty(allind) continue
        end;
       boxes(1,:) = ind2bb(option.imsize,allind);
         CC = bwconncomp(bmask);
         boxes = zeros(1,4);
         if CC.NumObjects >1
             co = 1;
%             boxes = zeros(1+CC.NumObjects,4);
%             boxes(1,:) = ind2bb(option.imsize,allind);
             for obj=1:CC.NumObjects
                 if numel(CC.PixelIdxList{obj}) < 1000 && CC.NumObjects>co
                     CC.PixelIdxList{obj} =[];
                     co = co+1;
                 end;
                     
                boxes(obj+1,:) = ind2bb(option.imsize,CC.PixelIdxList{obj});
             end;
             
             boxes(1,:) = ind2bb(option.imsize,vertcat(CC.PixelIdxList{:}));
         else
             boxes(1,:) = ind2bb(option.imsize,allind);
         end
        
        allbox = [allbox;boxes];
        
        if option.show
            subplot(4,1,i+3);
            
            [visim,~] = g_visdistance(option.im,meta.spind,C);
            imagesc(visim,[0,1]);axis image;
            for reci = 1:size(boxes,1)
                box = boxes(reci,:);
                rectangle( 'Position', [box(1),box(2),box(3)-box(1)+1,box(4)-box(2)+1], 'LineWidth',2, 'EdgeColor',[1,1,1] );
            end
            axis off;
           showgt;
        end
    end
    allgtboxes = [];
    for i=1:length(option.recs_class(option.imn).objects)
        Visualize the mask
        
        if strcmp(option.recs_class(option.imn).objects(i).class, option.cls)
            
            gtboxes = option.recs_class(option.imn).objects(i).bbox;
            allgtboxes  = [allgtboxes ;gtboxes];
        end;
    end
    if isempty(allbox)
        continue;
    end
    
    if option.resized >0
        allbox(:,1) = allbox(:,1) * option.oimsize(1) / option.imsize(1);
        allbox(:,3) = allbox(:,3) * option.oimsize(1) / option.imsize(1);
        allbox(:,2) = allbox(:,2) * option.oimsize(2) / option.imsize(2);
        allbox(:,4) = allbox(:,4) * option.oimsize(2) / option.imsize(2);
    end
    allbox = rmredundantwd(allbox);

ovmax =0;
    for j=1:size(allgtboxes,1)
        for ll = 1:size(allbox,1)
            bb = allbox(ll,:);
            bb= finalbox;
            bbgt=allgtboxes(j,:);
            if size(allgtboxes,1) ==1 bbgt=allgtboxes; end
            bi=[max(bb(1),bbgt(1)) ; max(bb(2),bbgt(2)) ; min(bb(3),bbgt(3)) ; min(bb(4),bbgt(4))];
            iw=bi(3)-bi(1)+1;
            ih=bi(4)-bi(2)+1;
            if iw>0 && ih>0
                compute overlap as area of intersection / area of union
                ua=(bb(3)-bb(1)+1)*(bb(4)-bb(2)+1)+...
                    (bbgt(3)-bbgt(1)+1)*(bbgt(4)-bbgt(2)+1)-...
                    iw*ih;
                ov=iw*ih/ua;
                if ov>ovmax
                    ovmax=ov;
                    jmax=j;
                end
            end
        end
    end
    u_score(detectorK) =  ovmax;
    n_window(detectorK) =  size(allbox,1);
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
disp(sum(u_score>=0.5)/imn);

end

