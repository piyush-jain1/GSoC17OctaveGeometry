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

function [vertices, faces] = readMesh_off(fileName)
%READMESH_OFF Read mesh data stord in OFF format
%
%   [VERTICES FACES] = readMesh_off(FILNAME)
%
%   Example
%   readMesh_off
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% open file
f = fopen(fileName, 'r');
if f == -1 
    error('matGeom:readMesh_off:FileNotFound', ...
        ['Could not find file: ' fileName]);
end

% check format
line = fgets(f);   % -1 if eof
if ~strcmp(line(1:3), 'OFF')
    error('matGeom:readMesh_off:FileFormatError', ...
        'Not a valid OFF file');    
end

% number of faces and vertices
line = fgets(f);
vals = sscanf(line, '%d %d');
nv = vals(1);
nf = vals(2);


% read vertex data
[vertices, count] = fscanf(f, '%f ', [3 nv]);
if count ~= nv*3
    error('matGeom:readMesh_off:FileFormatError', ...
        ['Could not read all the ' num2str(nv) ' vertices']);
end
vertices = vertices';

% read face data (face start by index)
[faces, count] = fscanf(f, '%d %d %d %d\n', [4 nf]);
if count ~= nf * 4
    error('matGeom:readMesh_off:FileFormatError', ...
        ['Could not read all the ' num2str(nf) ' faces']);
end

% clean up: remove index, and use 1-indexing
faces = faces(2:4, :)' + 1;

% close the file
fclose(f);

