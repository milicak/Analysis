clear all

%rnfC1 = ncread('/bcmhsm/milicak/RUNS/runoff.daitren.clim.10FEB2011.nc','runoff');
%area1 = ncread('/bcmhsm/milicak/RUNS/runoff.daitren.clim.10FEB2011.nc','area');
%rnfC1 = ncread('/hexagon/work/shared/noresm/inputdata/lnd/dlnd7/RX1/runoff.daitren.annual.141202.nc','runoff');
rnfC1 = ncread('/hexagon/work/shared/noresm/inputdata/lnd/dlnd7/RX1/runoff.daitren.annual.090225.nc','runoff');
area1 = ncread('/hexagon/work/shared/noresm/inputdata/lnd/dlnd7/RX1/runoff.daitren.annual.090225.nc','area');

rnfC2 = ncread('/hexagon/work/shared/noresm/inputdata/lnd/dlnd7/RX1/runoff.daitren.iaf.20120419.nc','runoff');
area2 = ncread('/hexagon/work/shared/noresm/inputdata/lnd/dlnd7/RX1/runoff.daitren.iaf.20120419.nc','arear');
lon1 = ncread('/hexagon/work/shared/noresm/inputdata/lnd/dlnd7/RX1/runoff.daitren.iaf.20120419.nc','xc');
lat1 = ncread('/hexagon/work/shared/noresm/inputdata/lnd/dlnd7/RX1/runoff.daitren.iaf.20120419.nc','yc');

area1 = repmat(area1,[1 1 size(rnfC2,3)]);
area2 = repmat(area2,[1 1 size(rnfC2,3)]);
rnfC1 = repmat(rnfC1,[1 1 size(rnfC2,3)/size(rnfC1,3)]);
rnfC2=rnfC2.*area2./area1;
%rnfC1 = rnfC1(:,:,1);
%rnfC1 = repmat(rnfC1,[1 1 size(rnfC2,3)]);

maskfile = 'ansmask.nc';
%mask = double(ncread(maskfile,'ar_mask'));

l1=[-160.8939
 -172.6620
   176.1201
     138.1898
       105.9304
          74.7464
             48.6475
                39.7918
                   30.0666
                      25.9885
                         25.0499
                             9.3880
                               -37.1981
                                 -62.2561
                                  -127.2761
                                   -144.9774
                                    -152.3421
                                     -158.5458
-160.8939];

l2=[63.3333
   63.1359
      64.8997
         63.6135
            63.5112
               60.6462
                  57.5003
                     58.5191
                        63.4403
                           68.3019
                              70.1237
                                 77.6146
                                    81.1666
                                       80.0297
                                          67.2552
                                             66.5710
                                                66.0005
                                                   63.8020
63.3333];
l3 = [-160.1371 -173.5855];
l4 = [65.8516 66.0217];
l1(1:2) = l3;
l2(1:2) = l4;
l1(end) = l1(1);
l2(end) = l2(1);

in = insphpoly(lon1,lat1,l1,l2,0,90);
in = double(in);
mask = in;

mask = repmat(mask,[1 1 size(rnfC2,3)]);
rnfflx = rnfC1 +(rnfC2-rnfC1).*mask;

filename = 'runoff.daitren.annual_iaf.20120419_v2.nc';
area = area1(:,:,1);
ncwrite(filename,'runoff',rnfflx);
ncwrite(filename,'area',area);
ncwrite(filename,'arear',area);
%keyboard
