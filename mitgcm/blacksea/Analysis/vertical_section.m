drf=rdmds('DRF');
dz=(sq(drf));
hfacc=rdmds(['hFacC']);         % Level thicknesses
[Nx Ny Nz]=size(hfacc);
delta_z=repmat(dz,[1 Nx Ny]);
delta_z=permute(delta_z,[2 3 1]);
delta_z=delta_z.*hfacc;
delta_z_ref=delta_z;

depth=rdmds(['Depth']);

T=rdmds('THETA',864*103);

eta=rdmds('ELEVATION',864*103);

corr=(1.0+eta./depth);
corr=repmat(corr,[1 1 Nz]);
delta_z=delta_z_ref.*corr;

gcolor(sq(T(400,100:250,:))',squeeze(delta_z(400,100:250,:))','cplm')
