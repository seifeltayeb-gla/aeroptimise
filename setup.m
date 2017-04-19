clc;
current=pwd;
cd(current);
addpath('PARSEC');
[p,n,e]=fileparts(current);
fprintf('Directory successfully changed to %s\n',n)