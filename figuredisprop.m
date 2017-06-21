option.cls =1;

option_VOC2012_vgg19;
option.show=0;
if option.fc==1
    net = load(option.netmeta);
    ww = net.layers{16}.weights{1};
    option.simplifed_w_from_conv_2_fc = squeeze(sum(squeeze(sum(ww,1)),1));
    temp1 = max(option.simplifed_w_from_conv_2_fc);
    temp1 = repmat(temp1,256,1);
     temp2 = min(option.simplifed_w_from_conv_2_fc);
    temp2 = repmat(temp2,256,1);
    option.simplifed_w_from_conv_2_fc = (option.simplifed_w_from_conv_2_fc- temp2)./(temp1-temp2)*4 -2;
    
end

addpath(fullfile('GoPCode'));
addpath(genpath(fullfile('GoPCode')));
init_gop;
gop_mex( 'setDetector', 'MultiScaleStructuredForest("GoPCode/lib/gop_1.3/data/sf.dat")' );

w =[0.5,1,2];
meta.spen(:,1) =0;
%meta.spen(300,1) =0.3;
meta.spen(451,1) =0.5;
[~,rr] = g_visdistance(option.im,meta.spind,meta.spen(:,1));
rr = rr+ meta.E/10;
for i=1:3
option.prop_w = w(i);
meta = geopropagate(option,meta);
[~,r] = g_visdistance(option.im,meta.spind,meta.spen_proped(:,1)*100);
r = r+ meta.E/10;
rr = [rr,r];
end
figure(1);
imshow(option.im)
figure(2);
imagesc(rr,[0,0.5]);
colormap('jet')
set(gca, 'XTick', [],'YTick',[]);
truesize;
axis image;
h=gca;
F=getframe(h);
set(gca, 'XTick', [],'YTick',[]);
im=F.cdata;
set(gca,'LooseInset',get(gca,'TightInset'))