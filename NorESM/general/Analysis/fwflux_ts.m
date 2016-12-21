clear expr ph

%expr(1)=struct('name','NAER1850CNOC_f19_g16_03', ...
%               'name_disp','CMIP5', ...
%               'first_year',171, ...
%               'last_year',200, ...
%               'display_first_year',1, ...
%               'add_to_expr',[], ...
%               'color',cmu.colors('black'), ...
%               'print',0, ...
%               'grid_file','/hexagon/work/shared/noresm/inputdata/ocn/micom/gx1v6/20100629/grid.nc', ...
%               'basin_mask_file','/hexagon/work/shared/noresm/inputdata/ocn/micom/gx1v6/20100629/mertraoceans.dat', ...
%               'monthly_diagnostics',1,...
%               'path','/fimm/work/matsbn/norstore-NS2345K/noresm/cases/NAER1850CNOC_f19_g16_03/ocn/hist');
%expr(2)=struct('name','NBF1850_f19_tn11_SA_edsprs_02', ...
%               'name_disp','BCCR fast', ...
%               'first_year',171, ...
%               'last_year',200, ...
%               'display_first_year',1, ...
%               'add_to_expr',[], ...
%               'color',cmu.colors('pumpkin'), ...
%               'print',0, ...
%               'grid_file','/hexagon/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc', ...
%               'basin_mask_file','/hexagon/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/mertraoceans.dat', ...
%               'monthly_diagnostics',1,...
%               'path','/fimm/work/matsbn/norstore-NS2345K/noresm/cases/NBF1850_f19_tn11_SA_edsprs_02/ocn/hist');
%expr(3)=struct('name','N1850C5OL45OCL32_30mar2016_f19_tn11', ...
%               'name_disp','NorESM\_c1.2-LM', ...
%               'first_year',171, ...
%               'last_year',200, ...
%               'display_first_year',1, ...
%               'add_to_expr',[], ...
%               'color',cmu.colors('forest green (web)'), ...
%               'print',0, ...
%               'grid_file','/hexagon/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc', ...
%               'basin_mask_file','/hexagon/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/mertraoceans.dat', ...
%               'monthly_diagnostics',1,...
%               'path','/fimm/work/matsbn/norstore-NS2345K/noresm/cases/N1850C5OL45OCL32_30mar2016_f19_tn11/ocn/hist');
%expr(4)=struct('name','N1850C5OL45OCL32_01apr2016_f09_tn11', ...
%               'name_disp','NorESM\_c1.2-MM', ...
%               'first_year',39, ...
%               'last_year',68, ...
%               'display_first_year',1, ...
%               'add_to_expr',[], ...
%               'color',cmu.colors('red'), ...
%               'print',0, ...
%               'grid_file','/hexagon/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc', ...
%               'basin_mask_file','/hexagon/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/mertraoceans.dat', ...
%               'monthly_diagnostics',1,...
%               'path','/fimm/work/matsbn/norstore-NS2345K/noresm/cases/N1850C5OL45OCL32_01apr2016_f09_tn11/ocn/hist');
%expr(5)=struct('name','N1850C5OL45L32_f09_tn0251_T02', ...
%               'name_disp','NorESM\_c1.2-MH', ...
%               'first_year',61, ...
%               'last_year',90, ...
%               'display_first_year',1, ...
%               'add_to_expr',[], ...
%               'color',cmu.colors('blue'), ...
%               'print',0, ...
%               'grid_file','/hexagon/work/shared/noresm/inputdata/ocn/micom/tnx0.25v1/20130930/grid.nc', ...
%               'basin_mask_file','/hexagon/work/shared/noresm/inputdata/ocn/micom/tnx0.25v1/20130930/mertraoceans.dat', ...
%               'monthly_diagnostics',1,...
%               'path','/fimm/work/matsbn/norstore-NS2345K/noresm/cases/N1850C5OL45L32_f09_tn0251_T02/ocn/hist');
%%%
expr(1)=struct('name','NBF1850_f19_tn11_SA_edsprs_02', ...
               'name_disp','BCCR fast', ...
               'first_year',15, ...
               'last_year',30, ...
               'display_first_year',1, ...
               'add_to_expr',[], ...
               'color',cmu.colors('pumpkin'), ...
               'print',0, ...
               'grid_file','/hexagon/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc', ...
               'basin_mask_file','/hexagon/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/mertraoceans.dat', ...
               'monthly_diagnostics',1,...
               'path','/fimm/work/matsbn/norstore-NS2345K/noresm/cases/NBF1850_f19_tn11_SA_edsprs_02/ocn/hist');
expr(2)=struct('name','N1850C5OL45OCL32_30mar2016_f19_tn11', ...
               'name_disp','NorESM\_c1.2-LM with update\_ocn\_f=.false.', ...
               'first_year',15, ...
               'last_year',30, ...
               'display_first_year',1, ...
               'add_to_expr',[], ...
               'color',cmu.colors('forest green (web)'), ...
               'print',0, ...
               'grid_file','/hexagon/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc', ...
               'basin_mask_file','/hexagon/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/mertraoceans.dat', ...
               'monthly_diagnostics',1,...
               'path','/fimm/work/matsbn/norstore-NS2345K/noresm/cases/N1850C5OL45OCL32_30mar2016_f19_tn11/ocn/hist');
expr(3)=struct('name','N1850C5OL45OCL32_02jun2016_f19_tn11', ...
               'name_disp','NorESM\_c1.2-LM with update\_ocn\_f=.true.', ...
               'first_year',15, ...
               'last_year',30, ...
               'display_first_year',1, ...
               'add_to_expr',[], ...
               'color',cmu.colors('pumpkin'), ...
               'print',1, ...
               'grid_file','/hexagon/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc', ...
               'basin_mask_file','/hexagon/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/mertraoceans.dat', ...
               'monthly_diagnostics',1,...
               'path','/hexagon/work/matsbn/archive/N1850C5OL45OCL32_02jun2016_f19_tn11/ocn/hist');
%              'path','/fimm/work/matsbn/hexagon-work/matsbn/noresm/N1850C5OL45OCL32_02jun2016_f19_tn11/run');
%               'path','/fimm/work/matsbn/norstore-NS2345K/noresm/cases/N1850C5OL45OCL32_02jun2016_f19_tn11/ocn/hist');

%              'first_year',171, ...
%              'first_year',171, ...
%              'first_year',171, ...
%              'first_year',39, ...
%              'first_year',61, ...

% plot_mode=0: plot time series of global fresh water flux components. 
% plot_mode=1: plot time series of atlantic and arctic ocean net fresh
%              water flux.
% plot_mode=2: plot time series of atlantic, pacific and indian ocean
%              net fresh water flux.
% plot_mode=3: plot time series of atlantic, pacific and indian ocean
%              net fresh water flux between 30S and 30N.
% plot_mode=4: plot time series net global fresh water flux and frozen
%              runoff.
%              net fresh water flux between 30S and 30N.
% plot_mode=5: plot histogram of time-mean of global net fresh water
%              flux components.
% plot_mode=6: plot histogram of time-mean net fresh water in different
%              ocean basins.
% plot_mode=7: plot histogram of time-mean net fresh water flux between
%              30S and 30N in different ocean basins.
plot_mode=5;
rmwindow=5;

mw=ones(1,12)/12;
mw=[31 28 31 30 31 30 31 31 30 31 30 31]/365;
picpath='/fimm/home/nersc/matsbn/NorClim/diag/pic/';
fontsize=12;
linewidth=2.0;

legend_list=[];

for nexp=1:length(expr)

  % Load stored time series data if available
  if exist(['fwflux_ts_' expr(nexp).name '.mat'])
    load(['fwflux_ts_' expr(nexp).name '.mat'])
  else
    year_list=[];
    fwflux_global=[];
    fwflux_atl=[];
    fwflux_pac=[];
    fwflux_ind=[];
    fwflux_so=[];
    fwflux_arc=[];
    fwflux_atlarc=[];
    fwflux_atl30=[];
    fwflux_pac30=[];
    fwflux_ind30=[];
  end

  % If stored time series data is continous in time and cover the
  % requested time period, skip reading data from disk
  if isempty(year_list)||any(diff(year_list)~=1)|| ...
     year_list(1)>expr(nexp).first_year||year_list(end)<expr(nexp).last_year

    % Try to complement the time series by reading and transforming data
    % from disk
    year_missing=[];
    years_added=0;
    grid_info_read=0;
    for year=expr(nexp).first_year:expr(nexp).last_year
      cyear=sprintf('%4.4d',year);
      if isempty(find(year_list==year))
        if expr(nexp).monthly_diagnostics
          if exist([expr(nexp).path '/' expr(nexp).name '.micom.hm.' ...
                    cyear '-01.nc'])
            complete_year=1;
            disp([expr(nexp).name ' ' cyear])
            for month=1:12
              cmonth=sprintf('%2.2d',month);
              fname=[expr(nexp).path '/' expr(nexp).name '.micom.hm.' ...
                     cyear '-' cmonth '.nc'];
              if exist(fname)

                if ~grid_info_read
                  area=ncread(expr(nexp).grid_file,'parea');
                  mask=ncread(expr(nexp).grid_file,'pmask');
                  lat=ncread(expr(nexp).grid_file,'plat');
                  lon=ncread(expr(nexp).grid_file,'plon');
                  nreg=ncreadatt(expr(nexp).grid_file,'/','nreg');

                  area(find(mask==0))=nan;
                  area_sum=nansum(area(:));

                  fid=fopen(expr(nexp).basin_mask_file,'r');
                  nx=fscanf(fid,'%d',1);
                  ny=fscanf(fid,'%d',1);
                  flag=reshape(fscanf(fid,'%1d'),ny,nx)';
                  fclose(fid);

                  nz=5;

                  grid_info_read=1;
                end

                lip=ncread(fname,'lip');
                sop=ncread(fname,'sop');
                eva=ncread(fname,'eva');
                rnf=ncread(fname,'rnf');
                rfi=ncread(fname,'rfi');
                fmltfz=ncread(fname,'fmltfz');
                if nreg==2
                  lip(:,end)=nan;
                  sop(:,end)=nan;
                  eva(:,end)=nan;
                  rnf(:,end)=nan;
                  rfi(:,end)=nan;
                  fmltfz(:,end)=nan;
                end
                fwflux=zeros(nx*ny,nz);
                fwflux(:,1)=lip(:)+sop(:)+eva(:)+rnf(:)+rfi(:)+fmltfz(:);
                fwflux(:,2)=lip(:)+sop(:);
                fwflux(:,3)=eva(:);
                fwflux(:,4)=rnf(:)+rfi(:);
                fwflux(:,5)=fmltfz(:);

                area_nz=area(:)*ones(1,nz);
                fwflux_global_tmp(:,month)=nansum(fwflux.*area_nz);

                area_tmp=area;
                area_tmp(find(flag~=2))=nan;
                area_nz=area_tmp(:)*ones(1,nz);
                fwflux_atl_tmp(:,month)=nansum(fwflux.*area_nz);

                area_tmp=area;
                area_tmp(find(flag~=3))=nan;
                area_nz=area_tmp(:)*ones(1,nz);
                fwflux_pac_tmp(:,month)=nansum(fwflux.*area_nz);

                area_tmp=area;
                area_tmp(find(flag~=4))=nan;
                area_nz=area_tmp(:)*ones(1,nz);
                fwflux_ind_tmp(:,month)=nansum(fwflux.*area_nz);

                area_tmp=area;
                area_tmp(find(flag~=1|lat>-30))=nan;
                area_nz=area_tmp(:)*ones(1,nz);
                fwflux_so_tmp(:,month)=nansum(fwflux.*area_nz);

                area_tmp=area;
                area_tmp(find(flag~=1|lat<60))=nan;
                area_nz=area_tmp(:)*ones(1,nz);
                fwflux_arc_tmp(:,month)=nansum(fwflux.*area_nz);

                area_tmp=area;
                area_tmp(find((flag~=2|lat<-30)&(flag~=1|lat<60)))=nan;
                area_nz=area_tmp(:)*ones(1,nz);
                fwflux_atlarc_tmp(:,month)=nansum(fwflux.*area_nz);

                area_tmp=area;
                area_tmp(find(flag~=2|abs(lat)>30))=nan;
                area_nz=area_tmp(:)*ones(1,nz);
                fwflux_atl30_tmp(:,month)=nansum(fwflux.*area_nz);

                area_tmp=area;
                area_tmp(find(flag~=3|abs(lat)>30))=nan;
                area_nz=area_tmp(:)*ones(1,nz);
                fwflux_pac30_tmp(:,month)=nansum(fwflux.*area_nz);

                area_tmp=area;
                area_tmp(find(flag~=4|abs(lat)>30))=nan;
                area_nz=area_tmp(:)*ones(1,nz);
                fwflux_ind30_tmp(:,month)=nansum(fwflux.*area_nz);

              else
                complete_year=0;
                break
              end
            end
            if complete_year
              years_added=1;
              year_list(end+1)=year;
              fwflux_global=[fwflux_global fwflux_global_tmp];
              fwflux_atl=[fwflux_atl fwflux_atl_tmp];
              fwflux_pac=[fwflux_pac fwflux_pac_tmp];
              fwflux_ind=[fwflux_ind fwflux_ind_tmp];
              fwflux_so=[fwflux_so fwflux_so_tmp];
              fwflux_arc=[fwflux_arc fwflux_arc_tmp];
              fwflux_atlarc=[fwflux_atlarc fwflux_atlarc_tmp];
              fwflux_atl30=[fwflux_atl30 fwflux_atl30_tmp];
              fwflux_pac30=[fwflux_pac30 fwflux_pac30_tmp];
              fwflux_ind30=[fwflux_ind30 fwflux_ind30_tmp];
            else
              year_missing=[year_missing year];
            end
          else
            year_missing=[year_missing year];
          end
        else
          fname=[expr(nexp).path '/' expr(nexp).name '.micom.hy.' ...
                 cyear '.nc'];
          if exist(fname)
            disp([expr(nexp).name ' ' cyear])

            if ~grid_info_read
              area=ncread(expr(nexp).grid_file,'parea');
              mask=ncread(expr(nexp).grid_file,'pmask');
              lat=ncread(expr(nexp).grid_file,'plat');
              lon=ncread(expr(nexp).grid_file,'plon');
              nreg=ncreadatt(expr(nexp).grid_file,'/','nreg');

              area(find(mask==0))=nan;
              area_sum=nansum(area(:));

              fid=fopen(expr(nexp).basin_mask_file,'r');
              nx=fscanf(fid,'%d',1);
              ny=fscanf(fid,'%d',1);
              flag=reshape(fscanf(fid,'%1d'),ny,nx)';
              fclose(fid);

              nz=5;

              grid_info_read=1;
            end

            lip=ncread(fname,'lip');
            sop=ncread(fname,'sop');
            eva=ncread(fname,'eva');
            rnf=ncread(fname,'rnf');
            rfi=ncread(fname,'rfi');
            fmltfz=ncread(fname,'fmltfz');
            if nreg==2
              lip(:,end)=nan;
              sop(:,end)=nan;
              eva(:,end)=nan;
              rnf(:,end)=nan;
              rfi(:,end)=nan;
              fmltfz(:,end)=nan;
            end
            fwflux=zeros(nx*ny,nz);
            fwflux(:,1)=lip(:)+sop(:)+eva(:)+rnf(:)+rfi(:)+fmltfz(:);
            fwflux(:,2)=lip(:)+sop(:);
            fwflux(:,3)=eva(:);
            fwflux(:,4)=rnf(:)+rfi(:);
            fwflux(:,5)=fmltfz(:);

            area_nz=area(:)*ones(1,nz);
            fwflux_global_tmp=nansum(fwflux.*area_nz);

            area_tmp=area;
            area_tmp(find(flag~=2))=nan;
            area_nz=area_tmp(:)*ones(1,nz);
            fwflux_atl_tmp=nansum(fwflux.*area_nz);

            area_tmp=area;
            area_tmp(find(flag~=3))=nan;
            area_nz=area_tmp(:)*ones(1,nz);
            fwflux_pac_tmp=nansum(fwflux.*area_nz);

            area_tmp=area;
            area_tmp(find(flag~=4))=nan;
            area_nz=area_tmp(:)*ones(1,nz);
            fwflux_ind_tmp=nansum(fwflux.*area_nz);

            area_tmp=area;
            area_tmp(find(flag~=1|lat>-30))=nan;
            area_nz=area_tmp(:)*ones(1,nz);
            fwflux_so_tmp=nansum(fwflux.*area_nz);

            area_tmp=area;
            area_tmp(find(flag~=1|lat<60))=nan;
            area_nz=area_tmp(:)*ones(1,nz);
            fwflux_arc_tmp=nansum(fwflux.*area_nz);

            area_tmp=area;
            area_tmp(find((flag~=2|lat<-30)&(flag~=1|lat<60)))=nan;
            area_nz=area_tmp(:)*ones(1,nz);
            fwflux_atlarc_tmp=nansum(fwflux.*area_nz);

            area_tmp=area;
            area_tmp(find(flag~=2|abs(lat)>30))=nan;
            area_nz=area_tmp(:)*ones(1,nz);
            fwflux_atl30_tmp=nansum(fwflux.*area_nz);

            area_tmp=area;
            area_tmp(find(flag~=3|abs(lat)>30))=nan;
            area_nz=area_tmp(:)*ones(1,nz);
            fwflux_pac30_tmp=nansum(fwflux.*area_nz);

            area_tmp=area;
            area_tmp(find(flag~=4|abs(lat)>30))=nan;
            area_nz=area_tmp(:)*ones(1,nz);
            fwflux_ind30_tmp=nansum(fwflux.*area_nz);

            fwflux_global_tmp=fwflux_global_tmp*ones(1,12);
            fwflux_atl_tmp=fwflux_atl_tmp*ones(1,12);
            fwflux_pac_tmp=fwflux_pac_tmp*ones(1,12);
            fwflux_ind_tmp=fwflux_ind_tmp*ones(1,12);
            fwflux_so_tmp=fwflux_so_tmp*ones(1,12);
            fwflux_arc_tmp=fwflux_arc_tmp*ones(1,12);
            fwflux_atlarc_tmp=fwflux_atlarc_tmp*ones(1,12);
            fwflux_atl30_tmp=fwflux_atl30_tmp*ones(1,12);
            fwflux_pac30_tmp=fwflux_pac30_tmp*ones(1,12);
            fwflux_ind30_tmp=fwflux_ind30_tmp*ones(1,12);

            years_added=1;
            year_list(end+1)=year;
            fwflux_global=[fwflux_global fwflux_global_tmp];
            fwflux_atl=[fwflux_atl fwflux_atl_tmp];
            fwflux_pac=[fwflux_pac fwflux_pac_tmp];
            fwflux_ind=[fwflux_ind fwflux_ind_tmp];
            fwflux_so=[fwflux_so fwflux_so_tmp];
            fwflux_arc=[fwflux_arc fwflux_arc_tmp];
            fwflux_atlarc=[fwflux_atlarc fwflux_atlarc_tmp];
            fwflux_atl30=[fwflux_atl30 fwflux_atl30_tmp];
            fwflux_pac30=[fwflux_pac30 fwflux_pac30_tmp];
            fwflux_ind30=[fwflux_ind30 fwflux_ind30_tmp];
          else
            year_missing=[year_missing year];
          end
        end
      end
    end

    if ~isempty(year_missing)
      disp([expr(nexp).name ': Could not find data for the years: ' ...
           num2str(year_missing)])
    end

    % If the time series has been extended, sort the series and store
    % the updated time series
    if years_added
      [year_list svind]=sort(year_list);
      smind=(ones(nz*12,1)*(svind-1)*nz*12)+(1:nz*12)'*ones(1,length(svind));
      fwflux_global=reshape(fwflux_global(smind),nz,[]);
      fwflux_atl=reshape(fwflux_atl(smind),nz,[]);
      fwflux_pac=reshape(fwflux_pac(smind),nz,[]);
      fwflux_ind=reshape(fwflux_ind(smind),nz,[]);
      fwflux_so=reshape(fwflux_so(smind),nz,[]);
      fwflux_arc=reshape(fwflux_arc(smind),nz,[]);
      fwflux_atlarc=reshape(fwflux_atlarc(smind),nz,[]);
      fwflux_atl30=reshape(fwflux_atl30(smind),nz,[]);
      fwflux_pac30=reshape(fwflux_pac30(smind),nz,[]);
      fwflux_ind30=reshape(fwflux_ind30(smind),nz,[]);
      save(['fwflux_ts_' expr(nexp).name '.mat'], ...
            'year_list','fwflux_global','fwflux_atl','fwflux_pac', ...
            'fwflux_ind','fwflux_so','fwflux_arc','fwflux_atlarc', ...
            'fwflux_atl30','fwflux_pac30','fwflux_ind30')
    end

  end

  expr(nexp).year_list=year_list;
  expr(nexp).fwflux_global=fwflux_global;
  expr(nexp).fwflux_atl=fwflux_atl;
  expr(nexp).fwflux_pac=fwflux_pac;
  expr(nexp).fwflux_ind=fwflux_ind;
  expr(nexp).fwflux_so=fwflux_so;
  expr(nexp).fwflux_arc=fwflux_arc;
  expr(nexp).fwflux_atlarc=fwflux_atlarc;
  expr(nexp).fwflux_atl30=fwflux_atl30;
  expr(nexp).fwflux_pac30=fwflux_pac30;
  expr(nexp).fwflux_ind30=fwflux_ind30;
  if ~isempty(expr(nexp).name_disp)&&isempty(expr(nexp).add_to_expr)
    legend_list(end+1)=nexp;
  end

end

% Combine time series if requested
for nexp=1:length(expr)
  nexpa=expr(nexp).add_to_expr;
  if ~isempty(nexpa) && ~isempty(expr(nexpa).year_list)
    year_list=expr(nexpa).year_list;
    fwflux_global=expr(nexpa).fwflux_global;
    fwflux_atl=expr(nexpa).fwflux_atl;
    fwflux_pac=expr(nexpa).fwflux_pac;
    fwflux_ind=expr(nexpa).fwflux_ind;
    fwflux_so=expr(nexpa).fwflux_so;
    fwflux_arc=expr(nexpa).fwflux_arc;
    fwflux_atlarc=expr(nexpa).fwflux_atlarc;
    fwflux_atl30=expr(nexpa).fwflux_atl30;
    fwflux_pac30=expr(nexpa).fwflux_pac30;
    fwflux_ind30=expr(nexpa).fwflux_ind30;
    ind=find(year_list>expr(nexpa).last_year,1,'first');
    if isempty(ind)
      year_list=[year_list expr(nexp).year_list];
      fwflux_global=[fwflux_global expr(nexp).fwflux_global];
      fwflux_atl=[fwflux_atl expr(nexp).fwflux_atl];
      fwflux_pac=[fwflux_pac expr(nexp).fwflux_pac];
      fwflux_ind=[fwflux_ind expr(nexp).fwflux_ind];
      fwflux_so=[fwflux_so expr(nexp).fwflux_so];
      fwflux_arc=[fwflux_arc expr(nexp).fwflux_arc];
      fwflux_atlarc=[fwflux_atlarc expr(nexp).fwflux_atlarc];
      fwflux_atl30=[fwflux_atl30 expr(nexp).fwflux_atl30];
      fwflux_pac30=[fwflux_pac30 expr(nexp).fwflux_pac30];
      fwflux_ind30=[fwflux_ind30 expr(nexp).fwflux_ind30];
    else
      year_list=[year_list(1:ind-1) expr(nexp).year_list];
      fwflux_global=[fwflux_global(1:(ind-1)*12) expr(nexp).fwflux_global];
      fwflux_atl=[fwflux_atl(1:(ind-1)*12) expr(nexp).fwflux_atl];
      fwflux_pac=[fwflux_pac(1:(ind-1)*12) expr(nexp).fwflux_pac];
      fwflux_ind=[fwflux_ind(1:(ind-1)*12) expr(nexp).fwflux_ind];
      fwflux_so=[fwflux_so(1:(ind-1)*12) expr(nexp).fwflux_so];
      fwflux_arc=[fwflux_arc(1:(ind-1)*12) expr(nexp).fwflux_arc];
      fwflux_atlarc=[fwflux_atlarc(1:(ind-1)*12) expr(nexp).fwflux_atlarc];
      fwflux_atl30=[fwflux_atl30(1:(ind-1)*12) expr(nexp).fwflux_atl30];
      fwflux_pac30=[fwflux_pac30(1:(ind-1)*12) expr(nexp).fwflux_pac30];
      fwflux_ind30=[fwflux_ind30(1:(ind-1)*12) expr(nexp).fwflux_ind30];
    end
    [year_list svind]=sort(year_list);
    nz=size(fwflux_global,1);
    smind=(ones(nz*12,1)*(svind-1)*nz*12)+(1:nz*12)'*ones(1,length(svind));
    fwflux_global=reshape(fwflux_global(smind),nz,[]);
    fwflux_atl=reshape(fwflux_atl(smind),nz,[]);
    fwflux_pac=reshape(fwflux_pac(smind),nz,[]);
    fwflux_ind=reshape(fwflux_ind(smind),nz,[]);
    fwflux_so=reshape(fwflux_so(smind),nz,[]);
    fwflux_arc=reshape(fwflux_arc(smind),nz,[]);
    fwflux_atlarc=reshape(fwflux_atlarc(smind),nz,[]);
    fwflux_atl30=reshape(fwflux_atl30(smind),nz,[]);
    fwflux_pac30=reshape(fwflux_pac30(smind),nz,[]);
    fwflux_ind30=reshape(fwflux_ind30(smind),nz,[]);
    expr(nexpa).year_list=year_list;
    expr(nexpa).fwflux_global=fwflux_global;
    expr(nexpa).fwflux_atl=fwflux_atl;
    expr(nexpa).fwflux_pac=fwflux_pac;
    expr(nexpa).fwflux_ind=fwflux_ind;
    expr(nexpa).fwflux_so=fwflux_so;
    expr(nexpa).fwflux_arc=fwflux_arc;
    expr(nexpa).fwflux_atlarc=fwflux_atlarc;
    expr(nexpa).fwflux_atl30=fwflux_atl30;
    expr(nexpa).fwflux_pac30=fwflux_pac30;
    expr(nexpa).fwflux_ind30=fwflux_ind30;
    expr(nexpa).first_year=min(expr(nexpa).first_year,expr(nexp).first_year);
    expr(nexpa).last_year=max(expr(nexpa).last_year,expr(nexp).last_year);
  end
end


% Plot the time series

%figure('visible','off')
clf
hold on

fwflux_global_mean=[];
fwflux_atl_mean=[];
fwflux_pac_mean=[];
fwflux_ind_mean=[];
fwflux_so_mean=[];
fwflux_arc_mean=[];
fwflux_atlarc_mean=[];
fwflux_atl30_mean=[];
fwflux_pac30_mean=[];
fwflux_ind30_mean=[];

for nexp=1:length(expr)
  if isempty(expr(nexp).add_to_expr)
    year_list=expr(nexp).year_list;
    fwflux_global=expr(nexp).fwflux_global;
    fwflux_atl=expr(nexp).fwflux_atl;
    fwflux_pac=expr(nexp).fwflux_pac;
    fwflux_ind=expr(nexp).fwflux_ind;
    fwflux_so=expr(nexp).fwflux_so;
    fwflux_arc=expr(nexp).fwflux_arc;
    fwflux_atlarc=expr(nexp).fwflux_atlarc;
    fwflux_atl30=expr(nexp).fwflux_atl30;
    fwflux_pac30=expr(nexp).fwflux_pac30;
    fwflux_ind30=expr(nexp).fwflux_ind30;

    fwflux_global_yr=reshape(mw*reshape(fwflux_global',12,[]),[], ...
                             size(fwflux_global,1))';
    fwflux_atl_yr=reshape(mw*reshape(fwflux_atl',12,[]),[], ...
                          size(fwflux_atl,1))';
    fwflux_pac_yr=reshape(mw*reshape(fwflux_pac',12,[]),[], ...
                          size(fwflux_pac,1))';
    fwflux_ind_yr=reshape(mw*reshape(fwflux_ind',12,[]),[], ...
                          size(fwflux_ind,1))';
    fwflux_so_yr=reshape(mw*reshape(fwflux_so',12,[]),[], ...
                         size(fwflux_so,1))';
    fwflux_arc_yr=reshape(mw*reshape(fwflux_arc',12,[]),[], ...
                          size(fwflux_arc,1))';
    fwflux_atlarc_yr=reshape(mw*reshape(fwflux_atlarc',12,[]),[], ...
                             size(fwflux_atlarc,1))';
    fwflux_atl30_yr=reshape(mw*reshape(fwflux_atl30',12,[]),[], ...
                            size(fwflux_atl30,1))';
    fwflux_pac30_yr=reshape(mw*reshape(fwflux_pac30',12,[]),[], ...
                            size(fwflux_pac30,1))';
    fwflux_ind30_yr=reshape(mw*reshape(fwflux_ind30',12,[]),[], ...
                            size(fwflux_ind30,1))';

    iyf=find(year_list>=expr(nexp).first_year,1);
    iyl=find(year_list<=expr(nexp).last_year,1,'last');
    fwflux_global_mean(nexp,:)=mean(fwflux_global_yr(:,iyf:iyl)');
    fwflux_atl_mean(nexp,:)=mean(fwflux_atl_yr(:,iyf:iyl)');
    fwflux_pac_mean(nexp,:)=mean(fwflux_pac_yr(:,iyf:iyl)');
    fwflux_ind_mean(nexp,:)=mean(fwflux_ind_yr(:,iyf:iyl)');
    fwflux_so_mean(nexp,:)=mean(fwflux_so_yr(:,iyf:iyl)');
    fwflux_arc_mean(nexp,:)=mean(fwflux_arc_yr(:,iyf:iyl)');
    fwflux_atlarc_mean(nexp,:)=mean(fwflux_atlarc_yr(:,iyf:iyl)');
    fwflux_atl30_mean(nexp,:)=mean(fwflux_atl30_yr(:,iyf:iyl)');
    fwflux_pac30_mean(nexp,:)=mean(fwflux_pac30_yr(:,iyf:iyl)');
    fwflux_ind30_mean(nexp,:)=mean(fwflux_ind30_yr(:,iyf:iyl)');

    if rmwindow>0
      fwflux_global_yr=rm(fwflux_global_yr',rmwindow)';
      fwflux_atl_yr=rm(fwflux_atl_yr',rmwindow)';
      fwflux_pac_yr=rm(fwflux_pac_yr',rmwindow)';
      fwflux_ind_yr=rm(fwflux_ind_yr',rmwindow)';
      fwflux_so_yr=rm(fwflux_so_yr',rmwindow)';
      fwflux_arc_yr=rm(fwflux_arc_yr',rmwindow)';
      fwflux_atlarc_yr=rm(fwflux_atlarc_yr',rmwindow)';
      fwflux_atl30_yr=rm(fwflux_atl30_yr',rmwindow)';
      fwflux_pac30_yr=rm(fwflux_pac30_yr',rmwindow)';
      fwflux_ind30_yr=rm(fwflux_ind30_yr',rmwindow)';
    end

    year_list=year_list(iyf:iyl);
    fwflux_global_yr=fwflux_global_yr(:,iyf:iyl);
    fwflux_atl_yr=fwflux_atl_yr(:,iyf:iyl);
    fwflux_pac_yr=fwflux_pac_yr(:,iyf:iyl);
    fwflux_ind_yr=fwflux_ind_yr(:,iyf:iyl);
    fwflux_so_yr=fwflux_so_yr(:,iyf:iyl);
    fwflux_arc_yr=fwflux_arc_yr(:,iyf:iyl);
    fwflux_atlarc_yr=fwflux_atlarc_yr(:,iyf:iyl);
    fwflux_atl30_yr=fwflux_atl30_yr(:,iyf:iyl);
    fwflux_pac30_yr=fwflux_pac30_yr(:,iyf:iyl);
    fwflux_ind30_yr=fwflux_ind30_yr(:,iyf:iyl);
    year_discont=[diff(year_list)~=1 1];
    iyl=0;
    while iyl<length(year_list)
      iyf=iyl+1;
      iyl=iyl+find(year_discont(iyf:end)==1,1);
      time=expr(nexp).display_first_year-expr(nexp).first_year+ ...
           year_list(iyf:iyl);
      if     plot_mode==0
        ph(nexp)=plot(time,fwflux_global_yr(1,iyf:iyl)*1e-9, ...
                      '-','LineWidth',linewidth,'Color','k');
                 plot(time,fwflux_global_yr(2,iyf:iyl)*1e-9, ...
                      '-','LineWidth',linewidth,'Color','b');
                 plot(time,fwflux_global_yr(3,iyf:iyl)*1e-9, ...
                      '-','LineWidth',linewidth,'Color','r');
                 plot(time,fwflux_global_yr(4,iyf:iyl)*1e-9, ...
                      '-','LineWidth',linewidth,'Color','g');

                 plot(time,fwflux_global_yr(5,iyf:iyl)*1e-9, ...
                      '-','LineWidth',linewidth,'Color','c');
                 plot(time,(fwflux_atl_yr(1,iyf:iyl) ...
                           +fwflux_pac_yr(1,iyf:iyl) ...
                           +fwflux_ind_yr(1,iyf:iyl) ...
                           +fwflux_so_yr(1,iyf:iyl) ...
                           +fwflux_arc_yr(1,iyf:iyl))*1e-9, ...
                      '-','LineWidth',linewidth,'Color','m');
      elseif plot_mode==1
        ph(nexp)=plot(time,fwflux_atlarc_yr(1,iyf:iyl)*1e-9, ...
                      '-','LineWidth',linewidth,'Color',expr(nexp).color);
      elseif plot_mode==2
        ph(nexp)=plot(time,fwflux_atl_yr(1,iyf:iyl)*1e-9, ...
                      '-','LineWidth',linewidth,'Color',expr(nexp).color);
                 plot(time,fwflux_pac_yr(1,iyf:iyl)*1e-9, ...
                      '--','LineWidth',linewidth,'Color',expr(nexp).color);
                 plot(time,fwflux_ind_yr(1,iyf:iyl)*1e-9, ...
                      '-.','LineWidth',linewidth,'Color',expr(nexp).color);
      elseif plot_mode==3
        ph(nexp)=plot(time,fwflux_atl30_yr(1,iyf:iyl)*1e-9, ...
                      '-','LineWidth',linewidth,'Color',expr(nexp).color);
                 plot(time,fwflux_pac30_yr(1,iyf:iyl)*1e-9, ...
                      '--','LineWidth',linewidth,'Color',expr(nexp).color);
                 plot(time,fwflux_ind30_yr(1,iyf:iyl)*1e-9, ...
                      '-.','LineWidth',linewidth,'Color',expr(nexp).color);
      elseif plot_mode==4
        ph(nexp)=plot(time,fwflux_global_yr(1,iyf:iyl)*1e-9, ...
                      '-','LineWidth',linewidth,'Color',expr(nexp).color);
                 plot(time,fwflux_global_yr(5,iyf:iyl)*1e-9, ...
                      '--','LineWidth',linewidth,'Color',expr(nexp).color);
      end 
    end

  end
end

if plot_mode<5
  if ~isempty(legend_list)
    h=legend(ph(legend_list),expr(legend_list).name_disp,'location','Best');
    set(h,'FontSize',fontsize)
    legend boxoff
  end
  set(gca,'FontSize',fontsize) 
  xlabel('year','FontSize',fontsize) 
  ylabel('Sv','FontSize',fontsize) 
  title('Fresh water flux','FontSize',fontsize) 
end

if     plot_mode==5
  bar(fwflux_global_mean'*1e-9)
% h=legend(expr(legend_list).name_disp,'location','Best');
  h=legend(expr(legend_list).name_disp);
  set(h,'FontSize',fontsize)
  legend boxoff
  set(gca,'FontSize',fontsize) 
  ylabel('Sv','FontSize',fontsize) 
  set(gca,'XTick',1:5,'XTickLabel', ...
      {'net','precip','evap','liq runoff','frz runoff'})
  title('Time-mean fresh water flux components into the global ocean', ...
        'FontSize',fontsize) 
elseif plot_mode==6
  bar([fwflux_atl_mean(:,1) fwflux_pac_mean(:,1) fwflux_ind_mean(:,1) ...
       fwflux_so_mean(:,1) fwflux_arc_mean(:,1)]'*1e-9)
  h=legend(expr(legend_list).name_disp,'location','Best');
  set(h,'FontSize',fontsize)
  legend boxoff
  set(gca,'FontSize',fontsize) 
  ylabel('Sv','FontSize',fontsize) 
  set(gca,'XTick',1:5,'XTickLabel', ...
      {'Atlantic','Pacific','Indian','Southern','Arctic'})
  title('Time-mean net fresh water flux into ocean basins', ...
        'FontSize',fontsize) 
elseif plot_mode==7
  bar([fwflux_atl30_mean(:,1) fwflux_pac30_mean(:,1) ...
       fwflux_ind30_mean(:,1)]'*1e-9)
  h=legend(expr(legend_list).name_disp,'location','Best');
  set(h,'FontSize',fontsize)
  legend boxoff
  set(gca,'FontSize',fontsize) 
  ylabel('Sv','FontSize',fontsize) 
  set(gca,'XTick',1:3,'XTickLabel', ...
      {'Atlantic','Pacific','Indian'})
  title('Time-mean net fresh water flux into ocean basins between 30^\circS and 30^\circN','FontSize',fontsize) 
end

grid on
box on
%axis tight


% Print the time series

for nexp=length(expr):-1:1
  if expr(nexp).print
    if ~exist([picpath '/' expr(nexp).name])
      mkdir([picpath '/' expr(nexp).name])
    end
    print (gcf,'-dpng', '-r300', [picpath '/' expr(nexp).name '/fwflux_' ...
                                  num2str(plot_mode) '.png'])
    break
  end
end
