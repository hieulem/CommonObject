function [] =  fix_old_train ()
d = 'VOC2012/train/CNNres';
nd = 'VOC2012/train_n/CNNres';
mkdir(nd);
clist = dir(d);
for i =1:length(clist)
    if clist(i).name(1) ~= '.';
        fprintf('%s %d/%d \n',clist(i).name,i,length(clist));
        load(fullfile(d,clist(i).name));
        for layer=1:length(X)
     %       X(layer).sz =size(X(layer).x);
            if layer ~=36
                X(layer).x = [];
            end

        end
        save(fullfile(nd,clist(i).name),'X');
    end
end



