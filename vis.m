function[] = vis(layer,c)
%layer =36; %36 is after relu
close all;
%c=15;
datasetpath = 'caltech';
dataset = dir(datasetpath);
imspath = ['caltech/', dataset(c).name];
spath = ['../preprocessingdata/',imspath];
filel = dir([imspath,'/*.jpg']);
numi = length(filel);
cnnrespath = [spath,'/CNNfes'];
load([cnnrespath,'/',num2str(layer),'.mat']);
load([spath,'/images.mat']);

vispath = fullfile('../qualres',imspath,num2str(layer));
mkdir(vispath);

size(X)
nneurals = size(X,3);
for j=1:numi
    maxR(layer,j) = max(max(max(X(:,:,:,j))));
    for i =1:nneurals
        score(i,j) =  max(max(max(X(:,:,i,j)))) /  maxR(layer,j) ;
    end
end

dataE = mean(score,2);
[d,id] = sort(dataE,'descend');

figure(1) ;
% 
for i=1:min(64,numi)
subplot(8,8,i);
 image( uint8( oim(:,:,:,i) )) ;
 set(gca,'visible','off')

end

print([vispath,'/image.png'],'-dpng','-r500')

for k =1:10
    figure(1+k)
i = id(k);   
    for j=1:min(64,numi)
       subplot(8,8,j);
        imagesc(X(:,:,i,j));
         set(gca,'visible','off')
    end
    print(fullfile(vispath,[num2str(k,'%04d'),'_',num2str(id(k)),'_',num2str(d(k)),'.png']),'-dpng','-r500')
end

% 
% for i=1:nneurals
%     for j = 1:numi
%    % X(9).x(:,:,i,j)
%    % mean(mean(X(9).x(:,:,i,j)))
%        k(i,j) =  max(max(X(layer).x(:,:,i,j)));
%     end
% end
% 
% 
% m = mean(k,2);
% figure(layer); histogram(m);
