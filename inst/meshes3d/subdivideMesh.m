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

function [vertices2, faces2] = subdivideMesh(vertices, faces, n)
%SUBDIVIDEMESH Subdivides each face of the mesh
%
%   [V2 F2] = subdivideMesh(V, F, N)
%   Subdivides the mesh specified by (V,F) such that each face F is divided
%   into N^2 smaller faces.
%
%   Example
%     [v f] = createOctahedron;
%     figure; drawMesh(v, f); view(3);
%     [v2 f2] = subdivideMesh(v, f, 4);
%     figure; drawMesh(v2, f2); view(3)
%
%   See also
%     meshes3d, drawMesh
%

% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2013-08-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.


%% Initialisations

if ~isnumeric(faces) || size(faces, 2) ~= 3
    error('Requires a triangular mesh');
end

% compute the edge array
% edgeVertexIndices = computeMeshEdges(faces);
edges = meshEdges(faces);
nEdges = size(edges, 1);

% index of faces around each edge
% edgeFaceIndices = meshEdgeFaces(vertices, edges, faces);

% index of edges around each face
faceEdgeIndices = meshFaceEdges(vertices, edges, faces);


%% Create new vertices on edges

% several interpolated positions
t = linspace(0, 1, n + 1)';
coef2 = t(2:end-1);
coef1 = 1 - t(2:end-1);

% initialise the array of new vertices
vertices2 = vertices;

% keep an array containing index of new vertices for each original edge
edgeNewVertexIndices = zeros(nEdges, n-1);

% create new vertices on each edge
for iEdge = 1:nEdges
    % extract each extremity as a point
    v1 = vertices(edges(iEdge, 1), :);
    v2 = vertices(edges(iEdge, 2), :);

    % compute new points
    newPoints = coef1 * v1 + coef2 * v2;
    
    % add new vertices, and keep their indices
    edgeNewVertexIndices(iEdge,:) = size(vertices2, 1) + (1:n-1);
    vertices2 = [vertices2 ; newPoints]; %#ok<AGROW>
end


%% Process each face

faces2 = zeros(0, 3);

nFaces = size(faces, 1);
for iFace = 1:nFaces
    % compute index of each corner vertex
    face = faces(iFace, :);
    iv1 = face(1);
    iv2 = face(2);
    iv3 = face(3);
    
    % compute index of each edge
    faceEdges = faceEdgeIndices{iFace};
    ie1 = faceEdges(1);
    ie2 = faceEdges(2);
    ie3 = faceEdges(3);
    
    % indices of new vertices on edges
    edge1NewVertexIndices = edgeNewVertexIndices(ie1, :);
    edge2NewVertexIndices = edgeNewVertexIndices(ie2, :);
    edge3NewVertexIndices = edgeNewVertexIndices(ie3, :);
    
    % keep vertex 1 as reference for edges 1 and 3
    if edges(ie1, 1) ~= iv1
        edge1NewVertexIndices = edge1NewVertexIndices(end:-1:1);
    end
    if edges(ie3, 1) ~= iv1
        edge3NewVertexIndices = edge3NewVertexIndices(end:-1:1);
    end
       
    % create the first new face, on 'top' of the original face
    topVertexInds = [edge1NewVertexIndices(1) edge3NewVertexIndices(1)];
    newFace = [iv1 topVertexInds];
    faces2 = [faces2; newFace]; %#ok<AGROW>
        
    % iterate over middle strips
    for iStrip = 2:n-1
        % index of extreme vertices of current row
        ivr1 = edge1NewVertexIndices(iStrip);
        ivr2 = edge3NewVertexIndices(iStrip);
        
        % extreme vertices as points
        v1 = vertices2(ivr1, :);
        v2 = vertices2(ivr2, :);
        
        % create additional vertices within the bottom row of the strip
        t = linspace(0, 1, iStrip+1)';
        coef2 = t(2:end-1);
        coef1 = 1 - t(2:end-1);
        newPoints = coef1 * v1 + coef2 * v2;

        % compute indices of new vertices in result array
        newInds = size(vertices2, 1) + (1:iStrip-1);
        botVertexInds = [ivr1 newInds ivr2];
        
        % add new vertices
        vertices2 = [vertices2 ; newPoints]; %#ok<AGROW>
        
        % create top faces of current strip
        for k = 1:iStrip-1
            newFace = [topVertexInds(k) botVertexInds(k+1) topVertexInds(k+1)];
            faces2 = [faces2; newFace]; %#ok<AGROW>
        end
        
        % create bottom faces of current strip
        for k = 1:iStrip
            newFace = [topVertexInds(k) botVertexInds(k) botVertexInds(k+1)];
            faces2 = [faces2; newFace]; %#ok<AGROW>
        end
        
        % bottom vertices of current strip are top vertices of next strip
        topVertexInds = botVertexInds;
    end
        
    % for edge 2, keep vertex 2 of the current face as reference
    if edges(ie2, 1) ~= iv2
        edge2NewVertexIndices = edge2NewVertexIndices(end:-1:1);
    end
    
    % consider new vertices together with extremities
    botVertexInds = [iv2 edge2NewVertexIndices iv3];
    
    % create top faces for last strip
    for k = 1:n-1
        newFace = [topVertexInds(k) botVertexInds(k+1) topVertexInds(k+1)];
        faces2 = [faces2; newFace]; %#ok<AGROW>
    end
    
    % create bottom faces for last strip
    for k = 1:n
        newFace = [topVertexInds(k) botVertexInds(k) botVertexInds(k+1)];
        faces2 = [faces2; newFace]; %#ok<AGROW>
    end
    
end















