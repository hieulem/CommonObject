function [meta]  = im2geodesicaff2(option)
if exist(sprintf(option.sppath,option.imgname,option.bdE),'file')
    load(sprintf(option.sppath,option.imgname,option.bdE));
    
    if option.show
        %figure();imagesc(meta.sp);
        %figure(200);imagesc(meta.E);
        %axis image;
        % figure();visgeodistance(meta.sp,meta.graph,node);
        % meta
        
    end;
    return;
end
gop_mex( 'setDetector', 'MultiScaleStructuredForest("GoPCode/lib/gop_1.3/data/sf.dat")' );

os = OverSegmentation(option.im);

meta.E = os.boundaryMap;


meta.sp = os.s;
meta.sp=meta.sp+1;

meta.numsp = numel(unique(meta.sp));
meta.geodist = single(zeros(meta.numsp,meta.numsp));
meta.graph = spAffinities_vu(meta.sp,meta.E);
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

save(sprintf(option.sppath,option.imgname,option.bdE),'meta');

if option.show
 %   figure();imagesc(meta.sp);
    figure(200);imagesc(meta.E);
    axis image;
    % figure();visgeodistance(meta.sp,meta.graph,node);
    % meta
    
end;

