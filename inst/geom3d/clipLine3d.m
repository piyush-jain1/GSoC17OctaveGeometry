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

%CLIPLINE3D Clip a line with a box and return an edge
%
%   EDGE = clipLine3d(LINE, BOX);
%   Clips the line LINE with the bounds given in BOX, and returns the
%   corresponding edge. 
%
%   If the line lies totally outside of the box, returns a 1-by-6 row array
%   containing only NaN's.
%
%   If LINE is a N-by-6 array, with one line by row, returns the clipped
%   edge coresponding to each line in a N-by-6 array.
%
%   See also:
%   lines3d, edges3d, createLine3d

function edge = clipLine3d(line, box)

  % get box limits
  xmin = box(1); xmax = box(2);
  ymin = box(3); ymax = box(4);
  zmin = box(5); zmax = box(6);

  % extreme corners of the box
  p000 = [xmin ymin zmin];
  p111 = [xmax ymax zmax];

  % main vectors
  ex   = [1 0 0];
  ey   = [0 1 0];
  ez   = [0 0 1];

  % box faces parallel to Oxy
  planeZ0 = [p000 ex ey];
  planeZ1 = [p111 ex ey];

  % box faces parallel to Oxz
  planeY0 = [p000 ex ez];
  planeY1 = [p111 ex ez];

  % box faces parallel to Oyz
  planeX0 = [p000 ey ez];
  planeX1 = [p111 ey ez];

  % number of lines
  Nl = size(line, 1);

  % allocate memory for result
  edge = zeros(Nl, 6);


  % process each line
  for i=1:Nl
      
      % compute intersection point with each plane
      ipZ0 = intersectLinePlane(line(i,:), planeZ0);
      ipZ1 = intersectLinePlane(line(i,:), planeZ1);
      ipY0 = intersectLinePlane(line(i,:), planeY0);
      ipY1 = intersectLinePlane(line(i,:), planeY1);
      ipX1 = intersectLinePlane(line(i,:), planeX1);
      ipX0 = intersectLinePlane(line(i,:), planeX0);

      % concatenate resulting points
      points  = [ipX0;ipX1;ipY0;ipY1;ipZ0;ipZ1];

      % compute position of each point on the line
      pos     = linePosition3d(points, line(i,:));

      % keep only defined points
      ind     = find(~isnan(pos));
      pos     = pos(ind);
      points  = points(ind,:);

      % sort points with respect to their position
      [pos, ind] = sort(pos); %#ok<ASGLU>
      points  = points(ind, :);

      % keep median points wrt to position. These points define the limit of
      % the clipped edge.
      nv      = length(ind)/2;

      % create resulting edge.
      edge(i,:)   = [points(nv, :) points(nv+1, :)];
  end

  % check that middle point of the edge is contained in the box
  midX = mean(edge(:, [1 4]), 2);
  xOk  = xmin <= midX & midX <= xmax;
  midY = mean(edge(:, [2 5]), 2);
  yOk  = ymin <= midY & midY <= ymax;
  midZ = mean(edge(:, [3 6]), 2);
  zOk  = zmin <= midZ & midZ <= zmax;

  % if one of the bounding condition is not met, set edge to NaN
  edge (~(xOk & yOk & zOk), :) = NaN;

endfunction
