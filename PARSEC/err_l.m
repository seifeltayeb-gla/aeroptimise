function [err] = err_l(p_u, p_k, x_f,za_l)
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

%% Lower Surface Matrices
    C_lo(1,:)= [1 ,1 ,1 ,1 ,1 ,1];

    C_lo(2,:)= [(p(5))^0.5 ,(p(5))^1.5 ,(p(5))^2.5 ,...
                (p(5))^3.5 ,(p(5))^4.5 ,(p(5))^5.5];

    C_lo(3,:)= [0.5 ,1.5 ,2.5 ,3.5 ,4.5 ,5.5];

    C_lo(4,:)= [0.5*(p(5))^-0.5 ,1.5*(p(5))^0.5 ,2.5*(p(5))^1.5 ,...
                3.5*(p(5))^2.5  ,4.5*(p(5))^3.5 ,5.5*(p(5))^4.5];

    C_lo(5,:)= [(-1/4)*(p(5))^-1.5 ,(3/4)*(p(5))^-0.5,...
                (15/4)*(p(5))^0.5  ,(15/4)*(p(5))^0.5,...
                (63/4)*(p(5))^2.5  ,(99/4)*(p(5))^3.5];

    C_lo(6,:)= [1 ,0 ,0 ,0 ,0 ,0];
%%%%%%%%
    B_lo = [p(8)-p(9)/2;p(6);tan(p(10)+p(11)/2);0;p(7);-sqrt(2*p(1))];

%% Coefficient Calculation: C_lo X a_lo =b_lo ==>  a_lo =(C_lo)^-1 X b_lo
    a_lo=C_lo \ B_lo;            %lower surface coefficients
    zc_l = zeros(length(x_f),1); % creates empty arrays for z-coordinates

    for i = 1:6 %calculates point z-coordinates
        zc_l = zc_l + a_lo(i)*x_f.^(i-0.5);
    end
%% calculates MS error
    err = mean((zc_l-za_l).^2);
end
