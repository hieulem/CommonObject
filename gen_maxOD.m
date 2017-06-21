function [maxres] = gen_maxOD(option)
K=option.K;

if true%~exist(option.Kmeansfile,'file')
    layer = 36;
    maxres = zeros(512,option.nim);
    numi = option.nim;
    
    fprintf('%s : %d images \n',option.dataset,numi);
   
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
    
    b = repmat(max(maxres,[],1),[512,1]);
    aa = maxres./b;
    IDX2 = kmeans(maxres, K,'Replicates',5,'Distance',option.distance);
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
