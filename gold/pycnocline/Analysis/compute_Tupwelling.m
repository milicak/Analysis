% this subroutine computes T_up from T_moc-(Tek+Tgm) since Tmoc>0 ; Tek>0 but Tgm<0
clear all

out1 = load('matfiles/wind_stress_SO.mat');
Tek = out1.Tek;

out2 = load('matfiles/moc.mat');
ind = max(find(out2.lat<=26.7))
Tmoc = [max(out2.moc0(:,ind)) max(out2.moc1(:,ind)) max(out2.moc2(:,ind)) max(out2.moc4(:,ind)) max(out2.moc6(:,ind)) max(out2.moc8(:,ind))];

out3 = load('matfiles/mocGM.mat');
Tgm = [min(out3.mocGM0(:)) min(out3.mocGM1(:)) min(out3.mocGM2(:)) min(out3.mocGM4(:)) min(out3.mocGM6(:)) min(out3.mocGM8(:))];

Tup = Tmoc-(Tek+Tgm);
