function [ boxes ] = rmredundantwd( boxes )


nwd = size(boxes,1);
if nwd <=1
    return;
end;
count =1;


x1 = boxes(:,1);
y1 = boxes(:,2);
x2 = boxes(:,3);
y2 = boxes(:,4);

nboxes = boxes;
nboxes(:,3) =nboxes(:,3)-nboxes(:,1)+1;
nboxes(:,4) =nboxes(:,4)-nboxes(:,2)+1;


area = (x2-x1+1) .* (y2-y1+1);
iarea = rectint(nboxes,nboxes);

while count< size(boxes,1);
    i = iarea(count,:) ./ (area(count)+area' - iarea(count,:)) ;
    i(count) = 0;
    stupidset= find(i>0.9);
    boxes(stupidset,:) = [];
    area(stupidset) = [];
    iarea(:,stupidset) =[];
    iarea(stupidset,:) =[];
    count=count+1;
    
end





end

