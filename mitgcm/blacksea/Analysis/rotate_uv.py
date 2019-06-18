import numpy as np
import numpy.ma as ma
import glob
import xarray as xr
import sys
import pandas as pd
import matplotlib.pyplot as plt
from wrf import uvmet
# import ESMF
from mpl_toolkits.basemap import Basemap
from matplotlib.colors import LinearSegmentedColormap
#import cartopy.crs as ccrs
#from cartopy.mpl.gridliner import LONGITUDE_FORMATTER, LATITUDE_FORMATTER

plt.ion()

cen_long = 33.28796
cone = 1

uvel = xr.open_dataset('/media/milicak/DATA1/datasets/WRF/BSA03/U10_full.nc')
vvel = xr.open_dataset('/media/milicak/DATA1/datasets/WRF/BSA03/V10_full.nc')
lon = xr.open_dataset('/media/milicak/DATA1/datasets/WRF/BSA03/wrf_model_mask.nc')['XLONG']
lat = xr.open_dataset('/media/milicak/DATA1/datasets/WRF/BSA03/wrf_model_mask.nc')['XLAT']

a = np.zeros((10292, 464, 612))
b = np.zeros((10292, 464, 612))

itrend = 10292

for itr in range(0,itrend):
    a[itr,:,:],b[itr,:,:] = uvmet(uvel.U10[itr,:,:], vvel.V10[itr,:,:],
                                  lat[0,:,:], lon[0,:,:], cen_long, cone)




aa = xr.DataArray(a, dims=('Time','lat', 'lon'), name='u10_rot')
bb = xr.DataArray(b, dims=('Time','lat', 'lon'), name='v10_rot')
aa.to_netcdf('u10_rotated.nc')
bb.to_netcdf('v10_rotated.nc')



