function [x_i,z_i,x_c,z_c,P,foil]=findPARSEC11(cofile,nreq,plotopt)
%[x_i,z_i,x_c,z_c,P,foil]=find_parsec(cofile,nreq)
%FIND_PARSEC is a function for parametrising existing airfoils and can be
%             used with Selig format coordinate .dat files.
%
%
try
  [x,z,foil]=importfoil(cofile);    %imports x and z coordinates from file
catch
  [p,n,e] = fileparts(cofile);
  naeworkin=sprintf('%s could not be imported, check the file type or extension.\n',n);
  error(naeworkin);
end
   np = length(x);

%% splits upper and lower airfoil surfaces

    [C,L] = min(x); %returns index of leading edge or (0,0) point
    %upper surface TE-LE
    xu = x(1:L);
    zu = z(1:L);
    %lower surface LE-TE
    zl = z(L:np);
    xl = x(L:np);
    %flips upper surface array to go from 0 to 1
    xu = flipud(xu);
    zu = flipud(zu);

%% interpolates imported coordinates

    %checks for user input number of points
    if ~exist('nreq','var')
        nreq=200; %default of 200
    end
    %creates x-coordinates array for interpolation
    x_f = spacing('c',nreq); %cosine spacing is default
    %interpolates to improve resolution, Spline interpolation is default
    zin_u = interp1(xu, zu, x_f, 'Spline');
    zin_l = interp1(xl, zl, x_f, 'Spline');
    %creates TE-LE-TE format arrays
    x_i = vertcat(flipud(x_f(2:end)),x_f);
    z_i = vertcat(flipud(zin_u(2:end)),zin_l);

    %% PARSEC parameter determination
    % some parameters can be estimated using simple algebraic operations
    % and numerical differentiation

    % finds z-coordinates of upper surface maxima and lower surface minima
    [P_zu, l_zu] = max(zin_u); %P3
    [P_zl, l_zl] = min(zin_l); %P6
    % finds x-coordinates of upper surface maxima and lower surface minima
    P_xu = x_f(l_zu); %P2
    P_xl = x_f(l_zl); %P5
    %trailing edge thickness and offset
    P_dzte = z(1) - z(np);  %P9
    P_zte = z(1) - P_dzte/2;%P8
    %trailing edge wedge angle and direction angle
    dz_dx_u = diff(zin_u)./diff(x_f); %numerical derivative of upper surface
    i1 = atan(dz_dx_u(length(x_f)-1));
    dz_dx_l = diff(zin_l)./diff(x_f); %numerical derivative of lower surface
    i2 = atan(dz_dx_l(length(x_f)-1));
    P_beta = (i2-i1);   %P10
    P_alpha = (i2+i1)/2;%P11
    %assigns calculated parameters
    P_i = [P_xu P_zu P_xl P_zl P_zte P_dzte P_alpha P_beta];

%% Solving for unknown PARSEC parameters

%increases fminsearch tolerance for better accuracy
opts = optimset('TolX',1e-8,'TolFun',1e-8);

% solves for upper and lower surface curvature values and the leading edge
% radius
    unk0 = [0 ,     0,     0]; %initial values
    unkl = [0 , -5000, -5000]; %upper bound
    unku = [10,  5000,  5000]; %lower bound

    unk = fminsearchbnd(@(pp) err_p(pp, P_i, x_f,z_i),unk0, unkl,unku,opts); %fminsearchbnd by John D'Errico from MathWorks forum
    [x_c, z_c] = PARSECpts11(unk, P_i, x_f); %calculates coordinates

    P = [unk(1) P_i(1) P_i(2) unk(2) P_i(3) P_i(4) unk(3) ... %P1-P7
                              P_i(5) P_i(6) P_i(7) P_i(8)];   %P8-P11

% %% List PARSEC parameters in table
%
% %successful parametrisation message
% fprintf('\n %s was successfully parametrised! :D\n \n',[char(foil)]);
% %creates and displays table with 11 PARSEC parameters
% %table column names
% PARSECname={'R_le','X_up','Z_up','Z_xxup',...
%                    'X_lo','Z_lo','Z_xxlo',...
%                    'Z_te','del_Z_te','alpha_te','beta_te'};
% %table format
% T_P = table(P','RowNames',PARSECname,'VariableNames',{'Separate'});
% disp(T_P)

%% writes coordinate file

% coordinates using whole airfoil parametrisation
xparsec=x_c;
zparsec=z_c;

    [p,n,e] = fileparts(cofile); %gets file name
    parsecfile=sprintf('pfoils/%s_p11.dat',n);
    fileID = fopen(parsecfile,'w');
    %writes airfoil name header
    fprintf(fileID,'%s %s\n',[char(foil)],[char(' PARSEC11')]);
    %writes airfoil x and z coordinates
    for row = 1:size(xparsec)
        fprintf(fileID,'%.5f  %.5f\n',xparsec(row),zparsec(row));
    end
    fclose(fileID);

%% Plots airfoil with PARSEC parameters on figure

if exist('plotopt','var')
    if plotopt
        PARSECplot(x,z,x_c,z_c,[],[],P,foil)
    end
end
