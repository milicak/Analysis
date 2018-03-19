clear all

load color_15.mat
lw = 2; % linewidth

rootname = 'data/';

expid = {'NorESM' 'ITU-MOM'};

filename = {'NorESM_GS_experiments.nc' 'ITU-MOM_GSexps.nc'};

Beringvarctl = {'vt_NorESM_Bering_ctrl' 'ctlbering_volumetotal'};
Beringvargsp = {'vt_NorESM_Bering_gsp' 'gspbering_volumetotal'};
Beringvargsn = {'vt_NorESM_Bering_gsn' 'gsnbering_volumetotal'};

Framvarctl = {'vt_NorESM_FS_ctrl' 'ctlfram_volumetotal'};
Framvargsp = {'vt_NorESM_FS_gsp' 'gspfram_volumetotal'};
Framvargsn = {'vt_NorESM_FS_gsn' 'gsnfram_volumetotal'};

Barentsvarctl = {'vt_NorESM_BSO_ctrl' 'ctlbarents_volumetotal'};
Barentsvargsp = {'vt_NorESM_BSO_gsp' 'gspbarents_volumetotal'};
Barentsvargsn = {'vt_NorESM_BSO_gsn' 'gsnbarents_volumetotal'};

Davisvarctl = {'vt_NorESM_Davis_ctrl' 'gsndavis_volumetotal'};
Davisvargsp = {'vt_NorESM_Davis_gsp' 'gspdavis_volumetotal'};
Davisvargsn = {'vt_NorESM_Davis_gsn' 'gsndavis_volumetotal'};

%timevar = {''};
%
i = 1;
fname = [rootname char(expid(i)) '/' char(filename(i))];
var1 = ncread(fname,char(Beringvarctl(i)));
var1 = var1(:);
var2 = ncread(fname,char(Framvarctl(i)));
var2 = var2(:);
var3 = ncread(fname,char(Barentsvarctl(i)));
var3 = var3(:);
var4 = ncread(fname,char(Davisvarctl(i)));
var4 = var4(:);

figure
clf
hold on
k=1;
plot(var1,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
k=2;
plot(var2,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
k=3;
plot(var3,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
k=4;
plot(var4,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
