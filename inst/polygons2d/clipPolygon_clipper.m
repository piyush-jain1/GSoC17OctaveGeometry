## Copyright (C) 2015-2017 Philip Nienhuis
##
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File}  [@var{outpol}, @var{npol}] = clipPolygon_clipper (@var{inpol}, @var{clippol})
## @deftypefnx {Function File} [@var{outpol}, @var{npol}] = clipPolygon_clipper (@var{inpol}, @var{clippol}, @var{op})
## @deftypefnx {Function File} [@var{outpol}, @var{npol}] = clipPolygon_clipper (@var{inpol}, @var{clippol}, @var{op}, @var{rules}, @var{rulec})
## Perform boolean operation on polygon(s) using one of boolean methods.
##
## @var{inpol} = Nx2 matrix of (X, Y) coordinates constituting the polygons(s)
## to be clipped.  Polygons are separated by [NaN NaN] rows.  @var{clippol} =
## another Nx2 matrix of (X, Y) coordinates representing the clip polygon(s).
##
## Optional argument @var{op}, the boolean operation, can be:
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
## In addition a rule can be specified to instruct polyclip how to assess
## holes, or rather, how to assess polygon fill.  This works as follows: start
## with a winding number of zero (0).  From a point outside all polygons
## specified in @var{INPOL}, go to the center of the innermost polygon and note
## which polygons are crossed.  For each polygon boundary crossing from right
## to left, increase the winding number, while for each polygon crossing from
## left to right, decrement it, and then assign it to the crossed polygon.
## @var{rules} and @var{rulec} can be set individually for subject and clip
## polygons, respectively, as follows:
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
## Output array @var{outpol} will be an Nx2 array of polygons resulting from
## the requested boolean operation, or in case of just one input argument an
## Nx1 array indicating winding direction of each subpolygon in input argument
## @var{inpol}.
## @end deftypefn

## Author: Philip Nienhuis <prnienhuis@users.sf.net>
## Created: 2015-05-03
## Based on Clipper library, polyclipping.sf.net, 3rd Party, Matlab

function [outpoly, npol] = clipPolygon_clipper (inpoly, clippoly=[], method=1, rules=0, rulec=0)

  ## Input validation
  if (nargin < 3)
    print_usage ();
  endif
  if (! isnumeric (inpoly) || size (inpoly, 2) < 2)
    error (" clipPolygon: inpoly should be a numeric Nx2 array");
  endif
  if (! isnumeric (clippoly) || size (clippoly, 2) < 2)
    error (" clipPolygon: clippoly should be a numeric Nx2 array");
  elseif (! isnumeric (method) || method < 0 || method > 3)
    error (" clipPolygon: operation must be a number in the range [0..3]");
  elseif (! isnumeric (rules) || ! isnumeric (rulec) || rules < 0 || rulec < 0)
    error (" clipPolygon: fill type rules must be nummbers in range [0..3]");
  endif

  [inpol, xy_mean, xy_magn] = __dbl2int64__ (inpoly, clippoly);

  clpol = __dbl2int64__ (clippoly, [], xy_mean, xy_magn);

  ## Perform boolean operation
  outpol = clipper (inpol, clpol, method, rules, rulec);
  npol = numel (outpol);

  if (! isempty (outpol))
    ## Morph struct output into [X,Y] array. Put NaNs between sub-polys. First X:
    [tmp(1:2:2*npol, 1)] = deal ({outpol.x});
    [tmp(2:2:2*npol, 1)] = ...
                cellfun (@(x) [x(1); NaN], tmp(1:2:2*npol, 1), "uni", 0);
    ## Convert back from in64 into double, wipe trailing NaN
    X = double (cell2mat (tmp))(1:end-1);
    ## Y-coordinates:
    [tmp(1:2:2*npol, 1)] = deal ({outpol.y});
    [tmp(2:2:2*npol, 1)] = ...
                cellfun (@(y) [y(1); NaN], tmp(1:2:2*npol, 1), "uni", 0);
    Y = double (cell2mat (tmp))(1:end-1);

    outpoly = ([X Y] / xy_magn) + xy_mean;
  else
    outpoly = zeros (0, 2);
  endif

endfunction
