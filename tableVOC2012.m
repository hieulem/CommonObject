p = 'BSfromCluster/CPstdcorloc0.5';
allfiles = dir(p)
s ='K2_';
stat = [];
allfiles(1:2) = [];
for i=1:length(allfiles)
    if findstr(allfiles(i).name, s)>0
        load(fullfile(p,allfiles(i).name));
        stat = [stat;stats.corloc(1:5)]
    end
        
end
mean(stat)