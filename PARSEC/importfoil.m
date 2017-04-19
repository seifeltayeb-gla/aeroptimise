function [xi,zi,foil] = importfoil( cofile )
%[xi,zi,foil] = importfoil(cofile)
%    INPUT
%    cofile: string containing file path and name
%            if left blank, user will be prompted to select file using GUI
%    OUTPUT
%       xi: imported x-coordinates
%       zi: imported z-coordintaes
%     foil: airfoil name as included in coordinate file's header
%
%   imports airfoil coordinates from .dat Selig format file: (T.E- L.E -T.E)
%                                                            (1  -  0  -  1)

%% file check
%checks if coordinate file path is supplied.
%if not, opens dialog for selection
%if not again, error message is displayed and script is terminated

    if ~exist('cofile','var')
        [cofile,path,fi]=uigetfile('.dat');
    end

    if cofile <= 0
        error('Please choose a coordinate file or enter its path as an input argument!')
        return
    elseif exist('cofile','var') && exist('path','var')
        cofile=strcat(path,cofile);
    end
%% imports coordinates from selig format file (TE-LE-TE)
    import=importdata(cofile);
    [r,c]=size(import.data);

    if c>1
        foil=import.textdata;   % aerofoil name
        xi=import.data(:,1);    % x-coordinates
        zi=import.data(:,2);    % z-coordinates
      else
        foilna=import.textdata(1);  % aerofoil name
        foilnu=import.data(1);      % aerofoil number
        foil=strcat(char(foilna),{' '},num2str(foilnu));

        zi=import.data([2:end],1); % z-coordinates
        xi=import.textdata;        % x-coordinates
        xi=cell2mat(xi([2:end],1));% converts imported x-coordinates to double
        xi=str2num(xi);            % converts imported z-coordinates to double
    end
end
