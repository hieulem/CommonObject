function [ meta] = res2energy( option,meta )

load(option.netmeta);
meta.e = zeros(meta.numsp,option.nfilter);

for sp =1:meta.numsp
        meta.e(sp,:) = mean(meta.mpim(meta.spind{sp}),2);
end
end

