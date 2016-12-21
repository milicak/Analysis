clear expr

%%%
%expr(1)=struct('name','NOINY_nosalrlx', ...
%               'first_year',1, ...
%               'last_year',300, ...
%               'display_first_year',1, ...
%               'color','b', ...
%               'print',1, ...
%               'secindex_file','/work/shared/noresm/inputdata/ocn/micom/gx1v6/20101119/secindex.dat', ...
%               'path','/work/matsbn/archive/NOINY_nosalrlx/ice/hist');
%expr(1)=struct('name','NOINY_salrlx', ...
%               'first_year',1, ...
%               'last_year',300, ...
%               'display_first_year',1, ...
%               'color','b', ...
%               'print',1, ...
%               'secindex_file','/work/shared/noresm/inputdata/ocn/micom/gx1v6/20101119/secindex.dat', ...
%               'path','/work/matsbn/archive/NOINY_salrlx/ice/hist');
%expr(1)=struct('name','NAER1850CNOC_f19_g16_03', ...
%               'first_year',1, ...
%               'last_year',300, ...
%               'display_first_year',1, ...
%               'color','b', ...
%               'print',1, ...
%               'secindex_file','/work/shared/noresm/inputdata/ocn/micom/gx1v6/20101119/secindex.dat', ...
%               'path','/work/matsbn/archive/NAER1850CNOC_f19_g16_03/ice/hist');
%expr(1)=struct('name','NOINYC_mls', ...
%               'first_year',1, ...
%               'last_year',600, ...
%               'display_first_year',1, ...
%               'color','b', ...
%               'print',1, ...
%               'secindex_file','/work/shared/noresm/inputdata/ocn/micom/gx1v6/20101119/secindex.dat', ...
%               'path','/work/bernard/archive/NOINYC_mls/ice/hist');
%%%
expr(1)=struct('name','NAER1850CNOC_f19_g16_06', ...
               'first_year',700, ...
               'last_year',1150, ...
               'display_first_year',1850, ...
               'color','b', ...
               'print',0, ...
               'secindex_file','/work/shared/noresm/inputdata/ocn/micom/gx1v6/20101119/secindex.dat', ...
               'path','/work/matsbn/archive/NAER1850CNOC_f19_g16_06/ice/hist');
expr(2)=struct('name','N20TRAERCN_f19_g16_01', ...
               'first_year',1850, ...
               'last_year',2010, ...
               'display_first_year',1850, ...
               'color','r', ...
               'print',1, ...
               'secindex_file','/work/shared/noresm/inputdata/ocn/micom/gx1v6/20101119/secindex.dat', ...
               'path','/work/matsbn/archive/N20TRAERCN_f19_g16_01/ice/hist');

picpath='/home/nersc/matsbn/NorClim/diag/pic/';
rhoice=917;

for nexp=1:length(expr)

  % Load stored time series data if available
  if exist(['icetr_ts_' expr(nexp).name '.mat'])
    load(['icetr_ts_' expr(nexp).name '.mat'])
  else
    year_list=[];
    icetr=[];
    section=[];
  end

  % If stored time series data is continous in time and cover the
  % requested time period, skip reading data from disk
  if isempty(year_list)||any(diff(year_list)~=1)|| ...
     year_list(1)>expr(nexp).first_year||year_list(end)<expr(nexp).last_year

    % Try to complement the time series by reading and transforming data
    % from disk
    year_missing=[];
    years_added=0;
    sec_info_read=0;
    for year=expr(nexp).first_year:expr(nexp).last_year
      cyear=sprintf('%4.4d',year);
      if isempty(find(year_list==year))
        if exist([expr(nexp).path '/' expr(nexp).name '.cice.h.' ...
                  cyear '-01.nc'])
          complete_year=1;
          disp([expr(nexp).name ' ' cyear])
          for month=1:12
            cmonth=sprintf('%2.2d',month);
            fname=[expr(nexp).path '/' expr(nexp).name '.cice.h.' ...
                   cyear '-' cmonth '.nc'];
            if exist(fname)

              if ~sec_info_read
                fid=fopen(expr(nexp).secindex_file,'r');
                sec_num=0;
                while 1
                  line=fgetl(fid);
                  if ~isstr(line)
                    break
                  end
                  if strcmp(line(1:5),'Name:')
                    sec_num=sec_num+1;
                    section(sec_num,1:length(line(7:end)))=line(7:end);
                    sec_len(sec_num)=0;
                  else
                    sec_len(sec_num)=sec_len(sec_num)+1;
                    sec_i(sec_num,sec_len(sec_num))=str2num(line(1:3));
                    sec_j(sec_num,sec_len(sec_num))=str2num(line(5:7));
                    sec_u_flag(sec_num,sec_len(sec_num))=str2num(line(9:10));
                    sec_v_flag(sec_num,sec_len(sec_num))=str2num(line(12:13));
                  end
                end
                fclose(fid);
                section=char(section);
                sec_info_read=1;
              end

              ncid=netcdf.open(fname,'NC_NOWRITE');
              varid=netcdf.inqVarID(ncid,'transix');
              transix=netcdf.getVar(ncid,varid);
              varid=netcdf.inqVarID(ncid,'transiy');
              transiy=netcdf.getVar(ncid,varid);
              netcdf.close(ncid)

              for s=1:sec_num
                icetr_tmp(s,month)=0;
                for n=1:sec_len(s)
                  icetr_tmp(s,month)=icetr_tmp(s,month) ...
                   +transix(sec_i(s,n)-1,sec_j(s,n)  )*sec_u_flag(s,n) ...
                   +transiy(sec_i(s,n)  ,sec_j(s,n)-1)*sec_v_flag(s,n);
                end
              end

            else
              complete_year=0;
              break
            end
          end
          if complete_year
            years_added=1;
            year_list(end+1)=year;
            icetr=[icetr icetr_tmp];
          else
            year_missing=[year_missing year];
          end
        else
          year_missing=[year_missing year];
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
      nz=size(icetr,1);
      smind=(ones(nz*12,1)*(svind-1)*nz*12)+(1:nz*12)'*ones(1,length(svind));
      icetr=reshape(icetr(smind),nz,[]);
      save(['icetr_ts_' expr(nexp).name '.mat'], ...
           'year_list','icetr','section')
    end

  end

  expr(nexp).year_list=year_list;
  expr(nexp).icetr=icetr;
  expr(nexp).section=section;
  expr(nexp).name_disp=str_name_disp(expr(nexp).name);

end

% Plot Fram Strait time series

%figure('visible','off')
clf

for nexp=1:length(expr)
  year_list=expr(nexp).year_list;

  icetr_fs_yr=-mon2ann(expr(nexp).icetr(10,:))/rhoice*1e-9*86400*365;
  icetr_ds_yr=-mon2ann(expr(nexp).icetr(4,:))/rhoice*1e-9*86400*365;
  icetr_bs_yr=-mon2ann(expr(nexp).icetr(2,:))/rhoice*1e-9*86400*365;
  icetr_ca_yr=-mon2ann(expr(nexp).icetr(3,:))/rhoice*1e-9*86400*365;

  iyf=find(year_list>=expr(nexp).first_year,1);
  iyl=find(year_list<=expr(nexp).last_year,1,'last');
  year_list=year_list(iyf:iyl);
  icetr_fs_yr=icetr_fs_yr(iyf:iyl);
  icetr_ds_yr=icetr_ds_yr(iyf:iyl);
  icetr_bs_yr=icetr_bs_yr(iyf:iyl);
  icetr_ca_yr=icetr_ca_yr(iyf:iyl);
  year_discont=[diff(year_list)~=1 1];
  iyl=0;
  while iyl<length(year_list)
    iyf=iyl+1;
    iyl=iyl+find(year_discont(iyf:end)==1,1);
    time=expr(nexp).display_first_year-expr(nexp).first_year+ ...
         year_list(iyf:iyl);
    subplot(2,2,1)
    hold on
    ph(nexp)=plot(time,icetr_fs_yr(iyf:iyl), ...
                  '-','LineWidth',1,'Color',expr(nexp).color);
    subplot(2,2,2)
    hold on
    plot(time,icetr_ds_yr(iyf:iyl), ...
         '-','LineWidth',1,'Color',expr(nexp).color);
    subplot(2,2,3)
    hold on
    plot(time,icetr_bs_yr(iyf:iyl), ...
         '-','LineWidth',1,'Color',expr(nexp).color);
    subplot(2,2,4)
    hold on
    plot(time,icetr_ca_yr(iyf:iyl), ...
         '-','LineWidth',1,'Color',expr(nexp).color);
  end
end

subplot(2,2,1)
h=legend(ph,expr.name_disp,'location','Best');
set(h,'FontSize',6)
legend boxoff
grid on
box on
axis tight
set(gca,'LineWidth',2,'FontSize',8) 
xlabel('year','FontSize',8) 
ylabel('km^3/yr','FontSize',8) 
title('Fram Strait ice transport','FontSize',10) 

subplot(2,2,2)
grid on
box on
axis tight
set(gca,'LineWidth',2,'FontSize',8) 
xlabel('year','FontSize',8) 
ylabel('km^3/yr','FontSize',8) 
title('Denmark Strait ice transport','FontSize',10) 

subplot(2,2,3)
grid on
box on
axis tight
set(gca,'LineWidth',2,'FontSize',8) 
xlabel('year','FontSize',8) 
ylabel('km^3/yr','FontSize',8) 
title('Bering Strait ice transport','FontSize',10) 

subplot(2,2,4)
grid on
box on
axis tight
set(gca,'LineWidth',2,'FontSize',8) 
xlabel('year','FontSize',8) 
ylabel('km^3/yr','FontSize',8) 
title('Canadian Archipelago ice transport','FontSize',10) 

% Print the time series

for nexp=length(expr):-1:1
  if expr(nexp).print
    print (gcf,'-dpng', '-r300', [picpath '/' expr(nexp).name '/icetr_ts.png'])
    break
  end
end
