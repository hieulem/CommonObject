function [ u_score,n_window,Allbox] = running_funcVOC_test_mu( option,imn,net)
%RUNNING_FUNC Summary of this function goes here
%   Detailed explanation goes here
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
%  meta.geodist = meta.geodist./ repmat(max(meta.spen_proped),[size(meta.spen_proped,1),1]);

%fprintf('%s %d\\%d ',option.cls,imn,size(option.recs_class,2));


%meta.spen_proped = meta.spen ./ repmat(max(meta.spen),[size(meta.spen,1),1]);
u_score = zeros(1,option.aK+1);
n_window = zeros(1,option.aK+1);

Allbox =[];
%figure(10);subplot(1,6,3);
%[~,r] = g_visdistance(option.im,meta.spind,meta.spen_proped(:,1));
%    imagesc(r,[0,1]);axis image;axis off;
if option.show ==2
    figure(10);
    clf;
    [main_ha main_pos] = tight_subplot(1,6,[.02 .0],[.02 .0],[.02 .0]);
    axes(main_ha(1)); imshow(option.im);axis image;axis off;
    axes(main_ha(2)); [~,r] = g_visdistance(option.im,meta.spind,meta.spen(:,1)); imagesc(r,[0,1]);axis image;axis off;
end;
for detectorK=1:2
    ww =[0.2,0.5];
    option.prop_w = ww(detectorK);
    
    meta = geopropagate(option,meta);
    meta.spen_proped = meta.spen_proped ./ repmat(max(meta.spen_proped),[size(meta.spen_proped,1),1]);
    
    boxes =[];
    
    sp_energy =meta.spen_proped(:,1);
    AA(detectorK,:) = sp_energy;
    if option.show
        
    end;
    
    if max(sp_energy) ==0
        continue;
    end
    
    
    
    boxes = [];
    
    
    flag= true;
    sp_chosen = sp_energy>option.threshold;
    while flag
        lnode = find(sp_chosen==1);
        partialgeodist = min(meta.geodist(lnode,:),[],1);
        lnode2 = find(partialgeodist<option.smooththreshold);
        flag = false;
        if length(lnode2) > length(lnode)
            flag =true;
        end;
        sp_chosen(lnode2) =1;
    end
    
    
    allind =cat(1, meta.spind{(sp_chosen==1)});
    
    bmask = zeros(option.imsize);
    bmask(allind) = 1;
    
    if isempty(allind)
        continue;
    end;
    %   boxes(1,:) = ind2bb(option.imsize,allind);
    CC = bwconncomp(bmask);
    boxes = zeros(1,4);
    if CC.NumObjects >1
        co = 1;
        for obj=1:CC.NumObjects
            if numel(CC.PixelIdxList{obj}) < 1000 && CC.NumObjects>co
                CC.PixelIdxList{obj} =[];
                co = co+1;
            end;
        end;
        boxes = ind2bb(option.imsize,vertcat(CC.PixelIdxList{:}));
    else
        boxes = ind2bb(option.imsize,allind);
    end
    
    
    allgtboxes = [];
    
    for gti=1:length(option.recs_class(option.imn).objects)
        if strcmp(option.recs_class(option.imn).objects(gti).class, option.cls)
            gtboxes = option.recs_class(option.imn).objects(gti).bbox;
            allgtboxes  = [allgtboxes ;gtboxes];
        end;
    end
    
    if isempty(boxes)
        continue;
    end
    
    if option.resized >0
        boxes(:,1) = boxes(:,1) * option.oimsize(1) / option.imsize(1);
        boxes(:,3) = boxes(:,3) * option.oimsize(1) / option.imsize(1);
        boxes(:,2) = boxes(:,2) * option.oimsize(2) / option.imsize(2);
        boxes(:,4) = boxes(:,4) * option.oimsize(2) / option.imsize(2);
    end
    % boxes = rmredundantwd(boxes);
    ovmax =0;
    for j=1:size(allgtboxes,1)
        bb = boxes;
        
        bbgt=allgtboxes(j,:);
        if size(allgtboxes,1) ==1
            bbgt=allgtboxes;
        end
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
    
    if option.show==2
     
        figure(10);
        
        axes(main_ha(2*detectorK+1));[~,r] = g_visdistance(option.im,meta.spind,sp_energy);imagesc(r,[0,1]);axis image;axis off;
        
        axes(main_ha(2*detectorK+2));
        
        [visim,~] = g_visdistance(option.im,meta.spind,sp_chosen);
        imagesc(visim,[0,1]);axis image;axis off; showgt;
        box = boxes; rectangle( 'Position', [box(1),box(2),box(3)-box(1)+1,box(4)-box(2)+1], 'LineWidth',4, 'EdgeColor',[1,0,1] );
        addtext(10,40,num2str(ovmax,'%0.2f'));
        set(gca,'LooseInset',get(gca,'TightInset'));
        
    end
    if option.show
        %subplot(4,1,i+3);
        figure(2);
        
        [visim,~] = g_visdistance(option.im,meta.spind,sp_chosen);
        imagesc(visim);axis image;h=gca;
        set(gca, 'XTick', [],'YTick',[]);
        
        box = allgtboxes(1,:);
        if ~isempty(box)
            rectangle( 'Position', [box(1),box(2),box(3)-box(1)+1,box(4)-box(2)+1], 'LineWidth',4, 'EdgeColor',[1,1,1] );
        end
        for reci = 1:size(boxes,1)
            box = boxes(reci,:);
            rectangle( 'Position', [box(1),box(2),box(3)-box(1)+1,box(4)-box(2)+1], 'LineWidth',4, 'EdgeColor',[0,1,0] );
            
        end
        %addtext(20,20,num2str(ovmax,'%0.2f'));
     %   mkdir(['./vis/',option.class]);
  %      saveas(gcf,['./vis/',option.class,'/',option.imgname,'.png']);
        
        
        %[visim,~] = g_visdistance(option.im,meta.spind,sp_chosen);
        % imagesc(visim,[0,1]);axis image;axis off; showgt;
        % box = boxes; rectangle( 'Position', [box(1),box(2),box(3)-box(1)+1,box(4)-box(2)+1], 'LineWidth',3, 'EdgeColor',[1,1,1] );
        %addtext(box(1),box(2),num2str(ovmax,'%0.2f'));

    end
    u_score(detectorK) =  ovmax;
    %  n_window(detectorK) =  size(boxes,1);
    Allbox{detectorK} = boxes;
end

if u_score(1)>u_score(2)+0.5
    pause;
end

if isempty(boxes)
    return;
end
rallbox = vertcat(Allbox{:});
rallbox= rmredundantwd(rallbox);


Allbox{detectorK+1} = rallbox;

n_window(detectorK+1) = size(rallbox,1);
u_score(end) = max(u_score);

%disp(sum(u_score>=0.5)/imn);
figure(10);
rgbftmap = ind2rgb(uint8(meta.E.^2*255),hot)*200;
[~,~,energy] = g_visdistance(option.im,meta.spind,meta.spen(:,1),100);
[~,~,energy_n] = g_visdistance(option.im,meta.spind,meta.spen_proped(:,1),250);
allim = [option.im,energy,rgbftmap,energy_n,visim];
imshow(allim);
%imshow(rgbftmap);
end

