% Extrapolate ocean domain flags given in moedit.dat and write
% mertraocean.dat. If moedit.dat does not exist, the script will write a
% template with that name ready for editing. The flag convention is:
%   0: land
%   1: no specific ocean domain, but belonging to the global domain
%   2: Atlantic Ocean
%   3: Pacific Ocean
%   4: Indian Ocean
%   9: Used in moedit.dat to indicate a point which should get a value
%      flag assigned by extrapolation

fid=fopen('moedit.dat','r');
natllat=74;

grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
plat=ncgetvar(grid_file,'plat');
plon=ncgetvar(grid_file,'plon');
pmask=ncgetvar(grid_file,'pmask');

if fid==-1
  pmask(find(pmask==1))=9;

  if ~isempty(natllat)
    % Place Atlantic border along a zonal section with latitute natllat
    mindlat=180;
    n=0;
    fid=fopen('mertraindex.dat','r');
    while 1
      line=fgetl(fid);
      if ~ischar(line)
        break
      end
      if strcmp(line(1:7),'Section')
        n=n+1;
        slat=sscanf(line(9:15),'%f');
        dlat=abs(slat-natllat);
        if dlat<mindlat
          nsec=n;
          mindlat=dlat;
        end
      end
    end
    fseek(fid,0,-1);
    n=0;
    while 1
      line=fgetl(fid);
      if ~ischar(line)
        break
      end
      if strcmp(line(1:7),'Section')
        n=n+1;
        if n==nsec
          while 1
            line=fgetl(fid);
            if ~ischar(line)|strcmp(line(1:7),'Section')
              break
            else
              ind=sscanf(line,'%d',2);
              if pmask(ind(1),ind(2))==9
                pmask(ind(1),ind(2))=2;
              end
            end
          end
          break
        end
      end
    end
    fclose(fid);
  end

  % Write template in moedit.dat
  fid=fopen('moedit.dat','w');
  fprintf(fid,'%6d%6d\n',size(pmask));
  for i=1:size(pmask,1)
    fprintf(fid,'%1d',pmask(i,:));
    fprintf(fid,'\n');
  end
  fclose(fid);
  break

end

% Read information in moedit.dat
nx=fscanf(fid,'%d',1);
ny=fscanf(fid,'%d',1);
flag=reshape(fscanf(fid,'%1d'),ny,nx)';
fclose(fid);

% Read indexes for grid neighbours
ins=ncgetvar(grid_file,'ins');
jns=ncgetvar(grid_file,'jns');
ine=ncgetvar(grid_file,'ine');
jne=ncgetvar(grid_file,'jne');
inn=ncgetvar(grid_file,'inn');
jnn=ncgetvar(grid_file,'jnn');
inw=ncgetvar(grid_file,'inw');
jnw=ncgetvar(grid_file,'jnw');

%break
% Exptrapolate flags
num9old=0;
num9=1;
dir=0;
while num9>0
  dir=1-dir;
  num9old=num9;
  num9=0;
  for j=(dir+ny*(1-dir)):(2*dir-1):((ny-1)*dir+1)
    for i=(dir+nx*(1-dir)):(2*dir-1):((nx-1)*dir+1)
      if flag(i,j)==9
        num9=num9+1;
        flag_s=flag(ins(i,j),jns(i,j));
        flag_e=flag(ine(i,j),jne(i,j));
        flag_n=flag(inn(i,j),jnn(i,j));
        flag_w=flag(inw(i,j),jnw(i,j));
        if     flag_s~=0&flag_s~=9
	  if (flag_e~=0&flag_e~=9&flag_e~=flag_s) | ...
	     (flag_n~=0&flag_n~=9&flag_n~=flag_s) | ...
	     (flag_w~=0&flag_w~=9&flag_w~=flag_s)
	    disp(sprintf('Ambiguous neighbouring flags at (%d,%d)!',i,j))
	  end
          flag(i,j)=flag_s;
        elseif flag_e~=0&flag_e~=9
	  if (flag_n~=0&flag_n~=9&flag_n~=flag_e) | ...
	     (flag_w~=0&flag_w~=9&flag_w~=flag_e)
	    disp(sprintf('Ambiguous neighbouring flags at (%d,%d)!',i,j))
	  end
          flag(i,j)=flag_e;
        elseif flag_n~=0&flag_n~=9
	  if (flag_w~=0&flag_w~=9&flag_w~=flag_n)
	    disp(sprintf('Ambiguous neighbouring flags at (%d,%d)!',i,j))
	  end
          flag(i,j)=flag_n;
        elseif flag_w~=0&flag_w~=9
          flag(i,j)=flag_w;
        end
      end
    end
  end
  disp(sprintf('%d',num9))
  if num9==num9old
    disp('could not extrapolate to all points!')
    break
  end
end

break

% Check consitency of mask and flags
[i,j]=find((pmask==0&flag~=0)|(pmask==1&flag==0));
if ~isempty(i)
  for n=1:length(i)
    disp(sprintf('Inconsistent mask and flag at (%d,%d): mask %d, flag %d!', ...
                 i(n),j(n),pmask(i(n),j(n)),flag(i(n),j(n))))
  end
end


clf
hold on
ind=find(flag==0);
plot(plon(ind),plat(ind),'g.');
ind=find(flag==1);
plot(plon(ind),plat(ind),'b.');
ind=find(flag==2);
plot(plon(ind),plat(ind),'r.');
ind=find(flag==3);
plot(plon(ind),plat(ind),'c.');
ind=find(flag==4);
plot(plon(ind),plat(ind),'y.');
ind=find(flag==9);
plot(plon(ind),plat(ind),'k.');


fid=fopen('mertraoceans.dat','w');
fprintf(fid,'%6d%6d\n',nx,ny);
for i=1:nx
  fprintf(fid,'%1d',flag(i,:));
  fprintf(fid,'\n');
end
fclose(fid);
