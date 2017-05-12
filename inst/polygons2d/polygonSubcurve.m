## Copyright (C) 2003-2011 David Legland <david.legland@grignon.inra.fr>
## Copyright (C) 2012 Adapted to Octave by Juan Pablo Carbajal <carbajal@ifi.uzh.ch>
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
##
## The views and conclusions contained in the software and documentation are
## those of the authors and should not be interpreted as representing official
## policies, either expressed or implied, of the copyright holders.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{poly2} =} polygonSubcurve (@var{polygon}, @var{pos0},@var{pos1})
## Extract a portion of a polygon
##
##   Create a new polyline, by keeping vertices located between positions
##   @var{pos0} and @var{pos1}, and adding points corresponding to positions @var{pos0} and
##   @var{pos1} if they are not already vertices.
##
##   Example:
## @example
## Nv    = 100;
## poly  = circleAsPolygon ([10 20 30], Nv);
## poly2 = polygonSubcurve (poly, 15, 65);
## drawPolyline (poly2);
## @end example
##
## @seealso{polygons2d, polylineSubcurve}
## @end deftypefn

function res = polygonSubcurve(poly, t0, t1)
  # number of vertices
  Nv = size(poly, 1);

  if t0<t1
      # format positions
      t0 = max(t0, 0);
      t1 = min(t1, Nv);
  end

  # indices of extreme vertices inside subcurve
  ind0 = ceil(t0)+1;
  ind1 = floor(t1)+1;

  # get the portion of polyline between 2 extremities
  if t0<t1
      if ind1<=Nv
          res = poly(ind0:ind1, :);
      else
          res = poly(1, :);
      end
  else
      res = poly([ind0:end 1:ind1], :);
  end

  # add first point if it is not already a vertex
  if t0~=ind0-1
      res = [polygonPoint(poly, t0); res];
  end

  # add last point if it is not already a vertex
  if t1~=ind1-1
      res = [res; polygonPoint(poly, t1)];
  end
endfunction

%!demo
%! Nv    = 100;
%! poly  = circleAsPolygon ([10 20 30], Nv);
%! poly2 = polygonSubcurve (poly, 15, 65);
%!
%! drawPolygon (poly,'k-o',"MarkerSize",3);
%! hold on
%! drawPolyline (poly2,'r.',"linewidth",2);
%! hold off
%! axis square
