clear all                                                                       
                                                                                
                                                                                
outname = 'utss_shyfem_esmf_meshinfo.nc'                                                
                                                                                
% longitude                                                                     
nodeCoords(:,1) = nc_read('uTSS_lobc_chunk_0365.nos.nc','longitude');
% latitude                                                                      
nodeCoords(:,2) = nc_read('uTSS_lobc_chunk_0365.nos.nc','latitude');
                                                                                
%element connections 2D                                                         
elemcon = int32(nc_read('uTSS_lobc_chunk_0365.nos.nc','element_index'));
elemcon = elemcon';
                                                                                
numelem(1:size(elemcon,1)) = int8(3);                                           

for i=1:size(elemcon,1)
    centerCoords(i,1)=mean(nodeCoords(elemcon(i,:),1));
    centerCoords(i,2)=mean(nodeCoords(elemcon(i,:),2));
end
                                                                                
nccreate(outname,'nodeCoords','Dimensions', ...                                 
        {'coordDim',size(nodeCoords,2), ...                                     
        'nodeCount',size(nodeCoords,1)},'Format','classic')                     

nccreate(outname,'centerCoords','Dimensions', ...                                 
        {'coordDim',size(centerCoords,2), ...                                     
        'elementCount',size(centerCoords,1)},'Format','classic')                     
                                                                                
nccreate(outname,'elementConn','Dimensions', ...                                
        {'maxNodePElement',size(elemcon,2), ...                                 
        'elementCount',size(elemcon,1)},'Datatype','int32','Format','classic')  
                                                                                
nccreate(outname,'numElementConn','Dimensions', ...                             
        {'elementCount',size(elemcon,1)},'Datatype','int8','Format','classic')  
                                                                                
                                                                                
% write variables into netcdf                                                   
ncwrite(outname,'nodeCoords',nodeCoords');                                      
ncwriteatt(outname,'nodeCoords','units','degrees');
ncwrite(outname,'centerCoords',centerCoords');                                      
ncwriteatt(outname,'centerCoords','units','degrees');
ncwrite(outname,'elementConn',elemcon');                                        
ncwriteatt(outname,'elementConn','long_name','Node Indices that define the element connectivity');
ncwriteatt(outname,'elementConn','_FillValue',-1);
ncwriteatt(outname,'elementConn','start_index',1);
ncwrite(outname,'numElementConn',numelem);                                      
ncwriteatt(outname,'numElementConn','long_name','Number of nodes per element');
