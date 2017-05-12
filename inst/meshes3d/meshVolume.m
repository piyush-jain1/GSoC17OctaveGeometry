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

function vol = meshVolume(vertices, edges, faces)
%MESHVOLUME Volume of the space enclosed by a polygonal mesh
%
%   V = meshVolume(VERTS, FACES)
%   Computes the volume of the space enclosed by the polygonal mesh
%   represented by vertices VERTS (as a Nv-by-3 array of cooridnates) and
%   the array of faces FACES (either as a Nf-by-3 array of vertex indices,
%   or as a cell array of arrays of vertex indices).
%
%   The volume is computed as the sum of the signed volumes of tetrahedra
%   formed by triangular faces and the centroid of the mesh. Faces need to
%   be oriented such that normal points outwards the mesh. See:
%   http://stackoverflow.com/questions/1838401/general-formula-to-calculate-polyhedron-volume
%
%   Example
%     % computes the volume of a unit cube (should be equal to 1...)
%     [v f] = createCube;
%     meshVolume(v, f)
%     ans = 
%         1
%
%   See also
%   meshes3d, meshSurfaceArea, tetrahedronVolume

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2012-10-01,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% HISTORY
% 2013-08-16 speed improvement by Sven Holcombe

% check input number
if nargin == 2
    faces = edges;
end

% ensure mesh has triangle faces
faces = triangulateFaces(faces);

% initialize an array of volume
nFaces = size(faces, 1);
vols = zeros(nFaces, 1);

% Shift all vertices to the mesh centroid
vertices = bsxfun(@minus, vertices, mean(vertices,1));

% compute volume of each tetraedron
for i = 1:nFaces
    % consider the tetrahedron formed by face and mesh centroid
    tetra = vertices(faces(i, :), :);
    
    % volume of current tetrahedron
    vols(i) = det(tetra) / 6;
end

vol = sum(vols);
