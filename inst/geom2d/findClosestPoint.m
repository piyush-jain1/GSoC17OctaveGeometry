## Copyright (C) 2004-2015 David Legland <david.legland@grignon.inra.fr>
## Copyright (C) 2004-2015 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas)
## Copyright (C) 2016 Adapted to Octave by Juan Pablo Carbajal <ajuanpi+dev@gmail.com>
## All rights reserved.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
##     1 Redistributions of source code must retain the above copyright notice,
##       this list of conditions and the following disclaimer.
##     2 Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in the
##       documentation and/or other materials provided with the distribution.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ''AS IS''
## AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
## ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
## ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
## DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
## SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
## CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
## OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
## OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## -*- texinfo -*-
## @deftypefn {Function File} {[@var{index}, @var{mindist}] =} findClosestPoint (@var{point}, @var{pointarray})
## Find index of closest point in an array and the distance between @var{point} and closest point in @var{pointarray}.
##
## Example:
##@example
##  pts = rand(10, 2);
##  findClosestPoint(pts(4, :), pts)
##  ans =
##       4
##@end example
## @seealso{points2d, minDistancePoints, distancePoints}
## @end deftypefn

function [index, minDist] = findClosestPoint(coord, points)

  % number of point in first input to process
  np = size (coord, 1);

  % allocate memory for result
  index   = zeros (np, 1);
  minDist = zeros (np, 1);

  for i = 1:np
      % compute squared distance between current point and all point in array
      dist = sumsq (coord(i,:) - points, 2);

      % keep index of closest point
      [minDist(i), index(i)] = min(dist);
  endfor
endfunction

%!demo
%! pts = rand (10, 2);
%! pt  = rand (1, 2);
%! [idx d] = findClosestPoint (pt, pts);
%! printf ("Point (%g,%g).\n", pt);
%! printf ("The %dth is the closest point (%g,%g).\n", idx, pts(idx,:));
%! printf ("The distance between them is %g.\n", d);
