function [ meta,option ] = genbackmapping( option,cnnfile,meta,net )

res=  load(cnnfile);
%net = load(option.netmenetta);
nIDX = size(option.uIDX,2);

if option.fc ==0
  %  ftmap = res.X(option.layer).x;
 %   ftmap(ftmap<0) = 0;
    res.X(option.layer).x(res.X(option.layer).x<0) = 0;
    feature_maps = reshape(res.X(option.layer).x,[],option.nfilter);
    maxc = repmat(max(option.maxres,[],2)',[size(feature_maps,1),1]);
   % feature_maps = feature_maps./maxc;  % pls check this again.
    combined = feature_maps * option.uIDX;
    
    %temp = comb * Uscore;
    combined = reshape(combined,size(res.X(option.layer).x,1),size(res.X(option.layer).x,2),[]);
elseif option.fc==1
        sz = size(res.X(15).x);
       
        ftmap = res.X(15).x;
         ftmap = imregionalmax(ftmap);
        ftmap(ftmap<0) = 0;
        border= floor(sz(1:2)*option.bordercut);
        ftmap(1:border(1),:,:) =0;
        ftmap(end-border(1):end,:,:) =0;
        ftmap(:,1:border(2),:) =0;
        ftmap(:,end-border(2):end,:) =0;
    
        energy_per_cl = option.simplifed_w_from_conv_2_fc*option.uIDX;
        %energy_per_cl = energy_per_cl - repmat(min(energy_per_cl),[256,1]);
        energy_per_cl(energy_per_cl<0) = 0;
        %energy_per_cl =  energy_per_cl./ repmat(max(energy_per_cl),[256,1]);
        ft_map  = reshape(ftmap,[],256) ;
      %  energy_per_cl = energy_per_cl.^2;
        combined= reshape(ft_map*energy_per_cl,sz(1),sz(2),[]);
        for i=1:nIDX
        combined(:,:,i) = combined(:,:,i)./max(max(combined(:,:,i)));
        
        end
        option.layer = 15;  
end;

meta.mpim = backmapping2(combined,res.X,option.layer,net);
if size(meta.mpim,1)~=size(option.im,1) || size(meta.mpim,2)~=size(option.im,2)
    meta.mpim = imresize(meta.mpim,[size(option.im,1),size(option.im,2)]);
end
for i=1:nIDX
    en = meta.mpim(:,:,i);
    for sp =1:meta.numsp
        meta.spen(sp,i) = mean(en(meta.spind{sp}));
    end
end
end

