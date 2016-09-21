clear;
run matlab/vl_setupnn ;
net = load('../../MatconvCNNmodels/imagenet-vgg-verydeep-19.mat') ;
net = vl_simplenn_tidy(net) ;
path = 'caltech/airplanes';

filel = dir([path,'/*.jpg']);
numi = length(filel);
figure(1);
for i=1:numi
  im = imread(fullfile(path,filel(i).name));
  if size(im,3) ==1
      im = repmat(im,[1,1,3]);
  end


  im_ = imresize(im, net.meta.normalization.imageSize(1:2)) ;
   oim(:,:,:,i) = im_;
     im_ = single(im_) ; % note: 255 range
   avgim = repmat(  net.meta.normalization.averageImage,[224,224,1]);
   im_ = im_ - avgim;
  
  %im_ = im_ - net.meta.normalization.averageImage ;
  
  bim(:,:,:,i) = im_;

end
res = get_netres(net,bim,256);
%res = vl_simplenn(net,bim) ;
check
