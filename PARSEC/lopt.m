function coeff = lopt(P)
%  lopt is the function to be used with GA to optimise an aerofoil for lift,
%     a single objective optimisation

tic %starts timer
  global CLo alpha pfNAME;
  [x,z]=PARSECpts_opt(P);
%% writes coordinates to file
  fileID = fopen('parsecopt.dat','w'); fprintf(fileID,'testfoil \n');
  for r = 1:size(x)
      fprintf(fileID,'%.5f  %.5f\n',x(r),z(r));
  end
      fclose(fileID);

%% Performance and objective evaluation
  try
  %Attempts to evaluate aerofoil performance using XFOIL
  [polm,~]=xfoil('parsecopt.dat',alpha,5E5,0.1,'panels n 200','oper iter 300');
  coeff(1)=mean(CLo-polm.CL)^2; %CL objective
  CLm=polm.CL;
  % prints objective function values and parsec parameters used
  fprintf('RMS error to objective %.5f  |  ',coeff);
  fprintf('\n%.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f \n \n',P)

  catch
  % if xfoil fails to analyse the objective function is set to the base aerofoil CL
  CLm=0;
  coeff(1)=mean((CLo-0)^2);
  warning('off','backtrace');
  warning('Analysis did not converge!... Assumed RMS error is %.5f. Time taken: %.4f s  |',coeff,toc);
  end

%% saves values to log file
pfIDa = fopen(pfNAME,'a');
fprintf(pfIDa,'\n|%+5f|%+5f|%+5f|%+5f|%+5f|%+5f|%+3f|%+5f|%+5f|%+5f|%+5f|%+5f|%+5f|%+5f|',P(1),P(2),P(3),P(4),P(5),P(6),P(7),P(8),P(9),P(10),P(11),P(12),CLm,coeff(1));
fclose(pfIDa);
fclose('all');
end
