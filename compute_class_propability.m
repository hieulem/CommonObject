function [ meta,option ] = compute_class_propability( option,cnnfile,meta )
res=  load(cnnfile);
load(option.netmeta);

nIDX = size(option.uIDX,2);
%Uscore  = Uscore.^option.power;
res.X(option.layer).x(res.X(option.layer).x<0) = 0;
comb = reshape(res.X(option.layer).x,[],option.nfilter);
maxc = repmat(max(option.maxres,[],2)',[size(comb,1),1]);
comb = comb./maxc;



meta.class_propability = comb * option.uIDX;
%temp = comb * Uscore;
meta.class_propability = reshape(meta.class_propability,size(res.X(option.layer).x,1),size(res.X(option.layer).x,2),[]);