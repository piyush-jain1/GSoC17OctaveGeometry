## Copyright (C) 2016 - Juan Pablo Carbajal
## Copyright (C) 2016 - Piyush Jain
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
## @deftypefn {} {@var{ccw} =} ispolycw (@var{p})
## @deftypefnx {} {@var{ccw} =} ispolycw (@var{px}, @var{py})
## Returns true if the polygon @var{p} are oriented Clockwise.
##
## @var{p} is a N-by-2 array containing coordinates of vertices. The coordinates
## of the vertices of the polygon can also be given as two N-by-1 arrways
## @var{px}, @var{py}.
##
## If polygon is self-crossing, the result is undefined.
##
## If the polygon contains holes only the outer polygon is considered.
##
## If @var{points} is a cell, each element is considered a polygon, the
## resulting @var{cw} array has the same shape as the cell.
##
## @seealso{polygonArea}
## @end deftypefn

function cw = ispolycw (px, py)

  if iscell (px)
    cw = cellfun (@ispolycw, px);
  else
    
    if nargin == 2;
      px = [px py];
    end
    
    px = reshape(px, numel(px)/2, 2);

    # Remove holes
    if any ( isnan (px) )
      px = splitPolygons (px);
      px = px{1};
    end

    cw = polygonArea (px) < 0;

  end
end

%!shared pccw, pcw, ph
%! pccw = pcw = [0 0; 1 0; 1 1; 0 1];
%! pcw([2 4],:) = pcw([4 2], :);
%! ph = [pccw; nan(1,2); 0.5*pcw+[0.25 0.25]];

%!assert (~ispolycw (pccw));
%!assert (ispolycw (pcw));
%!assert (ispolycw ({pccw;pcw}), [false; true]);
%!assert (~ispolycw(ph))
%!assert (ispolycw({ph,pccw}),[false, false])

%!test
%! phcw = [pcw; nan(1,2); 0.5*pccw+[0.25 0.25]];
%! assert (ispolycw(phcw))
