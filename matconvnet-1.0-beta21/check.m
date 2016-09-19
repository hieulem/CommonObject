layer=36;
size(res(layer).x)
nneurals = size(res(layer).x,3);
for j=1:numi
    maxR(layer,j) = max(max(max(res(layer).x(:,:,:,j))));
    for i =1:nneurals
        score(i,j) =  max(max(max(res(layer).x(:,:,i,j)))) /  maxR(layer,j) ;
    end
end

dataE = mean(score,2);
[d,id] = sort(dataE,'descend');

figure(1) ;
% 
for i=1:numi
subplot(5,10,i);
 image(  oim(:,:,:,i) ) ;
end



for k =1:5
    figure(1+k)
i = id(k);   
    for j=1:numi
       subplot(5,10,j);
        imagesc(res(layer).x(:,:,i,j));
    end
end

% 
% for i=1:nneurals
%     for j = 1:numi
%    % res(9).x(:,:,i,j)
%    % mean(mean(res(9).x(:,:,i,j)))
%        k(i,j) =  max(max(res(layer).x(:,:,i,j)));
%     end
% end
% 
% 
% m = mean(k,2);
% figure(layer); histogram(m);
