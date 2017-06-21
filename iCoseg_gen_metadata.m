function [meta] = iCoseg_gen_metadata(option)
temp = dir(fullfile(option.datapath,option.dataset));
gtpath = fullfile(option.datapath,option.dataset,'GroundTruth');
meta.cnnrespath =fullfile('iCoseg',option.dataset,['CNNres_',option.CNNmodel]);
meat.spbasepath = fullfile('iCoseg',option.dataset,'sp');
meta.sppath = fullfile('iCoseg',option.dataset,'sp','%s_%d.mat');
temp(1:2) = [];
meta.nim=0;
for i=1:length(temp)
    if ~temp(i).isdir
        if isempty(strmatch('.DS',temp(i).name))
            ind =[];
            meta.nim = meta.nim+1;
            meta.imname{meta.nim} = temp(i).name;
            meta.impath{meta.nim}=fullfile(option.datapath,option.dataset,meta.imname{meta.nim});
            meta.imcnnres{meta.nim} =  fullfile(meta.cnnrespath,[temp(i).name(1:end-4),'.mat']);
            meta.imsppath{meta.nim} =  fullfile(meta.sppath,[temp(i).name(1:end-4),'.mat']);
            gt = imread(fullfile(gtpath,[temp(i).name(1:end-4),'.png']));
            
            ind = find(gt>0, 1);

            if isempty(ind)
                meta.validim(meta.nim) = 0;
            else
                meta.validim(meta.nim) = 1;
                object_ind = unique(gt);
                bboxes = zeros(size(object_ind,1)-1,4);
                c=0;
                for j=1:size(object_ind,1)
                    if object_ind(j) ~=0
                        c=c+1;
                       bboxes(c,:) = ind2bb(size(gt),find(gt==object_ind(j)));
                    end
                end
                 meta.objectbb{meta.nim}  = bboxes;
            end
            %    imagesc(gt)
            %  pause;
        end;
    end
end

save(option.datasetmetafile,'meta');
end