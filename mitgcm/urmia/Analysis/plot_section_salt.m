

aa = isnan(sq(S1(:,:,:)));
aa = squeeze(sum(aa,3));

scatter(dens_april_deep(1,:),dens_april_deep(2,:),[],dens_april_deep(3,:))
