clear all

dnm = textread('elem2d.out');
tmp = textread('nod2d.out');

outname = 'tss_esmf_meshinfo.nc'

% longitude
nodeCoords(:,1) = tmp(:,2);
% latitude
nodeCoords(:,2) = tmp(:,3); 

%element connections 2D
elemcon = int32(dnm);

numelem(1:size(elemcon,1)) = int8(3);

nccreate(outname,'nodeCoords','Dimensions', ...
        {'coordDim',size(nodeCoords,2), ...
        'nodeCount',size(nodeCoords,1)},'Format','classic')

nccreate(outname,'elementConn','Dimensions', ...
        {'maxNodePElement',size(elemcon,2), ...
        'elementCount',size(elemcon,1)},'Datatype','int32','Format','classic')

nccreate(outname,'numElementConn','Dimensions', ...
        {'elementCount',size(elemcon,1)},'Datatype','int8','Format','classic')


% write variables into netcdf
ncwrite(outname,'nodeCoords',nodeCoords');
ncwrite(outname,'elementConn',elemcon');
ncwrite(outname,'numElementConn',numelem);
