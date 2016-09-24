
load([spath,'/',num2str(layer),'.mat']);
size(res)
nneurals = size(res,3);
for j=1:numi
    maxR(layer,j) = max(max(max(res(:,:,:,j))));
    for i =1:nneurals
        score(i,j) =  max(max(max(res(:,:,i,j)))) /  maxR(layer,j) ;
    end
end

dataE = mean(score,2);
[d,id] = sort(dataE,'descend');

figure(1) ;
% 
for i=1:min(64,numi)
subplot(8,8,i);
 image(  oim(:,:,:,i) ) ;
 set(gca,'visible','off')

end

print([spath,'/image.png'],'-dpng','-r500')

for k =1:30
    figure(1+k)
i = id(k);   
    for j=1:min(64,numi)
       subplot(8,8,j);
        imagesc(res(:,:,i,j));
         set(gca,'visible','off')
    end
    print([spath,'/',num2str(layer),'/',num2str(k,'%04d'),'_',num2str(id(k)),'_',num2str(d(k)),'.png'],'-dpng','-r500')
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
