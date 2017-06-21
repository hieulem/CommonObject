function [ oim,A,AA ] = g_visdistance( oim,spind,dist,ints )
%VISDISTANCE Summary of this function goes here
%   Detailed explanation goes here
    mapsize= size(oim);
    
    mapsize(3) = [];
    A = zeros(mapsize);
    for i=1:length(dist)
        A(spind{i}) = dist(i);
    end;
    B = A;
    B(B>0) =1;
    oim=oim/1.6;
    oim(:,:,2) = oim(:,:,2) + uint8(B)*100;
%    imagesc(A);
    if exist('ints');
    AAA= A/max(A(:))*ints;
    AA = ind2rgb(uint8(AAA),parula)*255;
    end;

end

