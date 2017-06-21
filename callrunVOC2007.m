function[] = callrunVOC2007(i)

%20 clas
%9 K
%2 distance

[a]  =  myind2sub([20,1,1],i,3);
cls = a(1)
dist = 2;% {'sqeuclidean','cityblock'};
K = 10;

FT_2007_alex(cls,K,dist,20);
  


end

