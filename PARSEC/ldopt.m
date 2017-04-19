function coeff = ldopt(P)
%  ldopt is the objective function used for lift and drag optimisation
%  coeff returns n-objective values that are passed by ga or gamultiobj to
%        drive the optimisation

global CLo CLCDo alpha pfNAME;
[x,z]=PARSECpts_opt(P); % aerofoil x and z coordinates generated from PARSEC parameters

%% writes coordinates of generated aerofoil to file to be analyse
  fileID = fopen('parsecopt.dat','w');fprintf(fileID,'testfoil \n');
  for r = 1:size(x)
      fprintf(fileID,'%.5f  %.5f\n',x(r),z(r));
  end
      fclose(fileID);

%% Performance and objective evaluation
  try
  % Attempts to evaluate aerofoil performance using XFOIL
  [polm,~]=xfoil('parsecopt.dat',alpha,5E5,0.1,'panels n 200','oper iter 500');
  CL=polm.CL; CD=polm.CD;      %extracts performance parmeters from XFOIL analysis
  coeff(1)=mean(CLo-polm.CL)^2;               %CL objective
  coeff(2)=mean(CLCDo-(polm.CL./polm.CD))^2;  %CL/CD objective
  % prints objective function values and parsec parameters used
  fprintf('RMS error to objective %.5f  |  ',coeff);
  fprintf('\n%.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f \n \n',P)

  catch
  % if xfoil fails to analyse the objective function is set to the base aerofoil CL
  coeff(1)=mean((CLo-0).^2);
  coeff(2)=mean((CLCDo-0).^2);
  CL=999; CD=999; % prints 999 to inform user that analysis failed
  warning('off','backtrace');
  warning('Analysis did not converge! Assumed RMS error is %.5f.',coeff);
  end

%% saves values to log file
pfIDa = fopen(pfNAME,'a');
fprintf(pfIDa,'\n|%+5f|%+5f|%+5f|%+5f|%+5f|%+5f|%+3f|%+5f|%+5f|%+5f|%+5f|%+5f|%+5f|%+5f|%+5f|%+5f|',P(1),P(2),P(3),P(4),P(5),P(6),P(7),P(8),P(9),P(10),P(11),P(12),CL,coeff(1),CD,coeff(2));
fclose(pfIDa);
fclose('all');
end
