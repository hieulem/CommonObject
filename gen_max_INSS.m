function [maxres] = gen_max_INSS(option)
K=option.K;

if ~exist(option.Kmeansfile,'file')
    layer = option.layer;
    maxres = zeros(option.nfilter,option.nim);
    numi = option.nim;
    
    fprintf('%s : %d images \n',option.class,numi);
   
    tic
    for i=1:option.nim
        
        a = toc;
        if a>10
            fprintf('%d / %d \n',i,numi);
            tic;
        end
      
        res = load(option.imcnnres{i});
        res.X(layer).x(res.X(layer).x<0) = 0;
        nfilter = size(res.X(layer).x,3);
        for filt=1:nfilter
            maxres(filt,i) = max(max(res.X(layer).x(:,:,filt)));
            %  Uscore(filt) = Uscore(filt) + max(max(res.X(layer).x(:,:,filt))) /  max_activation(i) / numi  ;
        end;
    end
    
    b = repmat(max(maxres,[],1),[option.nfilter,1]);
    aa = maxres./b;
   
    IDX2 = kmeans(maxres, K,'Distance',option.distance);
    for i=1:K
        mK(i) = mean(mean(maxres(IDX2==i,:)));
    end
    [~,id] = sort(mK,'descend');
    IDX = IDX2;
     for i=1:K
        IDX(IDX2==id(i)) = i;
     end
    
    save(option.Kmeansfile,'IDX','maxres');

end
%save(fullfile(path,'maxres'),'maxres');
