function [err] = err_u(p_u, p_k, x_f, za_u)
%
%err_l calculates discrency between calculated and imported aerofoil coordinates
%      for the lower surface of an aerofoil parameterised using PARSEC12
%
% The discrepency between the imported and interpolated coordinate files
% and the points calculated using the PARSEC11 parametrisation method is
% evaluated, squared, then the mean is taken to indicate the goodness of
% fit of the parametrisation.
%
% The function is to be used to search for the best values for leading edge
% radius and crest curvatures and is used in findPARSEC12 as the function
% to be minimised
%
%
%   OUTPUT:
%           1-  err: a positive float value indicating the error
%
%   INPUT:
%           1- p_u: The known PARSEC11 parameters that can be found by
%           analysing imported coordinates
%
%           2- p_k: Unknown parameters that are used as the variables being
%           interated for by fminsearchbnd
%
%           3- x_f: aerofoil imported x-coordiantes
%
%           4- z_f: aoerofil imported z-coordiantes
%

%% Assembles PARSEC Parameters
p = [p_u(1) p_k(1) p_k(2) p_u(2) p_k(3) p_k(4) p_u(3) p_k(5) p_k(6) p_k(7) p_k(8)];

%% Upper Surface Matrices
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

%% Coefficient Calculation: C_up X a_up =b_up ==>  a_up =(C_up)^-1 X b_up
    a_up=C_up \ B_up;           %upper surface coefficients
    zc_u = zeros(length(x_f),1);% creates empty arrays for z-coordinates

    for i = 1:6 %calculates point z-coordinates
        zc_u = zc_u + a_up(i)*x_f.^(i-0.5);
    end

%% calculates MS error
    err = mean((zc_u-za_u).^2);
end
