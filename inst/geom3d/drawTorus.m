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
## @deftypefn {Function File} {} drawTorus (@var{torus})
## Draw a torus (3D ring)
##
##   drawTorus(TORUS)
##   Draws the torus on the current axis. TORUS is given by
##   [XC YC ZY R1 R2 THETA PHI]
##   where (XC YZ ZC) is the center of the torus, R1 is the main radius, R2
##   is the radius of the torus section, and (THETA PHI) is the angle of the
##   torus normal vector (both in degrees).
##
##   Example
## @example
##   figure;
##   drawTorus([50 50 50 30 10 30 45]);
##   axis equal;
## @end example
##
## @seealso{drawEllipsoid, revolutionSurface}
## @end deftypefn

function varargout = drawTorus(torus, varargin)

  center = torus(1:3);
  r1 = torus(4);
  r2 = torus(5);

  if size(torus, 2) >= 7
      normal = torus(6:7);
  end

  # default drawing options
  varargin = [{'FaceColor', 'g'}, varargin];

  # create base torus
  circle = circleAsPolygon ([r1 0 r2], 60);
  [x y z] = revolutionSurface (circle, linspace(0, 2*pi, 60));

  # transform torus
  trans = localToGlobal3d ([center normal]);
  [x y z] = transformPoint3d (x, y, z, trans);

  # draw the surface
  hs = surf(x, y, z, varargin{:});

  if nargout > 0
      varargout = {hs};
  end

endfunction

%!demo
%!   figure;
%!   drawTorus([50 50 50 30 10 30 45]);
%!   axis square equal;
%!   view(45,40);
