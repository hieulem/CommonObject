function [] = gen_res(net,path,layer)

    res =[];
    bim=[];
    oim=[];


filel = dir([path,'/*.jpg']);
numi = length(filel);
numi
bim = single(zeros(224,224,3,numi));

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
res = get_netres(net,bim,32,layer);
%res = vl_simplenn(net,bim) ;
%check
spath = '../qualres/';
mkdir([spath,path]);
mkdir([spath,path,'/data']);
save([spath,path,'/data/',num2str(layer),'.mat'],'res');
