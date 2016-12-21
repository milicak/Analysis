clear all
fyear = 1;
lyear = 250;

matfiles = '/export/grunchfs/unibjerknes/milicak/bckup/Analysis/pop/Arctic/Analysis/matfiles/'
load /fimm/home/bjerknes/milicak/Analysis/NorESM/CORE2/Arctic/Analysis/m_files/color_15

grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/areacello_fx_CCSM4_piControl_r0i0p0.nc';
area=ncgetvar(grid_file,'areacello');

%project_name = 'B1850CN_f19_tn11_kdsens';
%project_name = 'B1850CN_f19_tn11_kdsens01';
%project_name = 'B1850CN_f19_tn11_kdsens02';
%project_name = 'B1850CN_f19_tn11_kdsens03';
%project_name = 'B1850CN_f19_tn11_kdsens04';
%project_name = 'B1850CN_f19_tn11_kdsens05'
%project_name = 'B1850CN_f19_tn11_kdsens06'

projects=[{'B1850CN_f19_tn11_kdsens'} {'B1850CN_f19_tn11_kdsens01'} {'B1850CN_f19_tn11_kdsens02'} {'B1850CN_f19_tn11_kdsens03'} ...
          {'B1850CN_f19_tn11_kdsens05'} {'B1850CN_f19_tn11_kdsens04'} {'B1850CN_f19_tn11_kdsens06'}];

for i=1:4
  filename=[matfiles char(projects(i)) '_airtemp_mean_' num2str(fyear) '_' num2str(lyear) '.mat'];
  load(filename)
  dnm = squeeze(AIRTEMPTrefwinter(:,:,49:end));
  dnm = squeeze(nanmean(dnm,3));
  dnm = squeeze(nanmean(dnm,2));
  figure(1)
  hold on
  plot(1:250,my_nanfilter(dnm,5,'box'),'color',[color(i,1) color(i,2) color(i,3)],'linewidth',2);
end
  xlabel('Time [years]')
  ylabel('Northern Hemisphere air temperature [^\circ C]')
  legend('Cold-ctrl','Exp1','Exp2','Exp3')
printname = ['paperfigs/cold_exps_airtempwinternorth_time.eps']
print(1,'-depsc2',printname)


for i=5:7
  filename=[matfiles char(projects(i)) '_airtemp_mean_' num2str(fyear) '_' num2str(lyear) '.mat'];
  load(filename)
  dnm = squeeze(AIRTEMPTrefwinter(:,:,49:end));
  dnm = squeeze(nanmean(dnm,3));
  dnm = squeeze(nanmean(dnm,2));
  figure(2)
  hold on
  plot(1:250,my_nanfilter(dnm,5,'box'),'color',[color(i,1) color(i,2) color(i,3)],'linewidth',2);
end
  xlabel('Time [years]')
  ylabel('Northern Hemisphere air temperature [^\circ C]')
  legend('Warm-ctrl','Exp4','Exp5')
printname = ['paperfigs/warm_exps_airtempwinternorth_time.eps']
print(2,'-depsc2',printname)


for i=[1 5]
  filename=[matfiles char(projects(i)) '_airtemp_mean_' num2str(fyear) '_' num2str(lyear) '.mat'];
  load(filename)
  dnm = squeeze(AIRTEMPTrefwinter(:,:,49:end));
  dnm = squeeze(nanmean(dnm,3));
  dnm = squeeze(nanmean(dnm,2));
  figure(3)
  hold on
  plot(1:250,my_nanfilter(dnm,5,'box'),'color',[color(i,1) color(i,2) color(i,3)],'linewidth',2);
end
  xlabel('Time [years]')
  ylabel('Northern Hemisphere air temperature [^\circ C]')
  legend('Cold-ctrl','Warm-ctrl')
printname = ['paperfigs/cold_warm_ctrls_airtempwinternorth_time.eps']
print(3,'-depsc2',printname)
