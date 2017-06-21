function [ res ] = backmapping2( cim,X,layer,net )
%BACKMAPPING Summary of this function goes here
%   Detailed explanation goes here
res =cim;
%res = X(layer).x;
res(res<0) = 0;

for i = (layer):-1:2
    res = backward2(net.layers(i-1),res,X(i-1).sz);

 %   fprintf(' true size :%d %d %d ',size(X(i-1).x));
%    fprintf(' our size :%d %d \n',size(res));
end
 
   % figure(3); colormap('jet');
    %image(res);
end

