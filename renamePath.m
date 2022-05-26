function renamePath
clc;clear;close all
tbl = readtable('pathway_out/path_abun_unstrat.tsv','FileType','text','delimiter','\t');
mapping = readtable('reference_db/kegg/pwy.hierarchy','FileType','text','delimiter','\t');
id = table2array(tbl(:,1));
map1 = table2array(mapping(:,1));
[idx12,~]=AlignNum(id,map1);
t1 = table2array(mapping(:,2:3));
for i=1:length(map1)
    t2{i,1} = strcat(t1{i,1},'|',t1{i,2});
end
anno = t2(idx12,:);
S = tbl.Properties.VariableNames(2:end);
tab = table2array(tbl(:,2:end));
writeOTUtable('pathway_Bac',anno,S,tab);
end