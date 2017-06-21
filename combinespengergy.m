function[meta] = combinespengergy(option,meta)
sfile = fullfile(option.imlistpath,'Uscore');
load(sfile);
Uscore  = Uscore.^option.power;
%t= Uscore(221);
%Uscore =0*Uscore;
%Uscore(221) = t;
[d,id] = sort(Uscore,'descend');
%Uscore(id(2))=0;
%Uscore(id(4:end)) = 0;
Uscore = Uscore / sum(Uscore);

meta.spen = meta.e*Uscore;
meta.spen = meta.spen';

end