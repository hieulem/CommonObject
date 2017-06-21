addpath(fullfile('..','dataset','VOCdevkit','VOCcode'));VOCinit;
option.cls = VOCopts.classes{option.clsi};
option.imlistpath = fullfile('VOC2012',option.dataset,'imlist',option.cls); load(fullfile(option.imlistpath,'imlist.mat'));
if option.sm
    k= [recs_class(:).segmented];
    k = find(k==true);
    option.imn = k(option.imn);
end
option.recs_class = recs_class;
option.VOCopts = VOCopts;
option.nim = length(recs_class);
