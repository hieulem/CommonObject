function []= combine(option)
layer = option.layer;
saveflag =option.saveflag;
load(option.netmeta);
%fprintf('%s : %d images \n',cls,numi);
sfile = fullfile(option.imlistpath,'Uscore');
load(sfile);
Uscore  = Uscore.^option.power;
Uscore = Uscore / sum(Uscore);

[d,id] = sort(Uscore,'descend');

res = load(fullfile(option.CNNrespath,option.imgname));

sdir = fullfile('VOC2012','val_vis_combined',option.cls);

if ~exist(sdir,'dir') mkdir(sdir); end;
figure(1);imshow(option.im);
img = option.im;


figure(1);
imshow(img);

B= single(zeros(size(img,1),size(img,2)));

k = 1;
while k<512 && Uscore(id(k)) > 10e-4
    
    
    i=id(k);
    T = backmapping(res.X,layer,i,net);
    %  if(max(max(T)) > 0)
    %T= T/max(max(T));
    % end;
   % T(T<0) = 0;
    
    
    
    B = B+T *Uscore(i);
    k=k+1;
end
k
C = img/2;
BB  = B/(max(max(B)))*100;
C(:,:,2) = C(:,:,2)  + uint8(BB);
figure(3);
imagesc(B);truesize;    axis off;
axis image;
figure(2);imshow(C);    axis off;
axis image;

if saveflag
    figure(2);
    print(fullfile(sdir,[option.imgname,'_',num2str(layer),'_blended.png']),'-dpng');
    
    figure(3);
    print(fullfile(sdir,[option.imgname,'_',num2str(layer),'.png']),'-dpng');
end

