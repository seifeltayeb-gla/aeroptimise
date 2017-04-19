function []=PARSECplot(x_i,z_i,x_c,z_c,x_cs,z_cs,P,foil)
%PARSECPLOT is a function that generates a figure containing a plot
%           of imported airfoil coordinates, along with the parametrised
%           aerofoil and the parameters that were obtained using findPARSEC1X.
%
%        []=PARSECplot(x_i,z_i,x_c,z_c,x_cs,z_cs,P,foil)
%
%
%   OUTPUT:
%
%       The plot contains 3 lines:
%
%       1- ORIGINAL: interpolated coordinates based imported coordinate file.
%
%       2- SEPARATE: coordinates obtained by finding the PARSEC parameters
%                    for the upper surface and lower surface independently,
%                    meaning there is 2 leading edge radii instead of 1,
%                    or a total of 12 parameters.
%
%       3-    WHOLE: coordinates obtained by finding hte PARSEC parameters
%                    for the whole airfoil at once. Total of 11 parameters.
%
%    INPUT:
%           1-x_i:  nx1 array of imported and interpolated x-coordiantes
%           2-z_i:  nx1 array of imported and interpolated z-coordiantes
%           3-x_c:  nx1 array of calculated x-coordinates (whole airfoil)
%           4-z_c:  nx1 array of calculated z-coordinates (whole airfoil)
%           5-x_cs: nx1 array of calculated x-coordinates (separate surfaces)
%           6-z_cs: nx1 array of calculated z-coordinates (separate surfaces)
%           7-   P: 1x11 or 1x12 array containing 11 or 12 PARSEC parameters
%           8-foil: cell containing airfoil name (can be obtained using
%                                                               importfoil)
%
close all;
%% plots aerofoils (parametrised & original)
% figure setup
figname=strcat('Base Airfoil Plot-',' ',foil);
aerofig=figure('Name',[char(figname)]);
dim = get(0,'ScreenSize'); %adjusts window size
set(0,'DefaultTextInterpreter', 'latex'); %enables latex notation
set(aerofig, 'Position', [dim(3)/4.5 dim(4)/4 dim(3)/1.5 dim(3)/3]); %adjusts position
ax1 = axes('Position',[0.175 0.05 0.2 .25],'Visible','off');
ax2 = axes('Position',[0.1 .5 0.8 0.4]);
hold on

title([char(foil)],'FontSize',24); %sets figure title as airfoil name
    xlabel('$x$','FontSize',24); %labels x axis
    ylabel('$z$','FontSize',24); %labels z axis
    pbaspect([4 1 1]); %fixes aspect ratio
    grid on
    axis equal
%checks the given arrays and plots only the available ones
    if size (x_i,1) > 1
    plot(ax2,x_i,z_i,'k','DisplayName','import');
    end
    if size (x_c,1) > 1
    plot(ax2,x_c,z_c,'r--','DisplayName','P11- whole');
    end
    if size (x_cs,1)> 1
    plot(ax2,x_cs,z_cs,'b-','DisplayName','P12- separate');
    end
%legend properties
lgd = legend('show');
lgd.FontSize = 14;
legend('boxoff')

if size(P,2) == 11 %checks number of obtained parameters
%prints obtained PARSEC11 parameters
parsec = {sprintf('\\qquad \\qquad \\qquad \\qquad PARSEC parameters \n')
         sprintf('$R_{LE}$:\\ %.5f \\quad $x_{up}$:\\ %.5f \\quad $\\; x_{lo}$:%.5f \\quad \\quad $z_{te}$:%.5f',P(1),P(2),P(5),P(8))
         sprintf('\\qquad \\qquad \\qquad \\quad \\ $z_{up}$:\\ %.5f \\quad $z_{lo}$:%.5f\\quad \\ $\\! \\Delta z_{te}$:%.5f',P(3),P(6),P(9))
         sprintf('\\qquad \\qquad \\qquad \\quad $z_{xx_{up}}$:%.5f \\ $z_{xx_{lo}}$:%.5f \\quad $\\beta_{te}$:%.5f',P(4),P(7),P(10))
         sprintf('\\qquad \\qquad \\qquad \\qquad \\qquad \\qquad \\qquad \\qquad \\qquad \\qquad \\ $\\beta_{te}$:%.5f',P(11))};
elseif size(P,2) == 12
%prints obtained PARSEC parameters
parsec = {sprintf('\\qquad \\qquad \\qquad \\qquad PARSEC parameters \n')
     sprintf('$R_{LE}$:\\ %.5f \\quad $x_{up}$:\\ %.5f \\quad $\\; x_{lo}$:%.5f \\quad \\quad $z_{te}$:%.5f',P(1),P(2),P(5),P(8))
     sprintf('\\qquad \\qquad \\qquad \\quad \\ $z_{up}$:\\ %.5f \\quad $z_{lo}$:%.5f\\quad \\ $\\! \\Delta z_{te}$:%.5f',P(3),P(6),P(9))
     sprintf('\\qquad \\qquad \\qquad \\quad $z_{xx_{up}}$:%.5f \\ $z_{xx_{lo}}$:%.5f \\quad $\\alpha_{te}$:%.5f',P(4),P(7),P(10))
     sprintf('\\qquad \\qquad \\qquad \\qquad \\qquad \\qquad \\qquad \\qquad \\qquad \\qquad \\ $\\beta_{te}$:%.5f',P(11))};
end

axes(ax1) % sets ax1 to current axes
param=text(.025,0.5,parsec);
param(1).FontSize = 20;
title('PARSEC Parameters')
end
