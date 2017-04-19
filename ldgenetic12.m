addpath('PARSEC')
clear all; close all; clc;
global CL CD alpha pfNAME;

cofile='seligFmt_coord/naca2412.dat';
[p,n,e]=fileparts('seligFmt_coord/naca2412.dat');
%% LOGGING AND RECORD
optrecord = fopen('optimisation_record.txt','a');
fprintf(optrecord,'-\n|%-35s \t log_%s\n',cofile,datestr(now,'mmddHHMMSS'));
fclose(optrecord);

pfNAME=sprintf('plogs/%s_%s_ld12.txt',n,datestr(now,'mmddHHMM')); 

[a b]=strtok(cofile,'seligFmt_coord/');
if sum(findstr(b, '.dat'))==0
newfile=sprintf('%s.dat',strcat(a,b));
else
newfile=strcat(a,b);
end
% copyfile('geneticfoil.dat',newfile);
diary([char(strcat('logs/log_',datestr(now,'mmddHHMMSS'),'.txt'))]);
%% GENETIC ALGORITHM SETUP
sT=clock;
fprintf('Optimisation started on %.2i/%.2i/%.4i at %.2i:%.2i:%.2i',fliplr(sT(1:3)),sT(4:5),round(sT(6)))
     nvars = 12;       %number of parameters the genetic algorithm is to vary
    del_ld = @ldopt; %objective function, RMS difference between original
                       %airfoil lift and target lift

%%parametrises airfoil and obtains PARSEC parameters
[x_i,z_i,x_cs,z_cs,P,foil]=findPARSEC12(cofile,250);


%%xfoil analysis
[pol,~]=xfoil(cofile,0:30,5E5,0.1,'panels n 250','oper iter 500');
[CL,Lind]=max(pol.CL); %parses CL and passes onto optimisation objective 
[CD,Dind]=min(pol.CD); %parses CD and passes onto optimisation objective
alpha=pol.alpha(Lind);
fprintf('The maximum Lift Coefficient is %.6f at %.2i degrees. \n',CL,pol.alpha(Lind)) %prints base CL
fprintf('The minimum Drag Coefficient is %.6f at %.2i degrees. \n \n',CD,pol.alpha(Dind)) %prints base CD
%% CREATES PARAMETER AND OBJECTIVE LOG
pfID = fopen(pfNAME,'w');
fprintf(pfID,'Optimisation started on %.2i/%.2i/%.4i at %.2i:%.2i:%.2i\n',fliplr(sT(1:3)),sT(4:5),round(sT(6)))
fprintf(pfID,'|---P1----|----P2---|----P3---|----P4---|----P5---|----P6---|----P7---|----P8---|----P9---|---P10---|---P11---|---P12---|----CL---|--RMS 1--|----CD---|--RMS 2--|\n');
fprintf(pfID,'|---------------------------------------------------------------------------------------------------------------------------------------------------------------|');
fprintf(pfID,'\n|%+5f|%+5f|%+5f|%+5f|%+5f|%+5f|%+3f|%+5f|%+5f|%+5f|%+5f|%+5f|%+5f|%+5f|%+5f|%+5f|',P(1),P(2),P(3),P(4),P(5),P(6),P(7),P(8),P(9),P(10),P(11),P(12),CL,0,CD,0);
fclose(pfID);
%% GENETIC ALGORITHM SETUP
%limits parameter variation to 20 percent of original parameters (± 10%)
LB = P-abs(0.1*P);
UB = P+abs(0.1*P); 
%genetic algorithm expression
options = optimoptions('GAMULTIOBJ','FunctionTolerance',1e-3);
[x,fval,exitflag,output] = gamultiobj(del_ld,nvars,[],[],[],[],LB,UB,options);


eT=clock;
elt=eT-sT;
fprintf('The optimisation was completed successfully in %.2ihrs %.2imin %.2is. \n',elt(4),elt(5),round(elt(6)))

optrecord = fopen('optimisation_record.txt','a');
fprintf(optrecord,'|running time:%.2ihrs %.2imin %.2is \n-',elt(4),elt(5),round(elt(6)));
fclose(optrecord);


diary off;
