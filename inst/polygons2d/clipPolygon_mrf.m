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
## @deftypefn {Function File}  [@var{outpol}, @var{npol}] = clipPolygon_mrf (@var{inpol}, @var{clippol})
## @deftypefnx {Function File} [@var{outpol}, @var{npol}] = clipPolygon_mrf (@var{inpol}, @var{clippol}, @var{op})
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
##
## Optional output argument @var{npol} indicates the number of output polygons.
##
## Know more about the algorithm by Martinez, Rueda and Feito : http://www4.ujaen.es/~fmartin/bool_op.html
## 
## Created: 2017-06-09

function [outpol, npol] = clipPolygon_mrf (inpoly, clippoly=[], method=1)

  ## Input validation

  if (nargin < 3)
    print_usage ();
  endif

  if(isempty(inpoly) || isempty(clippoly))
    error("clipPolygon_mrf : Empty polygon");
  endif

  if (! isnumeric (inpoly) || size (inpoly, 2) < 2)
    error (" clipPolygon_mrf : inpoly should be a numeric Nx2 array");
  endif

  if (! isnumeric (clippoly) || size (clippoly, 2) < 2)
    error (" clipPolygon_mrf : clippoly should be a numeric Nx2 array");
  elseif (! isnumeric (method) || method < 0 || method > 3)
    error (" clipPolygon_mrf : operation must be a number in the range [0..3]");
  endif

  inpol = __polytostruct__ (inpoly);

  clpol = __polytostruct__ (clippoly);

  ## Perform boolean operation
  [X, Y, npol] = polybool_mrf(inpol, clpol, method);

  if(npol == 0)
    outpol = [ , ];
  else
    outpol = [X Y];
  endif

endfunction

%!test
%! pol1 = [-0.15 -0.15; 0.45 -0.15; 0.15 0.45];
%! pol2 = [-0.05 -0.05; 0.15 0.35; 0.35 -0.05; NaN NaN;
%!          0.05 0.05; 0.25 0.05; 0.15 0.25];
%! opol[0] = [0.15 0.25; 0.05 0.05; 0.25 0.05; NaN NaN;
%!            0.15 0.35; -0.05 -0.05; 0.35 -0.05; NaN NaN;
%!            0.15 0.45; -0.15 -0.15; 0.45 -0.15];
%! npol[0] = 3;
%! opol[1] = [0.15 0.25; 0.05 0.05; 0.25 0.05; NaN NaN;
%!            0.15 0.35; -0.05 -0.05; 0.35 -0.05];
%! npol[1] = 2;
%! opol[2] = [0.15 0.25; 0.05 0.05; 0.25 0.05; NaN NaN;
%!            0.15 0.35; -0.05 -0.05; 0.35 -0.05; NaN NaN;
%!            0.15 0.45; -0.15 -0.15; 0.45 -0.15];
%! npol[2] = 3;
%! opol[3] = [0.15 0.45; -0.15 -0.15; 0.45 -0.15];
%! npol[3] = 1;
%! op   = {"Sub -clip", "AND / Intersection", "Exclusive OR", "OR / Union"};
%! for i=1:numel(op)
%!   [opol npol] = clipPolygon_mrf (pol1, pol2, i-1);
%!   assert([opol npol],[opol[i-1] npol[i-1]]);
%! endfor

%!demo
%! pol1 = [0.15 0.15; 0.55 0.45; 0.15 0.75];
%! pol1a = polygon2patch(pol1);
%! pol2 = [0.35 0.45; 0.75 0.15; 0.75 0.75];
%! pol2a = polygon2patch(pol2);
%! lw = 2;
%! subplot (2, 6, [2 3])
%! patch (pol1a(:, 1), pol1a(:, 2), 'facecolor', 'c', 'edgecolor', 'k', 'linewidth', lw);
%! axis image
%! grid on
%! title ("1. Subject polygon")
%!
%! subplot (2, 6, [4 5])
%! patch (pol1a(:, 1), pol1a(:, 2), 'facecolor', 'c', 'edgecolor', 'none');
%! hold on
%! patch (pol2a(:, 1), pol2a(:, 2), 'facecolor', 'y', 'edgecolor', 'b', 'linewidth', lw);
%! axis image
%! grid on
%! title "2. Clip polygon"
%!
%! op   = {"Sub -clip", "AND / Intersection", "Exclusive OR", "OR / Union"};
%! for i=1:numel(op)
%!   subplot (6, 4, [12 16]+i);
%!   [opol, npol] = clipPolygon_mrf (pol1, pol2, i-1);
%!   opol = polygon2patch (opol);
%!   patch (pol1a(:, 1), pol1a(:, 2), 'facecolor', 'c', 'edgecolor', 'none');
%!   hold on
%!   patch (pol2a(:, 1), pol2a(:, 2), 'facecolor', 'y', 'edgecolor', 'none');
%!   patch (opol(:,1),opol(:,2), 'facecolor', 'g', 'edgecolor', 'r', ...
%!         'linewidth', lw, 'erasemode', 'xor');
%!   axis image
%!   grid on
%!   title (sprintf("%d. %s", i+2, op{i}));
%!   axis off
%! endfor
%!
%! subplot (10, 4, 37);
%!   [opol, npol] = clipPolygon_mrf (pol2, pol1, 0);
%!   opol = polygon2patch (opol);
%!   patch (pol1a(:, 1), pol1a(:, 2), 'facecolor', 'c', 'edgecolor', 'none');
%!   hold on
%!   patch (pol2a(:, 1), pol2a(:, 2), 'facecolor', 'y', 'edgecolor', 'none');
%!   patch (opol(:,1),opol(:,2), 'facecolor', 'g', 'edgecolor', 'r', ...
%!         'linewidth', lw, 'erasemode', 'xor');
%!   axis image
%!   grid on
%!   axis off
%!   title "7. Clip - sub";
