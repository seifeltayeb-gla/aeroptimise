function [x_c,z_c,z_uc,z_lc] = PARSECpts11(p_u, p_k, x_f)
%
%PARSECpts11 calculates the z-coordiantes of an aerofoil given 11 PARSEC parameters
%
%
%   Supplied with x-coordinates and PARSEC parameters, the script calculates
%   and outputs
%
%
%   OUTPUT:
%           1-  x_cs: aerofoil x-coordinates for whole aerofoil
%
%           2-  z_cs: calculated aerofoil z-coordinates for whole aerofoil
%                     concenation of z_uc and z_lc in (TE-LE-TE) format
%
%           3-  z_uc: calculated aerofoil upper surface coordinates
%
%           4-  z_lc: calculated aerofoil upper surface coordinates
%
%   INPUT:
%           1- p_u: The known PARSEC11 parameters that can be found by
%                   analysing imported coordinates
%
%           2- p_k: Unknown parameters that are used as the variables being
%                   interated for by fminsearchbnd
%
%           3- x_f: aerofoil imported x-coordiantes
%
if size(p_u,1) < 1
    p=p_k;
else
p = [p_u(1) p_k(1) p_k(2) p_u(2) p_k(3) p_k(4) p_u(3) p_k(5) p_k(6) p_k(7) p_k(8)];
end

if size(p,2) > 11
    error('Please check the number of parameters')
end
%% Upper Surface Matrix
    C_up(1,:)= [1 ,1 ,1 ,1 ,1 ,1];

    C_up(2,:)= [(p(2))^0.5 ,(p(2))^1.5 ,(p(2))^2.5 ,...
                (p(2))^3.5 ,(p(2))^4.5 ,(p(2))^5.5];

    C_up(3,:)= [0.5 ,1.5 ,2.5 ,3.5 ,4.5 ,5.5];

    C_up(4,:)= [0.5*(p(2))^-0.5 ,1.5*(p(2))^0.5 ,2.5*(p(2))^1.5 ,...
                3.5*(p(2))^2.5  ,4.5*(p(2))^3.5 ,5.5*(p(2))^4.5];

    C_up(5,:)= [(-1/4)*(p(2))^-1.5 ,(3/4)*(p(2))^-0.5,...
                (15/4)*(p(2))^0.5  ,(15/4)*(p(2))^0.5,...
                (63/4)*(p(2))^2.5  ,(99/4)*(p(2))^3.5];

    C_up(6,:)= [1 ,0 ,0 ,0 ,0 ,0];
%%%%%%%%
    B_up = [p(8)+p(9)/2;p(3);tan(p(10)-p(11)/2);0;p(4);sqrt(2*p(1))];

%% Lower Surface Matrix
    C_lo(1,:)= C_up(1,:);

    C_lo(2,:)= [(p(5))^0.5 ,(p(5))^1.5 ,(p(5))^2.5 ,...
                (p(5))^3.5 ,(p(5))^4.5 ,(p(5))^5.5];

    C_lo(3,:)= [0.5 ,1.5 ,2.5 ,3.5 ,4.5 ,5.5];

    C_lo(4,:)= [0.5*(p(5))^-0.5 ,1.5*(p(5))^0.5 ,2.5*(p(5))^1.5 ,...
                3.5*(p(5))^2.5  ,4.5*(p(5))^3.5 ,5.5*(p(5))^4.5];

    C_lo(5,:)= [(-1/4)*(p(5))^-1.5 ,(3/4)*(p(5))^-0.5,...
                (15/4)*(p(5))^0.5  ,(15/4)*(p(5))^0.5,...
                (63/4)*(p(5))^2.5  ,(99/4)*(p(5))^3.5];

    C_lo(6,:)= C_up(6,:);
%%%%%%%%
    B_lo = [p(8)-p(9)/2;p(6);tan(p(10)+p(11)/2);0;p(7);-sqrt(2*p(1))];

%% Coefficient Calculation: C_up X a_up =b_up ==>  a_up =(C_up)^-1 X b_up
    a_up=C_up \ B_up; %upper surface coefficients
    a_lo=C_lo \ B_lo; %lower surface coefficients

    z_uc = zeros(length(x_f),1); z_lc = zeros(length(x_f),1);

    for i = 1:6 %calculates point z-coordinates
        z_uc = z_uc + a_up(i)*x_f.^(i-0.5); z_lc = z_lc + a_lo(i)*x_f.^(i-0.5);
    end
    z_c=vertcat(flipud(z_uc(2:end)),z_lc);%concenates z-coordinates
    x_c=vertcat(flipud(x_f(2:end)),x_f);  %concenates x-coordinates
end
