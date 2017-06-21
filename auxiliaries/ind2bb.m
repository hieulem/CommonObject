function [ boxes ] = ind2bb( size,indexes )
%IND2BB Summary of this function goes here
%   Detailed explanation goes here
    [x,y] = ind2sub(size,indexes);
     boxes = [min(y)',min(x)',max(y)',max(x)'];

end

