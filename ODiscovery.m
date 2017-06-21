for i=1:3
    ss(i,:) = runObjectDiscovery(i,5,'cityblock');
end
ss
mean(ss)