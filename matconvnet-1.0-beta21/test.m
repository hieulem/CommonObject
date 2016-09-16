clear;
run matlab/vl_setupnn ;
net = load('imagenet-vgg-f.mat') ;
net = vl_simplenn_tidy(net) ;
path = '.';

filel = dir(['*.JPEG']);
numi = length(filel);
figure(1);
for i=1:numi
  im = imread(filel(i).name);


  im_ = imresize(im, net.meta.normalization.imageSize(1:2)) ;
   oim(:,:,:,i) = im_;
     im_ = single(im_) ; % note: 255 range
  im_ = im_ - net.meta.normalization.averageImage ;
  bim(:,:,:,i) = im_;

end
res = vl_simplenn(net,bim) ;

% Show the classification result.
scores = squeeze(gather(res(end).x)) ;
[bestScore, best] = max(scores) ;

 
figure(1) ;

for i=1:numi
subplot(4,5,i);
 image(  oim(:,:,:,i) ) ;
title(sprintf(' (%d), score %.3f',...
     best(i), bestScore(i))) ;
end

for i=1:20
    figure(1+i)
    for j=1:numi
        subplot(4,5,j);
        imagesc(res(9).x(:,:,i,j));
    end
end