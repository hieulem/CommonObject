for imn=4:100
    option.imn=imn;
    option.imgname = option.recs_class(option.imn).filename(1:end-4);
    option.im = imread(sprintf(option.VOCopts.imgpath,option.recs_class(option.imn).filename(1:end-4)));
    res = load(fullfile(option.CNNrespath,option.imgname));
    
    
    sz = size(res.X(15).x);
    
    
    for j=1:5
        ww = net.layers{16}.weights{1}(:,:,:,IDX==j);
        %ww(ww<0) = 0;
        per_ft_ww = squeeze(mean(squeeze(mean(ww,1)),1));
        % per_ft_ww(per_ft_ww<0) =0;
        indx_ft = sum(per_ft_ww,2);
        indx_ft(indx_ft<0) =0;
        ft_map  = reshape(res.X(15).x,[],256);
        combined = reshape(ft_map*indx_ft,sz(1),sz(2));
        
        
 
        
        
        
        meta.mpim = backmapping2(combined,res.X,15,net);
        

       figure(2); subplot(1,5,j);imagesc(combined);
        figure(3); subplot(1,5,j);imagesc(meta.mpim);
    
end;

truesize;
figure(1); imshow(option.im);
pause;
end;