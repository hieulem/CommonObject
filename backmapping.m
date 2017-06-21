function [ res ] = backmapping( X,layer,filter,net )
%BACKMAPPING Summary of this function goes here
%   Detailed explanation goes here

res = X(layer).x(:,:,filter);
res(res<0) = 0;
flag =false;
    if ~isfield(X(35),'sz')
        flag = true;
    end;
for i = (layer):-1:2
   if flag
             X(i-1).sz = size(X(i-1).x);
     end
    res = backward2(net.layers(i-1),res,X(i-1).sz);

  %  fprintf(' true size :%d %d %d ',size(X(i-1).x));
   % fprintf(' our size :%d %d \n',size(res));
end
 
    %figure(3); colormap('jet');
   % image(res);
end

