## Copyright (C) 2017 - Philip Nienhuis
## Copyright (C) 2017 - Juan Pablo Carbajal
## Copyright (C) 2017 - Piyush Jain
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
## @deffn {} [@var{outpol}, @var{npol}] = clipPolygon (@var{inpol}, @var{clippol}, @var{op})
## @deffnx {} [@var{outpol}, @var{npol}] = clipPolygon (@var{inpol}, @var{clippol}, @var{op}, @var{library})
## @deffnx {} [@var{outpol}, @var{npol}] = clipPolygon (@dots{}, @var{args})
## Perform boolean operation on polygon(s) using one of several algorithms.
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
## Currently @asis{"clipper"}  and @asis{"mrf"} are implemented. Option @asis{"clipper"} uses
## a MEX interface to the Clipper library, option @asis{"mrf"} uses the
## algorithm by Martinez, Rueda and Feito implemented with OCT files.
## Each library interprets polygons as holes differently, refer to the help
## of the specific function to learn how to pass polygons with holes.
##
## Output array @var{outpol} will be an Nx2 array of polygons resulting from
## the requested boolean operation, or in case of just one input argument an
## Nx1 array indicating winding direction of each subpolygon in input argument
## @var{inpol}.
##
## Optional output argument @var{npol} indicates the number of output polygons.
##
## @seealso{clipPolygon_clipper, clipPolygon_mrf, clipPolyline}
## @end deffn

## Author: Philip Nienhuis <prnienhuis@users.sf.net>
## Created: 2017-03-21

function [opol, npol] = clipPolygon (inpol, clipol, op, library = "clipper", varargin)

  switch library

    case 'clipper'
      [opol, npol] = clipPolygon_clipper (inpol, clipol, op, varargin{:});

    case 'mrf'
      [opol, npol] = clipPolygon_mrf (inpol, clipol, op, varargin{:});

    otherwise
      error ('Octave:invalid-fun-call', ...
          "clipPolygon: unimplemented polygon clipping library: '%s'", library);

  endswitch

endfunction

%!error clipPolygon([],[],[],"abracadabra")

%!demo
%! pol1  = [2 2; 6 2; 6 6; 2 6; 2 2; NaN NaN; 3 3; 3 5; 5 5; 5 3; 3 3];
%! pol2  = [1 2; 7 4; 4 7; 1 2; NaN NaN; 2.5 3; 5.5 4; 4 5.5; 2.5 3];
%! lw    = 2;
%!
%! subplot (2, 2, 1)
%! pol = polygon2patch (pol1);
%! patch (pol(:, 1), pol(:, 2), 'facecolor', 'c', 'edgecolor', 'k', 'linewidth', lw);
%! axis image
%! title ("1. Subject polygon")
%! axis off
%!
%! subplot (2, 2, 2)
%! patch (pol(:, 1), pol(:, 2), 'facecolor', 'c', 'edgecolor', 'none');
%! hold on
%! pol = polygon2patch (pol2);
%! patch (pol(:, 1), pol(:, 2), 'facecolor', 'y', 'edgecolor', 'b', 'linewidth', lw);
%! axis image
%! title "2. Clip polygon"
%! axis off
%!
%! algo = {'clipper', 'mrf'};
%! for i = 1:numel (algo)
%!   subplot (2, 2, i+2);
%!   tic
%!   [opol, npol] = clipPolygon (pol1, pol2, 3, 'clipper');
%!   printf("%s took: %f seconds\n", algo{i}, toc);
%!   opol = polygon2patch (opol);
%!   patch (opol(:,1),opol(:,2), 'facecolor', 'g', 'edgecolor', 'r', 'linewidth', lw);
%!   axis image
%!   title (sprintf("Union - %s", algo{i}));
%!   axis off
%! endfor
