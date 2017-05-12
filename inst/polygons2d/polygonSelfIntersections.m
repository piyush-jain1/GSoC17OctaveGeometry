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
## @deftypefn {Function File} {@var{pts} = } polygonSelfIntersections (@var{poly})
## @deftypefnx {Function File} {[@var{pts} @var{pos1} @var{pos2}] = } polygonSelfIntersections (@var{poly})
## @deftypefnx {Function File} {[@dots{}] = } polygonSelfIntersections (@dots{},@asis{'tolerance'}, @var{tol})
##   Find-self intersection points of a polygon
##
##   Return the position of self intersection points
##
##   Also return the 2 positions of each intersection point (the position
##   when meeting point for first time, then position when meeting point
##   for the second time).
##
##  Specifies an additional tolerance parameter to decide whether two intersection
##  points should be considered the same, based on their euclidean
##  distance.
##
##   Example
## @example
##       # use a '8'-shaped polygon
##       poly = [10 0;0 0;0 10;20 10;20 20;10 20];
##       polygonSelfIntersections(poly)
##       ans =
##           10 10
## @end example
##
## @seealso{polygons2d, polylineSelfIntersections}
## @end deftypefn

function varargout = polygonSelfIntersections(poly, varargin)

  tol = 1e-14;

  % parse optional arguments
  while length(varargin) > 1
      pname = varargin{1};
      if ~ischar(pname)
          error('Expect optional arguments as name-value pairs');
      end

      if strcmpi(pname, 'tolerance')
          tol = varargin{2};
      else
          error(['Unknown parameter name: ' pname]);
      end
      varargin(1:2) = [];
  end

  % ensure the last point equals the first one
  if sum(abs(poly(end, :)-poly(1,:)) < tol) ~= 2
      poly = [poly; poly(1,:)];
  end

  % compute intersections by calling algo for polylines
  [points, pos1, pos2] = polylineSelfIntersections(poly, 'closed', 'tolerance', tol);

  % It may append that first vertex of polygon is detected as intersection,
  % the following tries to detect this.
  % (pos1 < pos2 by construction)
  n = size(poly, 1) - 1;
  inds = abs(pos1) < tol & abs(pos2 - n) < tol;
  points(inds, :) = [];
  pos1(inds)   = [];
  pos2(inds)   = [];


  %% Post-processing

  % process output arguments
  if nargout <= 1
      varargout = {points};
  elseif nargout == 3
      varargout = {points, pos1, pos2};
  end

endfunction
