% this subroutine computes noresm grids woa13 temp and salt data
clear all

woanamet = 'woa13_decav_t00_01v2.nc';
woanames = 'woa13_decav_s00_01v2.nc';

twoa = ncread(woanamet, 't_an');
swoa = ncread(woanames, 's_an');
zwoa = ncread(woanamet, 'depth');
lonwoa = ncread(woanamet, 'lon');
latwoa = ncread(woanamet, 'lat');

% reorganize data to make lon 0 : 360
dnm = twoa;
twoa(1:180,:,:) = twoa(181:end,:,:);
twoa(181:end,:,:) = dnm(1:180,:,:);
dnm = swoa;
swoa(1:180,:,:) = swoa(181:end,:,:);
swoa(181:end,:,:) = dnm(1:180,:,:);

%noresmgrid = 'tnx1v1'
noresmgrid = 'tnx0.25v1'
woa_noresm_file = ['WOA13_' noresmgrid '_65layers.nc'];

switch noresmgrid
    case 'tnx1v1'
      display('mehmet')
      map_file = '/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/maps/map_woa09_1deg_to_noresm_tnx1v1_patch_.nc'; 
      %map_file = '/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/maps/map_woa09_1deg_to_noresm_tnx1v1_aave_.nc'; 
      grid_file ='/hexagon/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
      znoresm = ncread('/work/milicak/mnt/norstore/NS2345K/noresm/cases/NOIIA_T62_tn11_sr10m60d_01/ocn/hist/NOIIA_T62_tn11_sr10m60d_01.micom.hm.0001-01.nc','depth');
      znoresm_bnds =  ncread('/work/milicak/mnt/norstore/NS2345K/noresm/cases/NOIIA_T62_tn11_sr10m60d_01/ocn/hist/NOIIA_T62_tn11_sr10m60d_01.micom.hm.0001-01.nc','depth_bnds');
      nx_b=ncgetdim(grid_file,'x');                                                                        
      ny_b=ncgetdim(grid_file,'y');                                                                        
      % Read interpolation indexes and weights                                        
      n_a=ncgetdim(map_file,'n_a');                                                   
      n_b=ncgetdim(map_file,'n_b');                                                   
      S=sparse(ncgetvar(map_file,'row'),ncgetvar(map_file,'col'), ...                 
               ncgetvar(map_file,'S'),n_b,n_a);                                                      
      for k=1:length(zwoa)
        t_src=reshape(twoa(:,:,k),[],1);                                     
        s_src=reshape(swoa(:,:,k),[],1); 
        t_src(find(isnan(t_src)))=0;                                                  
        s_src(find(isnan(s_src)))=0;                                                  
        t_dst(:,:,k)=reshape(S*t_src,nx_b,ny_b-1);                                      
        s_dst(:,:,k)=reshape(S*s_src,nx_b,ny_b-1); 
      end
      for k=1:length(znoresm)-5
          k
          kindn = max(find(zwoa<=znoresm(k)));
          kindp = min(find(zwoa>znoresm(k)));
          dzn = abs(znoresm(k) - zwoa(kindn));
          dzp = abs(znoresm(k) - zwoa(kindp));
          if(isempty(dzp)~=1)
              tnoresm_woa(:,:,k) = (t_dst(:,:,kindn)*dzp+t_dst(:,:,kindp)*dzn) ...
              /(dzn+dzp);
              snoresm_woa(:,:,k) = (s_dst(:,:,kindn)*dzp+s_dst(:,:,kindp)*dzn) ...
              /(dzn+dzp);
          else
              tnoresm_woa(:,:,k) = (t_dst(:,:,kindn));
              snoresm_woa(:,:,k) = (s_dst(:,:,kindn));
          end
      end
      % add last point
      tnoresm_woa(:,end+1,:) = tnoresm_woa(:,end,:);
      snoresm_woa(:,end+1,:) = snoresm_woa(:,end,:);
      lonmicom
    case 'tnx0.25v1'
      display('mehmet2')
      map_file = '/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/maps/map_woa09_1deg_to_noresm_tnx0.25v1_aave_.nc'
      grid_file ='/hexagon/work/shared/noresm/inputdata/ocn/micom/tnx0.25v1/20130930/grid.nc';
      znoresm = ncread('/work/milicak/mnt/norstore/NS2345K/noresm/cases/NOIIA_T62_tn11_sr10m60d_01/ocn/hist/NOIIA_T62_tn11_sr10m60d_01.micom.hm.0001-01.nc','depth');
      znoresm_bnds =  ncread('/work/milicak/mnt/norstore/NS2345K/noresm/cases/NOIIA_T62_tn11_sr10m60d_01/ocn/hist/NOIIA_T62_tn11_sr10m60d_01.micom.hm.0001-01.nc','depth_bnds');
      nx_b=ncgetdim(grid_file,'x');                                                                        
      ny_b=ncgetdim(grid_file,'y');                                                                        
      % Read interpolation indexes and weights                                        
      n_a=ncgetdim(map_file,'n_a');                                                   
      n_b=ncgetdim(map_file,'n_b');                                                   
      S=sparse(ncgetvar(map_file,'row'),ncgetvar(map_file,'col'), ...                 
               ncgetvar(map_file,'S'),n_b,n_a);                                                      
      for k=1:length(zwoa)
        t_src=reshape(twoa(:,:,k),[],1);                                     
        s_src=reshape(swoa(:,:,k),[],1); 
        t_src(find(isnan(t_src)))=0;                                                  
        s_src(find(isnan(s_src)))=0;                                                  
        t_dst(:,:,k)=reshape(S*t_src,nx_b,ny_b-1);                                      
        s_dst(:,:,k)=reshape(S*s_src,nx_b,ny_b-1); 
      end
      for k=1:length(znoresm)-5
          k
          kindn = max(find(zwoa<=znoresm(k)));
          kindp = min(find(zwoa>znoresm(k)));
          dzn = abs(znoresm(k) - zwoa(kindn));
          dzp = abs(znoresm(k) - zwoa(kindp));
          if(isempty(dzp)~=1)
              tnoresm_woa(:,:,k) = (t_dst(:,:,kindn)*dzp+t_dst(:,:,kindp)*dzn) ...
              /(dzn+dzp);
              snoresm_woa(:,:,k) = (s_dst(:,:,kindn)*dzp+s_dst(:,:,kindp)*dzn) ...
              /(dzn+dzp);
          else
              tnoresm_woa(:,:,k) = (t_dst(:,:,kindn));
              snoresm_woa(:,:,k) = (s_dst(:,:,kindn));
          end
      end
      % add last point
      tnoresm_woa(:,end+1,:) = tnoresm_woa(:,end,:);
      snoresm_woa(:,end+1,:) = snoresm_woa(:,end,:);
      lonmicom2

    end
% create netcdf for WOA in NorESM grid
ncid=netcdf.create(woa_noresm_file,'NC_CLOBBER');
% Define dimensions.                                                            
ni_dimid=netcdf.defDim(ncid,'ni',nx_b);                                           
nj_dimid=netcdf.defDim(ncid,'nj',ny_b);                                           
nz_dimid=netcdf.defDim(ncid,'depth',length(znoresm)-5); 

tlon_varid=netcdf.defVar(ncid,'TLON','float',[ni_dimid nj_dimid]);              
netcdf.putAtt(ncid,tlon_varid,'long_name','T grid center longitude');           
netcdf.putAtt(ncid,tlon_varid,'units','degrees_east');                          
netcdf.putAtt(ncid,tlon_varid,'bounds','lont_bounds');                          
                                                                                
tlat_varid=netcdf.defVar(ncid,'TLAT','float',[ni_dimid nj_dimid]);              
netcdf.putAtt(ncid,tlat_varid,'long_name','T grid center latitude');            
netcdf.putAtt(ncid,tlat_varid,'units','degrees_north');                         
netcdf.putAtt(ncid,tlat_varid,'bounds','latt_bounds');                          
                                                                                
sigma_varid=netcdf.defVar(ncid,'depth','float',[nz_dimid]);                     
netcdf.putAtt(ncid,sigma_varid,'long_name','vertical coordinate');                
netcdf.putAtt(ncid,sigma_varid,'units','m');                               
                                                                                
twoa_varid=netcdf.defVar(ncid,'twoa_noresm','double',[ni_dimid nj_dimid nz_dimid]);            
netcdf.putAtt(ncid,twoa_varid,'long_name','WOA13 temperature on NorESM grid');             
netcdf.putAtt(ncid,twoa_varid,'units','C');                                  
netcdf.putAtt(ncid,twoa_varid,'coordinates','TLON TLAT');                      

swoa_varid=netcdf.defVar(ncid,'swoa_noresm','double',[ni_dimid nj_dimid nz_dimid]);            
netcdf.putAtt(ncid,swoa_varid,'long_name','WOA13 salinity on NorESM grid');             
netcdf.putAtt(ncid,swoa_varid,'units','psu');                                  
netcdf.putAtt(ncid,swoa_varid,'coordinates','TLON TLAT');                      

% End definitions and leave define mode.
netcdf.endDef(ncid)
% Provide values for time invariant variables.                                  
netcdf.putVar(ncid,tlon_varid,single(lon));                                    
netcdf.putVar(ncid,tlat_varid,single(lat));                                    
netcdf.putVar(ncid,sigma_varid,single(znoresm(1:end-5))); 
netcdf.putVar(ncid,twoa_varid,tnoresm_woa);                                    
netcdf.putVar(ncid,swoa_varid,snoresm_woa);                                    

