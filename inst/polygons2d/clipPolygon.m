## Copyright (C) 2017 Philip Nienhuis
##
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program. If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} [@var{outpol}, @var{npol}] = clipPolygon (@var{inpol}, @var{clippol}, @var{op})
## @deftypefnx {Function File} [@var{outpol}, @var{npol}] = clipPolygon (@var{inpol}, @var{clippol}, @var{op}, @var{library})
## @deftypefnx {Function File} [@var{outpol}, @var{npol}] = clipPolygon (@dots{}, @var{args})
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
## The optional argument @var{library} specifies which library to use for clipping.
## Currently only @asis{"clipper"} is implemented.
##
## Output array @var{outpol} will be an Nx2 array of polygons resulting from
## the requested boolean operation, or in case of just one input argument an
## Nx1 array indicating winding direction of each subpolygon in input argument
## @var{inpol}.
##
## Optional output argument @var{npol} indicates the number of output polygons.
##
## The optional input arguments @var{args} are used to pass additonal arguments to the
## underlying library. Clipper library allows a rule to be specified about
## how to assess holes, or rather, how to assess polygon fill. This works as
## follows: start with a winding number of zero (0). From a point outside all
## polygons specified in @var{INPOL}, go to the center of the innermost
## polygon and note which polygons are crossed. For each polygon boundary
## crossing from right to left, increase the winding number, while for each
## polygon crossing from left to right, decrement it, and then assign it to
## the crossed polygon.
## By passing two extra arguments @var{rules} and @var{rulec} the user can be
## set rules individually for subject and clip polygons, respectively, as follows:
##
## @itemize
## @item 0 Even-Odd, also called Alternate (= default):
## The first polygon crossed specifies the outer boundary of a filled polygon,
## the next polygon (if present) specifies the inner boundary of that filled
## polygon, and so on. Winding direction (clockwise or counterclockwise) is
## irrelevant here.
##
## @item 1 Non-Zero:
## All polygons with a non-zero winding number are filled.
##
## @item 2 Positive:
## All polygons with a winding number > 0 are filled. This is the usual setting
## for counterclockwise polygons to be the outer, and clockwise polygons to be
## the inner boundary ("holes") of complex polygons.
##
## @item 3 Negative:
## All polygons with a winding number < 0 are filled.
## @end itemize
## (for details see
## http://www.angusj.com/delphi/clipper/documentation/Docs/Units/ClipperLib/Types/PolyFillType.htm
##
##
## @seealso{clipPolygon_clipper, clipPolyline}
## @end deftypefn

## Author: Philip Nienhuis <prnienhuis@users.sf.net>
## Created: 2017-03-21

function [opol, npol] = clipPolygon (inpol, clipol, op, library = "clipper", varargin)

  if ~(ismember (tolower (library), {"clipper"}))
    error ('Octave:invalid-fun-call', "clipPolygon: unimplemented polygon clipping library: '%s'", library);
  endif
 [opol, npol] = clipPolygon_clipper (inpol, clipol, op, varargin{:});

endfunction

%!demo
%! pol1 = [2 2; 6 2; 6 6; 2 6; 2 2; NaN NaN; 3 3; 3 5; 5 5; 5 3; 3 3];
%! pol1a = [2 6; 2 2; 3 3; 3 5; 5 5; 5 3; 3 3; 2 2; 6 2; 6 6; 2 6];
%! pol2 = [1 2; 7 4; 4 7; 1 2; NaN NaN; 2.5 3; 5.5 4; 4 5.5; 2.5 3];
%! pol2a = [1 2; 7 4; 4 7; 1 2; 2.5 3; 4 5.5; 5.5 4; 2.5 3; 1 2];
%! lw = 2;
%!
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
%!   [opol, npol] = clipPolygon (pol1, pol2, i-1);
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
%!   [opol, npol] = clipPolygon (pol2, pol1, 0);
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
