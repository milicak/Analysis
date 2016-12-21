clear all

Nx=1440;
Ny=1152;

nx=Nx*4;
ny=Ny*4;

variable = [{'parea'}];


var=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/maps/grid_0_25degree.nc',char(variable));

for i=1:Nx
 for k1=1:4
   for j=1:Ny
      for k2=1:4
        aa(4*(i-1)+1+k1-1,(j-1)*4+1+k2-1)=var(i,j)+0.25*(k2-1)*(var(i,j+1)-var(i,j));
      end
   end
 end
end

