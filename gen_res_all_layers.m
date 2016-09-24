function [] = gen_res_all_layers(net,path)

res =[];
nim=[];
oim=[];


filel = dir([path,'/*.jpg']);
numi = length(filel);
numi
nim = single(zeros(224,224,3,numi));

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
    nim(:,:,:,i) = im_;
end

%break down the network
nlayers = length(net.layers);
for i = 1:nlayers
    netlayer{i}.layers = net.layers(i);
end
 
spath = ['../preprocessingdata/',path];
cnnrespath = [spath,'/CNNfes'];
mkdir(spath);
mkdir(cnnrespath);
save(fullfile(spath,'images.mat'),'oim');
save(fullfile(spath,'normimages.mat'),'nim');

%firstlayer
X =  batchforward1layers(netlayer{1},nim,128,2);
save(fullfile(cnnrespath,'1'),'X');

for i=2:nlayers
   i 
    X = batchforward1layers(netlayer{i},X,128,2);
    save(fullfile(cnnrespath,num2str(i)),'X');
end

%res = get_netres(net,nim,32,layer);
%res = vl_simplenn(net,bim) ;
%check

%save([spath,path,'/data/',num2str(layer),'.mat'],'res');
