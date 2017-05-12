## Copyright (C) 2004-2011 David Legland
## Copyright (C) 2004-2011 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas)
## Copyright (C) 2012-2017 Adapted to Octave by Juan Pablo Carbajal
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

## Author: David Legland <david.legland@grignon.inra.fr>
## Author: Juan Pablo Carbajal <ajuanpi+dev@gmail.com>


## -*- texinfo -*-
## @deftypefn {} {@var{points} = } intersectLineCircle (@var{line}, @var{circle})
## Intersection point(s) of N lines and N circles
##
##  Returns a 2-by-2-by-N array @var{points}, containing on each row the
##  coordinates of an intersection point for each line-circle pair, i.e.
##  @code{@var{points}(:,:,k)} contains the intersections between @code{@var{line}(k,:)}
##  and @code{@var{circle}(k,:)}.
##  If a line and a circle do not intersect, the result is NA.
##
##  Example:
##  @example
##  # base point
##  center = [10 0];
##  # create vertical line
##  l1 = [center 0 1];
##  # circle
##  c1 = [center 5];
##  pts = intersectLineCircle(l1, c1)
##  pts =
##      10   -5
##      10    5
##  # draw the result
##  figure; clf; hold on;
##  axis([0 20 -10 10]);
##  drawLine(l1);
##  drawCircle(c1);
##  drawPoint(pts, 'rx');
##  axis equal;
##  @end example
##
## @seealso{lines2d, circles2d, intersectLines, intersectCircles}
## @end deftypefn

function points = intersectLineCircle(line, circle)

  n = size (line, 1);
  if (n != size (circle, 1))
    error ('geometry:invalid-input-arg', 'Function takes same number of lines and circles.');
  endif

  # circle parameters
  center = circle(:, 1:2);
  radius = circle(:, 3);

  # line parameters
  dp = line(:, 1:2) - center;
  vl = line(:, 3:4);

  # coefficient of second order equation
  a = sumsq (line(:, 3:4), 2);
  b = 2 * sum (dp .* vl, 2);
  c =  sumsq (dp, 2) - radius.^2;

  # discriminant
  delta    = b .^ 2 - 4 * a .* c;
  nn_delta = delta >= 0; # nonnegative delta
  nnn      = sum (nn_delta);

  points = NA (2, 2, n);

  if (nnn > 0)
    # roots
    u = (-b(nn_delta) + [-1 1] .* sqrt (delta(nn_delta)) )/ 2 ./ a(nn_delta);

    if (n == 1)
      points = [line(1:2) + u(:,1) .* line(3:4); ...
                line(1:2) + u(:,2) .* line(3:4)];
    else
      tmp = [line(nn_delta,1:2) + u(:,1) .* line(nn_delta,3:4) ...
             line(nn_delta,1:2) + u(:,2) .* line(nn_delta,3:4)].';

      points(:,:, nn_delta) = permute (reshape ( tmp, [2,2,nnn]),[2 1 3]);
    endif

  endif

endfunction

%!demo
%! # create a line
%! l1 = [9.5 0 1 1];
%! # circle
%! c1 = [10 0 5];
%! pts = intersectLineCircle (l1, c1)
%! # draw the result
%! figure (1); clf; hold on;
%! axis ([0 20 -10 10]);
%! drawLine (l1);
%! drawCircle (c1);
%! drawPoint (pts, 'rx');
%! axis equal;
%! hold off;

%!shared lin, circ
%! lin  = [0 0 0 1];
%! circ = [0 0 1];

%!assert(intersectLineCircle (lin, circ), [0 -1; 0 1])
%!assert(intersectLineCircle (lin, circ+[2 0 0]), NA(2))
%!assert(intersectLineCircle (lin+[1 0 0 0], circ), [1 0; 1 0])

%!error intersectLineCircle ([lin; 0 0 1 0], circ)
%!error intersectLineCircle (lin, [circ; 0 1 1])

%!test
%! res(1:2, 1:2, 1) = [0 -1; 0 1];
%! res(1:2, 1:2, 2) = [2 -1; 2 1];
%! res(1:2, 1:2, 3) = NA (2);
%! res(1:2, 1:2, 4) = [-3 -1; -3 1];
%! l2 = [lin; lin+[2 0 0 0; 0 0 0 0; -3 0 0 0]];
%! c2 = [circ; circ+[2 0 0; -2 0 0; -3 0 0]];
%! assert (intersectLineCircle (l2, c2), res);
