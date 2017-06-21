function[] = callrunVOC2012(i)

%20 clas
%9 K
%2 distance

[a]  =  myind2sub([20,1,1],i,3)
cls = a(1)
dist = 2;% {'sqeuclidean','cityblock'};

%dis = dist{a(2)}
K = 10;%a(3)+1

FT_2012_vgg16(cls,K,dist,10);
  


end

