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
## @deftypefn {Function File} {@var{point} =} circle3dPoint (@var{circle},@var{pos})
## Coordinates of a point on a 3D circle from its position
##
##
##   Example
## @example
##   circle = [0 0 0 1 45 45 0];
##   # Draw some points on a 3D circle
##     figure; hold on;
##     # origin point
##     pos1 = 0;
##     drawPoint3d(circle3dPoint(circle, pos1), 'ro')
##     # few points regularly spaced
##     for i = 10:10:40
##         drawPoint3d(circle3dPoint(circle, i))
##     end
##     # Draw point opposite to origin
##     drawPoint3d(circle3dPoint(circle, 180), 'k*')
## @end example
##
## @seealso{circles3d, circle3dPosition}
## @end deftypefn

function point = circle3dPoint(circle, pos)

  # extract circle coordinates
  xc  = circle(1);
  yc  = circle(2);
  zc  = circle(3);
  r   = circle(4);

  theta   = circle(5);
  phi     = circle(6);
  psi     = circle(7);

  # convert position to angle
  t = pos * pi / 180;

  # compute position on base circle
  x   = r * cos(t);
  y   = r * sin(t);
  z   = 0;
  pt0 = [x y z];

  # compute transformation from local basis to world basis
  trans   = localToGlobal3d (xc, yc, zc, theta, phi, psi);

  # compute points of transformed circle
  point   = transformPoint3d (pt0, trans);

endfunction

%!demo
%!  # Draw some points on a 3D circle
%!  circle = [0 0 0 1 45 45 0];
%!  figure;
%!
%!  drawCircle3d(circle);
%!  hold on;
%!
%!  # origin point
%!  pos1 = 0;
%!  drawPoint3d(circle3dPoint(circle, pos1), 'go')
%!  # few points regularly spaced
%!  for i = 10:10:90
%!     drawPoint3d(circle3dPoint(circle, i))
%!  end
%!  # Draw point opposite to origin
%!  drawPoint3d(circle3dPoint(circle, 180), 'k*')
%!  axis square equal;
%!  view(70,30)
