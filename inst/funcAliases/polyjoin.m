## Copyright (C) 2017 - Piyush Jain
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File}[@var{vecx},@var{vecy}] = polyjoin(@var{cellx},@var{celly})
## Convert cell arrays of polygons into NaN delimited coulmn vectors.
##
## @var{cellx}/@var{celly} is a cell array of polygons, representing the x/y coordinates of the points.
## @var{cellx}/@var{celly} is expected to be an Nx1 (column) cell array with each cell
## containing a matrix of Mx1 (X)/(Y) coordinates.
## 
## The function converts the cell arrays into column vectors containing the polygons separated by NaN(s)
##
## @seealso{polysplit}
## @end deftypefn

## Created: 2017-07-19

function [vecx,vecy] = polyjoin(cellx,celly)

  if (nargin != 2)
    #case wrong number of input arguments
    print_usage();
  endif

  if(!iscell(cellx) || !iscell(cellx))
    #case of wrong input format
    error ('Octave:invalid-input-arg', ...
            "polyjoin: cell array expected");
  endif


  #check if the input is an empty cell
  if (isempty (cellx) || isempty (celly))
    if(isempty (cellx) && isempty (celly))
      vecx=[];
      vecy=[];
    else
      error ('Octave:invalid-input-arg', ...
            "polyjoin: size of arguments are different");
    endif
  endif

  #check dimesions
  if(size(cellx)(1) != size(celly)(1))
    error ('Octave:invalid-input-arg', ...
            "polyjoin: size of arguments are different");
  elseif(size(cellx)(2) != 1 || size(celly)(2) != 1)
    error ('Octave:invalid-input-arg', ...
            "polyjoin: cellx and celly should be of dimension MX1");
  endif
  
  vecx = joinPolygons(cellx);
  vecy = joinPolygons(celly);

        
endfunction

%!test
%! x={[1 2]';[3 4]'}; y={[10 20]';[30 40]'};
%! [vecx,vecy]=polyjoin(x,y);
%! assert (vecx, [1; 2; NaN; 3; 4]);
%! assert (vecy, [10; 20; NaN; 30; 40]);

%!test
%! x={[1;2];[3;4];[3]}; y={[10;20];[30;40];[10]};
%! [vecx,vecy]=polyjoin(x,y);
%! assert (vecx, [1; 2; NaN; 3; 4; NaN; 3]);
%! assert (vecy, [10; 20; NaN; 30; 40; NaN; 10]);

%!test
%! x = {[1 2 3]'; 4; [5 6 7 8 NaN 9]'};
%! y = {[9 8 7]'; 6; [5 4 3 2 NaN 1]'};
%! [vecx,vecy]=polyjoin(x,y);
%! assert (vecx, [1; 2; 3; NaN; 4; NaN; 5; 6; 7; 8; NaN; 9]);
%! assert (vecy, [9; 8; 7; NaN; 6; NaN; 5; 4; 3; 2; NaN; 1]);

