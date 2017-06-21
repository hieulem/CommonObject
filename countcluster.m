d = 'VOC2007/trainval/cluster/';
k = dir(d);
k = k(3:end);
for j=1:20
     load (fullfile(d,k(j).name,'5_cityblock.mat'));
    for t=1:5
        nCluster(j,t) = sum(IDX==t);
    end
end
nCluster