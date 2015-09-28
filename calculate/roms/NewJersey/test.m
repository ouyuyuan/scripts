
Vname = 'zeta';
Finp = Zeta;
mask = squeeze( Rmask3d(:,:,1) );

switch Vname
  case ('zeta')
    is2d=1;
  otherwise
    is2d=0;
end,

% Check input ROMS grid structure for required fields.

if (isfield(S,'lon_rho')),
  rlon=S.lon_rho;
else,
  error([ 'MERCATOR2ROMS - cannot find longitude field: lon_rho, ', ...
          'in structure array S']);
end,

if (isfield(S,'lat_rho')),
  rlat=S.lat_rho;
else,
  error([ 'MERCATOR2ROMS - cannot find latitude field: lat_rho, ', ...
          'in structure array S']);
end,

if (isfield(S,'mask_rho')),
  rmask=S.mask_rho;
else,
  rmask=ones(size(rlon));
end,

if (~is2d),
  if (isfield(S,'z_r')),
    z_r=S.z_r;
  else,
    error([ 'MERCATOR2ROMS - cannot find depth field: z_r, ', ...
            'in structure array S']);
  end,
end,

%----------------------------------------------------------------------------
%  Trim Mercator data form large input grid to make interpolations more
%  tractable.  This possible since the Mercator grid has a North-South
%  orientation.
%----------------------------------------------------------------------------

ii=min(find(lon(:,1) > (min(rlon(:))-1))): ...
   max(find(lon(:,1) < (max(rlon(:))+1)));

jj=min(find(lat(1,:) > (min(rlat(:))-1))): ...
   max(find(lat(1,:) < (max(rlat(:))+1)));

x=lon(ii,jj);
y=lat(ii,jj);

%----------------------------------------------------------------------------
%  Interpolate 2D field.
%----------------------------------------------------------------------------

if (is2d),

  M=mask(ii,jj);           % Sample Mercator Land/Sea mask
  wet=find(M > 0);         % Mercator wet points
  
  F=Finp(ii,jj);
  
  Fout=rmask.*griddata(x(wet),y(wet),F(wet),rlon,rlat,'linear');

%  Replace NaNs with neareast neighbor value.

  indnan=find(rmask == 1 & isnan(Fout) == 1);
  indwet=find(rmask == 1 & isnan(Fout) == 0);

  icnan=length(indnan);
%  disp(['  ', sprintf('%4s',Vname), ', icNaN = ', num2str(icnan)]);

  for m=1:length(indnan),
    d=sqrt((rlon(indnan(m))-rlon(indwet)).*(rlon(indnan(m))-rlon(indwet)) + ...
           (rlat(indnan(m))-rlat(indwet)).*(rlat(indnan(m))-rlat(indwet)));
    near=find(d == min(d));
    if ~isempty(near),
      Fout(indnan(m))=Fout(indwet(near));
    end,
  end,

  indwet=find(rmask == 1);
  Fmin=min(min(Fout(indwet)));
  Fmax=max(max(Fout(indwet)));

end,

%----------------------------------------------------------------------------
%  Interpolate 3D field.
%----------------------------------------------------------------------------

if (~is2d),

  icnan=0;

%  Determine how many level of Mercator data to process. Sometimes the
%  bottom level(s) have zero values.

  Nlev=size(Finp,3);
  
  for k=size(Finp,3):-1:20,
    if (min(min(Finp(:,:,k))) == 0 & max(max(Finp(:,:,k))) == 0),
      Nlev=k-1;
    end,
  end,
  
%  Horizontal interpolation into Mercator Z-levels.

  for k=1:Nlev,

    M=mask(ii,jj,k);         % Sample Mercator Land/Sea mask
    wet=find(M > 0);         % Mercator wet points

    F=squeeze(Finp(ii,jj,k));
    Fwork=rmask.*griddata(x(wet),y(wet),F(wet),rlon,rlat,'linear');
  
%  Replace NaNs with neareast neighbor value.

    indnan=find(rmask == 1 & isnan(Fwork) == 1);
    indwet=find(rmask == 1 & isnan(Fwork) == 0);

    icnan=icnan+length(indnan);
%   disp(['  ', sprintf('%4s',Vname), ', Level = ', sprintf('%2i',k), ...
%         ' icNaN = ', num2str(icnan)]);
    
    for m=1:length(indnan),
      d=sqrt((rlon(indnan(m))-rlon(indwet)).*(rlon(indnan(m))-rlon(indwet)) + ...
             (rlat(indnan(m))-rlat(indwet)).*(rlat(indnan(m))-rlat(indwet)));
      near=find(d == min(d));
      if ~isempty(near),
        Fwork(indnan(m))=Fwork(indwet(near));
      end,
    end,

    Flev(:,:,k)=Fwork;
  
  end,

%  Vertical interpolation into ROMS grid. Notice that Mercator depths
%  are positive.

  [Im,Jm,N]=size(z_r);

  Fout=zeros(size(z_r));
  depth=-abs(depth(1:Nlev));
  depth(1)=0.0;                % reset surface level to zero (0.49 orinally)
  
  for j=1:Jm,
    for i=1:Im,
      if (rmask(i,j) == 1),
	Fout(i,j,:)=interp1(depth,squeeze(Flev(i,j,:)),squeeze(z_r(i,j,:)));
      end,
    end,
  end,

  indwet=find((repmat(rmask,[1,1,N])) == 1);
  Fmin=min(min(min(Fout(indwet))));
  Fmax=max(max(max(Fout(indwet))));
  
end,

disp([ 'Interpolated  ', sprintf('%4s',Vname), ...
       '  number of NaNs replaced with nearest value = ',num2str(icnan)]);
disp([ '                    Min=', sprintf('%12.5e',Fmin), ...
       '  Max=', sprintf('%12.5e',Fmax)]);

