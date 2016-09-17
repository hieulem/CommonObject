for layer=8:20

nneurals = size(res(layer).x,3);
for i=1:nneurals
    for j = 1:numi
   % res(9).x(:,:,i,j)
   % mean(mean(res(9).x(:,:,i,j)))
       k(i,j) =  max(max(res(layer).x(:,:,i,j)));
    end
end


m = mean(k,2);
figure(layer); histogram(m);
end