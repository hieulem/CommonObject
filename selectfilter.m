firstcl = maxres(IDX==1,:);
sed = maxres(IDX==2,:);
dist = mypdist2(maxres,maxres,'sqeuclidean');
K=5;

maxres2 = maxres./repmat(max(maxres,[],2),[1,size(maxres,2)]);

maxres2 = maxres2.^4;
    IDX2 = kmeans(maxres2, 5,'Replicates',5,'Distance','sqeuclidean');
    for i=1:K
        mK(i) = mean(mean(maxres(IDX2==i,:)));
    end
    [~,id] = sort(mK,'descend');
    IDX = IDX2;
     for i=1:K
        IDX(IDX2==id(i)) = i;
     end
     
     find(IDX==1)
    


%repmat(max(maxres,[],2),[1,size(maxres,2)]);