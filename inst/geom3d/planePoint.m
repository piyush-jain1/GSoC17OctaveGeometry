## Copyright (C) 2004-2011 David Legland <david.legland@grignon.inra.fr>
## Copyright (C) 2004-2011 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas)
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

## -*- texinfo -*-
## @deftypefn {Function File} {@var{point} =} planePoint (@var{plane}, @var{pos})
## PLANEPOINT Compute 3D position of a point in a plane
##
##   POINT = planePoint(PLANE, POS)
##   PLANE is a 9 element row vector [x0 y0 z0 dx1 dy1 dz1 dx2 dy2 dz2]
##   POS is the coordinate of a point in the plane basis,
##   POINT is the 3D coordinate in global basis.
##
## @seealso{planes3d, planePosition}
## @end deftypefn

function coord = planePoint (plane, point)

  # check size of input arguments
  npl = size (plane, 1);
  npt = size (point, 1);
  if npl ~= npt && (npl ~= 1 && npt ~= 1)
    error ("geometry:InvalidArgument", ...
           "plane and point should have same size or one of them must have a single row.\n");
  end

  # compute 3D coordinate
  coord = plane(:,1:3) + ...
          plane(:,4:6) .* point(:,1) + ...
          plane(:,7:9) .* point(:,2)

endfunction
