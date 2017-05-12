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

%TRANSFORMVECTOR3D Transform a vector with a 3D affine transform
%
%   V2 = transformVector3d(V1, TRANS);
%   Computes the vector obtained by transforming vector V1 with affine
%   transform TRANS.
%   V1 has the form [x1 y1 z1], and TRANS is a [3x3], [3x4], or [4x4]
%   matrix, with one of the forms:
%   [a b c]   ,   [a b c j] , or [a b c j]
%   [d e f]       [d e f k]      [d e f k]
%   [g h i]       [g h i l]      [g h i l]
%                                [0 0 0 1]
%
%   V2 = transformVector3d(V1, TRANS) also works when V1 is a [Nx3xMxEtc]
%   array of double. In this case, V2 has the same size as V1.
%
%   V2 = transformVector3d(X1, Y1, Z1, TRANS);
%   Specifies vectors coordinates in three arrays with same size.
%
%   [X2 Y2 Z2] = transformVector3d(...);
%   Returns the coordinates of the transformed vector separately.
%
%
%   See also:
%   vectors3d, transforms3d, transformPoint3d

function varargout = transformVector3d(varargin)

  if length(varargin)==2      % func(PTS_XYZ, PLANE) syntax
      vIds = 1:2;
  elseif length(varargin)==4  % func(X, Y, Z, PLANE) syntax
      vIds = 1:3;
  end

  % Extract only the linear part of the affine transform
  trans = varargin{vIds(end)};
  trans(1:4, 4) = [0; 0; 0; 1];

  % Call transformPoint3d using equivalent output arguments
  varargout = cell(1, max(1,nargout));
  [varargout{:}] = transformPoint3d(varargin{vIds(1:end-1)}, trans);

endfunction
