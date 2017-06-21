option.imgname = option.recs_class(option.imn).filename(1:end-4);
option.im = imread(sprintf(option.VOCopts.imgpath,option.recs_class(option.imn).filename(1:end-4)));

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



option.imsize = size(option.im);
option.imsize(3) = [];