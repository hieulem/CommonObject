function [meta]  = im2geodesicaff2(option)
% if exist(sprintf(option.sppath,option.imgname,option.bdE),'file')
%    load(sprintf(option.sppath,option.imgname,option.bdE));
%    return;
% end

%os = OverSegmentation(option.im);

model=load('models/forest/modelBsds'); 
model=model.model;
model.opts.nms=0; model.opts.nThreads=4;
model.opts.multiscale=0; model.opts.sharpen=0;

%% set up opts for spDetect (see spDetect.m)
opts = spDetect;
opts.nThreads = 4;  % number of computation threads
opts.k = 500;       % controls scale of superpixels (big k -> big sp)
opts.alpha = .2;    % relative importance of regularity versus data terms
opts.beta = .9;     % relative importance of edge versus color terms
opts.merge = 0;     % set to small value to merge nearby superpixels at end
opts.bounds = 0;


[E,~,~,segs]=edgesDetect(option.im,model);
[sp,V] = spDetect(option.im,E,opts);
%E = E+1e-20;
meta.sp=sp+1;
meta.E =E;
[A,E,U] = spAffinities( sp+1, E, segs,1);
meta.graph = A;
%meta.E = meta.E.^option.bdE;

%meta.sp = os.s;
%meta.sp=meta.sp+1;

meta.numsp = numel(unique(meta.sp));
meta.geodist = single(zeros(meta.numsp,meta.numsp));
%[A,E,U] = spAffinities( S, E, segs, 1 );
%meta.graph = spAffinities_vu(meta.sp,meta.E);
meta.graph = sparse(double(meta.graph));
meta.graph(meta.graph<0) =0 ;


sizeof1layer = size(option.im,1)*size(option.im,2);
h = ((1:option.nfilter)-1)*sizeof1layer;h=h';

for i=1:meta.numsp
    root = int32(find(meta.sp ==i));
    %root = repmat(root',[option.nfilter,1]);
    %root = root +repmat(h,[1,size(root,2)]);
    meta.spind{i} = root;
    meta.sparea(i)  = int32(length(root));
end



meta.geodist = single(graphallshortestpaths(meta.graph));

%save(sprintf(option.sppath,option.imgname,option.bdE),'meta');

if option.show
    % figure();imagesc(meta.sp);
    figure(200);imagesc(meta.E);
    axis image;
    % figure();visgeodistance(meta.sp,meta.graph,node);
    % meta

end;

