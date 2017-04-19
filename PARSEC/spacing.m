function [x] = spacing(s,n)
%SPACING is a fucntion for producing an array of n-points between 0 and 1
%[x] = spacing(s,n)
%
% OUTPUT: X
%
%  INPUT:
%        s- spacing type, character input ('c','s','-s','l')
%        n- number of desired points (excluding 0)
%           the default value of n is 100
%
%           example: t = spacing('c',200)
%
% SPACING types:
%               cosine spacing **  *   *     *      *     *    *   *  **
%
%                 sine spacing *** * *   *    *     *     *     *      *
%
%                -sine spacing *      *      *     *    *    *   * * ***
%
%               linear spacing *   *   *   *   *   *   *   *   *   *   *

if ~exist('n','var') %checks for user input number of points
    n=100;  %default number of points
end

p=(0:n)'; % transposes points array

%% implements spacing scheme and applies it points
  switch s
       case 'c' %cosine spacing
          x=0.5.*(1-cos((p.*pi./n)));
       case 's' %sine spacing
          x=1.*(sin((p.*pi./2)./n));
       case '-s' %-sine spacing
          x=1.*(1.-cos((p.*pi./2)./n));
       case 'l' %equal spacing
          x=p./n;
  end

end
