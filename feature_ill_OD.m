cls = 3;
K=5;
kd =2;
iter=1;


addpath('auxiliaries');
warning('off');
setname = {'Airplane100','Car100','Horse100'};
colormap jet
CNNmodel = 'vgg19';
load(['../dataset/ObjectDiscovery/ObjectDiscovery-data/',CNNmodel,setname{cls}]);
option.class=setname{cls};
if exist('th1','var')    option.prop_w = th1;
else    option.prop_w = 0.5;
end;

if exist('th2','var')    option.threshold= th2;
else    option.threshold = 0.3;
end;

switch kd
    case 1
        distance = 'sqeuclidean';
    case 2
        distance ='cityblock';
end;
option.bdE =1;      % Boundary weight
option.layer = 36;
option.show =1;

option.fc=0;
option.bordercut =0.0;

option.netmeta = '../MatconvCNNmodels/imagenet-vgg-verydeep-19.mat';
option.smooththreshold = 0.0;
option.K=K;
option.aK = K+1;
option.distance = distance;

option.nfilter = 512;
%option.filter = 36;
option.layer = 36;

option.basepath =  fullfile('ObjectDiscovery',option.class,'vgg19');
mkdir(option.spbasepath);
option.respath =  fullfile(option.basepath,'corloc');
mkdir(option.respath);
option.corlocrespath =fullfile(option.respath,'%s_K%d_d%s_th_%0.3f_sth%0.3f_W%0.3f_BC_%0.3f.mat');
option.resultsfile = sprintf(option.corlocrespath,option.class,option.K,option.distance,option.threshold,option.smooththreshold,option.prop_w,option.bordercut);

clpath = fullfile(option.basepath,'cluster');mkdir(clpath);
option.Kmeansfile = sprintf('%s/%d_%s.mat',clpath,K,option.distance);
net =load(option.netmeta);

%gen_maxOD(option);
load(option.Kmeansfile);
option.maxres = maxres;

option.aK = option.K+1; 
%option.uIDX(:,1) = zeros(1,option.nfilter);



for imn=1:option.nim
    %[score,~,~] = running_funcOD( option,i,net);
    option.im = imread(option.impath{imn});
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
    option.CNNrespath = option.imcnnres{imn};
    res = load(option.CNNrespath);
    ind=find(IDX==1);
    for ii=1:10
        ftmap = res.X(option.layer).x(:,:,ind(ii));
        
        window_size = 30;
        zoomed_ftmap = backmapping2(ftmap,res.X,option.layer,net);
        [value, location] = max(zoomed_ftmap(:));
        
        
        [R,C] = ind2sub(size(zoomed_ftmap),location) ;
        
        R = R+ window_size;
        C= C+window_size;
        padded_im = padarray(imrotate(padarray(imrotate(option.im,90),30),-90),30);
        figure(1)
        imshow(padded_im); 
        
        figure(ii+1);
        imshow(imresize(padded_im(R-window_size:R+window_size,C-window_size:C+window_size,:),[100 NaN]));
        
        
         
    end;
 pause();   
end;





