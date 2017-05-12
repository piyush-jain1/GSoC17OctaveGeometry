## Copyright (C) 2003-2017 David Legland
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
## 
## The views and conclusions contained in the software and documentation are
## those of the authors and should not be interpreted as representing official
## policies, either expressed or implied, of the copyright holders.

function [points, pos, faceInds] = intersectLineMesh3d(line, vertices, faces, varargin)
%INTERSECTLINEMESH3D Intersection points of a 3D line with a mesh
%
%   INTERS = intersectLineMesh3d(LINE, VERTICES, FACES)
%   Compute the intersection points between a 3D line and a 3D mesh defined
%   by vertices and faces.
%
%   [INTERS, POS, INDS] = intersectLineMesh3d(LINE, VERTICES, FACES)
%   Also returns the position of each intersection point on the input line,
%   and the index of the intersected faces.
%   If POS > 0, the point is also on the ray corresponding to the line. 
%   
%   Example
%     [V, F] = createCube;
%     line = [.2 .3 .4 1 0 0];
%     pts = intersectLineMesh3d(line, V, F)
%     pts =
%         1.0000    0.3000    0.4000
%              0    0.3000    0.4000
%
%   See also
%   meshes3d, triangulateFaces, intersectLineTriangle3d
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% tolerance for detecting if a point is 
tol = 1e-12;
if ~isempty(varargin)
    tol = varargin{1};
end


% ensure the mesh has triangular faces
tri2Face = [];
if iscell(faces) || size(faces, 2) ~= 3
    [faces, tri2Face] = triangulateFaces(faces);
end

% find triangle edge vectors
t0  = vertices(faces(:,1), :);
u   = vertices(faces(:,2), :) - t0;
v   = vertices(faces(:,3), :) - t0;

% triangle normal
n   = normalizeVector3d(vectorCross3d(u, v));

% direction vector of line
dir = line(4:6);

% vector between triangle origin and line origin
w0 = bsxfun(@minus, line(1:3), t0);

a = -dot(n, w0, 2);
b = dot(n, repmat(dir, size(n, 1), 1), 2);

valid = abs(b) > tol & vectorNorm3d(n) > tol;

% compute intersection point of line with supporting plane
% If pos < 0: point before ray
% IF pos > |dir|: point after edge
pos = a ./ b;

% coordinates of intersection point
points = bsxfun(@plus, line(1:3), bsxfun(@times, pos, dir));


%% test if intersection point is inside triangle

% normalize direction vectors of triangle edges
uu  = dot(u, u, 2);
uv  = dot(u, v, 2);
vv  = dot(v, v, 2);

% coordinates of vector v in triangle basis
w   = points - t0;
wu  = dot(w, u, 2);
wv  = dot(w, v, 2);

% normalization constant
D = uv.^2 - uu .* vv;

% test first coordinate
s = (uv .* wv - vv .* wu) ./ D;
% ind1 = s < 0.0 | s > 1.0;
ind1 = s < -tol | s > (1.0 + tol);
points(ind1, :) = NaN;
pos(ind1) = NaN;

% test second coordinate, and third triangle edge
t = (uv .* wu - uu .* wv) ./ D;
% ind2 = t < 0.0 | (s + t) > 1.0;
ind2 = t < -tol | (s + t) > (1.0 + tol);
points(ind2, :) = NaN;
pos(ind2) = NaN;

% keep only interesting points
inds = ~ind1 & ~ind2 & valid;
points = points(inds, :);

pos = pos(inds);
faceInds = find(inds);

% convert to face indices of original mesh
if ~isempty(tri2Face)
    faceInds = tri2Face(faceInds);
end
