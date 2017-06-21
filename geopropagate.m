function [meta] = geopropagate(option,meta)
meta.prop_w = exp(-1/option.prop_w* meta.geodist) ;
for i=1:size(meta.prop_w,1)
   %meta.prop_w(:,i) = meta.prop_w(:,i) / max(meta.prop_w(:,i) );
%   meta.prop_w(meta.prop_w(:,i)  > 5,i) =5;
 %  meta.prop_w(:,i) = meta.prop_w(:,i) / sum(meta.prop_w(:,i) );

   %meta.prop_w(:,i) = exp(-1/option.prop_w* meta.prop_w(:,i)) ;
   %meta.prop_w(i,i) = 0;
   meta.prop_w(i,:) = meta.prop_w(i,:) / sum(meta.prop_w(i,:) );

   
end
%meta.prop_w(logical(eye(size(meta.prop_w)))) = 0;
meta.spen_proped = meta.prop_w* meta.spen;

end
 