function [x_c, z_c] = PARSECpts_opt(p)
%PARSECpts_opt is a compact version that combines PARSEC11 and PARSEC12 scripts
%              through checking the number of parameters and determining which
%              lower surface matrix to use

n=200;  %number of points
x_f = spacing('c',n-1);

%% Upper Surface C Matrix
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

%% Lower Surface C Matrix
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

    [~,r]=size(p); %Determines number of PARSEC parameters

%% B Matrices
    if     r==11 % single radius matrix, P1 only
        B_up = [p(8)+p(9)/2;p(3);tan(p(10)-p(11)/2);0;p(4);sqrt(2*p(1))];
        B_lo = [p(8)-p(9)/2;p(6);tan(p(10)+p(11)/2);0;p(7);-sqrt(2*p(1))];
    elseif r==12 % double radius matrix, P1 and P12
        B_up = [p(8)+p(9)/2;p(3);tan(p(10)-p(11)/2);0;p(4);sqrt(2*p(1))];
        B_lo = [p(8)-p(9)/2;p(6);tan(p(10)+p(11)/2);0;p(7);-sqrt(2*p(12))];
    end

%% Coefficient Calculation: C_up X a_up =b_up ==>  a_up =(C_up)^-1 X b_up
    a_up=C_up \ B_up; %upper surface coefficients
    a_lo=C_lo \ B_lo; %lower surface coefficients

    zc_u = zeros(n,1); zc_l = zeros(n,1); % creates empty z-coordinates arrays

    for i = 1:6 %calculates point z-coordinates
        zc_u = zc_u + a_up(i)*x_f.^(i-0.5); zc_l = zc_l + a_lo(i)*x_f.^(i-0.5);
    end

    z_c=vertcat(flipud(zc_u(2:end)),zc_l); %concenates z-coordinates
    x_c=vertcat(flipud(x_f(2:end)),x_f);   %concenates x-coordinates
end
