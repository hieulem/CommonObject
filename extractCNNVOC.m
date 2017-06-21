function [  ] = extractCNNVOC( i,recs,cpath,net,VOCopts )
 %fprintf('%d/%d \n',i,length(recs));
    %    figure(i)
    imgname = recs(i).filename(1:end-4);
    if ~exist(fullfile(cpath,[imgname,'.mat']),'file')
       disp(imgname); 
        im = imread(sprintf(VOCopts.imgpath,imgname));
        size(im);
        
        if size(im,1) < net.meta.normalization.imageSize(1)
            im = imresize(im,'OutputSize', [net.meta.normalization.imageSize(1),NaN]);
        end;
        if size(im,2) < net.meta.normalization.imageSize(2)
            im = imresize(im,'OutputSize', [NaN,net.meta.normalization.imageSize(2)]);
        end;
        %size(im)
        im = single(im);
        if size(net.meta.normalization.averageImage,3) ==3
            net.meta.normalization.averageImage = mean(mean(net.meta.normalization.averageImage,1),2);
        end
       net.meta.normalization.averageImage;
        im = im - repmat(  net.meta.normalization.averageImage,[size(im,1),size(im,2),1]);
        %    figure(i);
        %   image(im);
        X = vl_simplenn(net,im);
        %size(X)
        for ii=1:length(X)
            X(ii).sz = size(X(ii).x);
            if ii<31
                X(ii).x = [];
            end
        end
        save(fullfile(cpath,imgname),'X');
    end;

end

