cls = 10;
K=5;
idistance =1;
iter=1;

option_VOC2012_vgg19;
option.show=1;
net =load(option.netmeta);

  clustering_features(option);
    load(option.Kmeansfile);
for imn=1:option.nim
    %[score,~,~] = running_funcOD( option,i,net);
    option.imn =imn;
    VOCimageoption;
    option.cls;
  
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

    res = load(fullfile(option.CNNrespath,option.imgname));
    ind=find(IDX==1);
    avg_activation = mean(maxres(ind,:),2);
    [~,sorted_ind] = sort(avg_activation,'descend');
    ind = ind(sorted_ind);
    comb = option.im;
    for ii=1:min(4,length(ind))
        ftmap = res.X(option.layer).x(:,:,ind(ii));
        ftmap = imgaussfilt(ftmap,2);
        window_size = 30;
        zoomed_ftmap = backmapping2(ftmap,res.X,option.layer,net);
        [value, location] = max(zoomed_ftmap(:));
        
        
        [R,C] = ind2sub(size(zoomed_ftmap),location) ;
        
        R = R+ window_size;
        C= C+window_size;
        padded_im = padarray(imrotate(padarray(imrotate(option.im,90),30),-90),30);
       % figure(1)
        %imshow(padded_im);
        
        %figure(ii*2);
        %imshow(imresize(padded_im(R-window_size:R+window_size,C-window_size:C+window_size,:),[100 NaN]));
        
       % figure(ii*3);
        zoomed_ftmap_nm = zoomed_ftmap / max(zoomed_ftmap(:));
        rgbftmap = ind2rgb(uint8(zoomed_ftmap),hot);
        blended = option.im*0.4 +  uint8(rgbftmap*255*0.8);
        %imagesc(blended);
        
        comb = [comb,blended];
        
        
    end;
    
    figure(100);
    imshow(comb);
    pause();
end;





