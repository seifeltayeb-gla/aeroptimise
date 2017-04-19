function [aerofoil]=getfoilname(cofile)
%getfoilname checks if coordinate file path is supplied and parses its name.
%
%     INPUT: 1- cofile: path and filename with extension of aerofoil
%                       coordinate file.
%     OUTPUT: 1- aerofoil:  a string containing aerofoil name
%
%   getfoilname checks if a file path, name and extension are supplied, if not,
%               a dialog opens to prompt file selection using the GUI ,if
%               that fails, and error message is displayed,and script
%               execution is halted.

if ~exist('cofile','var') %checks if cofile is assigned any value
    [cofile,path,fi]=uigetfile('.dat');
end

if cofile <= 0 % checks if any files were selected
    error('Please choose a coordinate file or enter its path as an input argument!')
    return
elseif exist('cofile','var') && exist('path','var')
    cofile=strcat(path,cofile);
end

%% imports coordinates from selig format file
        import=importdata(cofile); % imports .dat file as struct
        [r,c]=size(import.data);   % isolates coordinates from struct

        if c>1 %checks header
            airfoil=import.textdata;    % parses aerofoil name
        else   % usually format of NACA aerofoils
            foilna=import.textdata(1);  % parses aerofoil name i.e. NACA
            foilnu=import.data(1);      % parses aerofoil number i.e. 2214
            airfoil=strcat(char(foilna),{' '},num2str(foilnu)); %concenates number and name
        end
end
