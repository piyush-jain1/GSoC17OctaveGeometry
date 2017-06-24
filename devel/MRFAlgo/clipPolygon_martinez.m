## Copyright (C) 2017 - Piyush Jain
## Copyright (C) 2017 - Juan Pablo Carbajal
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program. If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## Perform boolean operation on polygon(s) using one of boolean methods.
##
## @var{inpol} = Nx2 matrix of (X, Y) coordinates constituting the polygons(s)
## to be clipped. Polygons are separated by [NaN NaN] rows. @var{clippol} =
## another Nx2 matrix of (X, Y) coordinates representing the clip polygon(s).
##
## The argument @var{op}, the boolean operation, can be:
##
## @itemize
## @item 0: difference @var{inpol} - @var{clippol}
##
## @item 1: intersection ("AND") of @var{inpol} and @var{clippol} (= default)
##
## @item 2: exclusiveOR ("XOR") of @var{inpol} and @var{clippol}
##
## @item 3: union ("OR") of @var{inpol} and @var{clippol}
## @end itemize
##

## Output array @var{outpol} will be an Nx2 array of polygons resulting from
## the requested boolean operation

## Optional output argument @var{npol} indicates the number of output polygons.

## Created: 2017-06-09


function [outpol, npol] = clipPolygon_martinez (inpoly, clippoly=[], method=1)

  ## Input validation
  if (nargin < 3)
    print_usage ();
  endif
  if(isempty(inpoly) || isempty(clippoly))
    error("clipPolygon_martinez : Empty polygon");
  endif
  if (! isnumeric (inpoly) || size (inpoly, 2) < 2)
    error (" clipPolygon_martinez : inpoly should be a numeric Nx2 array");
  endif
  if (! isnumeric (clippoly) || size (clippoly, 2) < 2)
    error (" clipPolygon_martinez : clippoly should be a numeric Nx2 array");
  elseif (! isnumeric (method) || method < 0 || method > 3)
    error (" clipPolygon_martinez : operation must be a number in the range [0..3]");
  endif

  inpol = __polytostruct__ (inpoly);

  clpol = __polytostruct__ (clippoly);
  
  ## Perform boolean operation
  [X, Y, npol] = polybool_martinez(inpol, clpol, method);
  if(npol == 0)
    outpol = [ , ];
  else
    outpol = [X Y];
  endif


endfunction
