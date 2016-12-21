function [z_scaled,ztick,zticklabel,zlim_scaled,z_split]=rescale_depth(z)

[m,n]=size(z);
z=reshape(z,prod([m,n]),1);

if nanmax(z)<400
    z_split=50;
    dzup=10; dzlo=100;
elseif nanmax(z)<700
    z_split=100;
    dzup=25; dzlo=200;
elseif nanmax(z)<2000
    z_split=250;
    dzup=50; dzlo=250;
else
    z_split=500;
    dzup=100; dzlo=500;
end

in=find(z>z_split);
zup=z(1:in(1)-1);
zlo=z(in);

[lim1, dum1] = get_axislim(zup);
[lim2, dum2] = get_axislim(zlo);
zlim=[lim1(1) lim2(2)];
z_scaled=z;
zlo_scaled=z_split+(((zlo-z_split)./dzlo).*dzup);
z_scaled(in)=zlo_scaled;

zlim_scaled=[zlim(1) z_split+(((zlim(2)-z_split)./dzlo).*dzup)];

ztick=[zlim_scaled(1):dzup:zlim_scaled(2)];
zticklabel=[zlim(1):dzup:z_split,z_split+dzlo:dzlo:zlim(2)];
z_scaled=reshape(z_scaled,m,n);

