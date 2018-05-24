depth=ncread('out.nc','total_depth'); 
x=ncread('out.nc','longitude');
y=ncread('out.nc','latitude'); 
trimesh(elem',x,y,depth,'edgecolor','none','facecolor','interp');view(2);colorbar;
ssh=ncread('out.nc','water_level');
trisurf(elem',x,y,ssh(:,3),'edgecolor','none','facecolor','interp');view(2);colorbar;caxis([0. 0.01])

