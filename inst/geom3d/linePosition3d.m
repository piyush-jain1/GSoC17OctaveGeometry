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

%LINEPOSITION3D Return the position of a 3D point projected on a 3D line
%
%   T = linePosition3d(POINT, LINE)
%   Computes position of point POINT on the line LINE, relative to origin
%   point and direction vector of the line.
%   LINE has the form [x0 y0 z0 dx dy dy],
%   POINT has the form [x y z], and is assumed to belong to line.
%   The result T is the value such that POINT = LINE(1:3) + T * LINE(4:6).
%   If POINT does not belong to LINE, the position of its orthogonal
%   projection is computed instead. 
%
%   T = linePosition3d(POINT, LINES)
%   If LINES is an array of NL lines, return NL positions, corresponding to
%   each line.
%
%   T = linePosition3d(POINTS, LINE)
%   If POINTS is an array of NP points, return NP positions, corresponding
%   to each point.
%
%   See also:
%   lines3d, createLine3d, distancePointLine3d, projPointOnLine3d

function pos = linePosition3d(point, line)

  % vector from line origin to point
  dp = bsxfun(@minus, point, line(:,1:3));

  % direction vector of the line
  vl = line(:, 4:6);

  % precompute and check validity of denominator
  denom = sum(vl.^2, 2);
  invalidLine = denom < eps;
  denom(invalidLine) = 1;

  % compute position using dot product normalized with norm of line vector.
  pos = bsxfun(@rdivide, sum(bsxfun(@times, dp, vl), 2), denom);

  % position on a degenerated line is set to 0
  pos(invalidLine) = 0;

endfunction
