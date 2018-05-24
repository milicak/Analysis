clear all

fileID = fopen('tss_2018_70270.grd','w');

nodval = textread('nod2d.out');
depth = textread('depth.out');
depth = -depth;
element = textread('elem2d.out');


fprintf(fileID,'\n')
for itr = 1:size(nodval,1)
    % node
    % 1	nn	t	x	y	[d]
    A = [1 nodval(itr,1) 0 nodval(itr,2) nodval(itr,3) depth(itr,1)];
    fprintf(fileID,'%2d %5d %2d %12.6f %12.6f %12.6f\n',A);
end
fprintf(fileID,'\n')
for itr = 1:size(element,1)
    % element:
    % 2	ne	t	ntot	n1 n2 n3 ... 	[d]
    A = [2 itr 0 3 element(itr,1) element(itr,2) element(itr,3)];
    fprintf(fileID,'%2d %5d %2d %2d %5d %5d %5d\n',A);
end


fclose(fileID)
