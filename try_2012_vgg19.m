function[] = try_2012_vgg19(cls,K,idistance,ntry)
option_VOC2012_vgg19;
option.show=1;
if option.fc==1
    net = load(option.netmeta);
    ww = net.layers{16}.weights{1};
    option.simplifed_w_from_conv_2_fc = squeeze(sum(squeeze(sum(ww,1)),1));
    temp1 = max(option.simplifed_w_from_conv_2_fc);
    temp1 = repmat(temp1,256,1);
    temp2 = min(option.simplifed_w_from_conv_2_fc);
    temp2 = repmat(temp2,256,1);
    option.simplifed_w_from_conv_2_fc = (option.simplifed_w_from_conv_2_fc- temp2)./(temp1-temp2)*2 -1;
    
end

addpath(fullfile('GoPCode'));
addpath(genpath(fullfile('GoPCode')));
init_gop;


for l = 1:ntry
    cmax = 0;

    cmax
    %if true
    clear meta windows u_score stats cu_score cn_window windows;
    clustering_features(option);
    load(option.Kmeansfile);
    option.maxres = maxres;
    option.K = numel(unique(IDX));
    option.aK = option.K+1;
%     for i=1:option.K
%         option.uIDX(:,i) =  [IDX == i];
%     end
    option.uIDX(:,1) = zeros(1,option.nfilter);
    for i=2:option.aK
        option.uIDX(:,i) = [IDX == (i-1)];
        if sum(option.uIDX(:,1)) < 200
            option.uIDX(:,1)  = option.uIDX(:,1) + [IDX == (i-1)];
        end
    end
    
    net = load(option.netmeta);
    if option.show ==1
        
        for imn=1:option.nim
            imn
            [ score,nwinds,wds ] = running_funcVOC_test_mu( option,imn,net);
            score
            cu_score{imn} =  score;
            cn_window{imn} =  nwinds;
            windows{imn} = wds;
            pause();
        end;
    end;
    if option.show == 0
        parfor imn=1:option.nim
            
            [ score,nwinds,wds ] = running_funcVOC_test_mu( option,imn,net);
            %score;
            cu_score{imn} =  score;
            cn_window{imn} =  nwinds;
            windows{imn} = wds;
             
        end;
    end
    u_score=vertcat(cu_score{:});
    n_window = vertcat(cn_window{:});
    stats.corloc = sum(u_score>=0.5) / option.nim;
    stats.nwindows  = mean(n_window);
    stats.corloc
    % disp(option.K);
    if  max(stats.corloc(2)) > cmax
        cmax = max(stats.corloc(2));
        option.cls;
        stats.corloc;
        disp('fucking saving');
        %    save(option.resultsfile,'u_score','windows','n_window','stats','option');
    end
end

