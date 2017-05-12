## Copyright (C) 2004-2011 David Legland <david.legland@grignon.inra.fr>
## Copyright (C) 2004-2011 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas)
## Copyright (C) 2012-2016 Juan Pablo Carbajal <ajuanpi+dev@gmail.com>
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
## @deftypefn {Function File} {@var{area} = } polygonArea (@var{points})
## @deftypefnx {Function File} {@var{area} = } polygonArea (@var{px},@var{py})
## Compute the signed area of a polygon.
##
## Compute area of a polygon defined by @var{points}. @var{points} is a N-by-2
## matrix containing coordinates of vertices. The coordinates of the vertices of
## the polygon can also be given as two N-by-1 arrways @var{px}, @var{py}.
##
## Vertices of the polygon are supposed to be oriented Counter-Clockwise
## (CCW). In this case, the signed area is positive.
## If vertices are oriented Clockwise (CW), the signed area is negative.
##
## If polygon is self-crossing, the result is undefined.
##
## If the polygon contains holes the result is well defined only when the outer
## polygon is oriented CCW and the holes are oriented CW. In this case the
## resulting are is the sum of the signed areas.
##
## If @var{points} is a cell, each element is considered a polygon and the area
## of each one is returned in the array @var{area}. The matrix has the same shape
## as the cell.
##
## References:
## Algorithm adapted from P. Bourke web page
## http://paulbourke.net/geometry/polygonmesh/
##
## @seealso{polygons2d, polygonCentroid, drawPolygon}
## @end deftypefn

function A = polygonArea(px, py)

  # in case of polygon sets, computes several areas
  if iscell (px)
     A = cellfun (@func, px);
  else

    if (nargin == 2)
      px = [px py];
    end
    A = func (px);
  end

endfunction

function a = func (c)

  if (any (isnan (c)) )
    cc = splitPolygons (c);
    a  = cellfun (@func, cc);
    a  = sum (a);
  else
    N = size (c, 1);
    if (N < 3)
      a = 0;
    else
      iNext = [2:N 1];
      a     = sum (c(:,1) .* c(iNext,2) - c(iNext,1) .* c(:,2)) / 2;
    end
  end

endfunction

%!shared pccw, pcw
%! pccw = pcw = [0 0; 1 0; 1 1; 0 1];
%! pcw([2 4],:) = pcw([4 2], :);

%!assert (polygonArea (1, 0), 0);
%!assert (polygonArea ([1 0 ;1 1]), 0);
%!assert (polygonArea ([1; 1], [0; 1]), 0);

%!assert (polygonArea (pccw), 1);
%!assert (polygonArea (pcw), -1);
%!assert (polygonArea ({pccw;pcw}), [1;-1]);
%!assert (polygonArea ({pccw,pcw}), [1,-1]);

%!assert (polygonArea([pccw; nan(1,2); 0.5*pcw+[0.25 0.25]]), 0.75)
%!test
%! ph = [pccw; nan(1,2); 0.5*pcw+[0.25 0.25]];
%! ph = {ph;ph};
%! assert (polygonArea(ph), [0.75; 0.75])
