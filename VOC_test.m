clear
addpath(fullfile('..','..','dataset','VOCdevkit','VOCcode'));

VOCinit;
clsi=1;
cls = VOCopts.classes{clsi};
path = fullfile('VOC2012',cls);
load(fullfile(path,'imlist.mat'));

