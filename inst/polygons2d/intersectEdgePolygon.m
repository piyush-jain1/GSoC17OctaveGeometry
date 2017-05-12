## Copyright (C) 2004-2016 David Legland <david.legland@grignon.inra.fr>
## Copyright (C) 2004-2016 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas)
## Copyright (C) 2016 Adapted to Octave by Juan Pablo Carbajal <ajuanpi+dev@gmail.com>
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

%INTERSECTEDGEPOLYGON  Intersection point of an edge with a polygon
%
%   INTER = intersectEdgePolygon(EDGE, POLY)
%   Computes intersection(s) point(s) between the edge EDGE and the polygon
%   POLY. EDGE is given by [x1 y1 x2 y2]. POLY is a N-by-2 array of vertex
%   coordinates.
%   INTER is a M-by-2 array containing coordinates of intersection(s). It
%   can be empty if no intersection is found.
%
%   [INTER INDS] = intersectEdgePolygon(EDGE, POLY)
%   Also returns index/indices of edge(s) involved in intersections.
%
%   Example
%   % Intersection of an edge with a square
%     poly = [0 0;10 0;10 10;0 10];
%     edge = [9 2 9+3*1 2+3*2];
%     exp = [10 4];
%     inter = intersectEdgePolygon(edge, poly)
%     ans =
%         10   4
%
%   See also
%   edges2d, polygons2d, intersectLinePolygon, intersectRayPolygon
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-02-24,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

function [intersects, inds] = intersectEdgePolygon(edge, poly, varargin)

  % get computation tolerance
  tol = eps;
  if ~isempty(varargin)
      tol = varargin{1};
  end

  line = edgeToLine(edge);

  [intersects, inds] = intersectLinePolygon(line, poly, tol);

  if ~isempty(intersects)
      pos = linePosition(intersects, line);
      keep = pos >= 0 & pos <= 1;
      intersects = intersects(keep, :);
      inds = inds(keep);
  end

endfunction
