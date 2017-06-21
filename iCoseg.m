
option.datapath = '../dataset/ObjectDiscovery/ObjectDiscovery-data/Data/sub_iCoseg/';
option.CNNmodel = 'vgg19';
option.dataset = 'bear';
option.basepath = fullfile('./iCoseg',option.CNNmodel,option.dataset);
if ~exist(option.basepath,'dir') mkdir(option.basepath); end;
option.datasetmetafile = fullfile(option.basepath,[option.dataset,'_meta.mat']);
if ~exist(option.datasetmetafile,'file')
    option.meta = iCoseg_gen_metadata(option);
else 
    temp =load(option.datasetmetafile);
    option.meta  = temp.meta;
end
