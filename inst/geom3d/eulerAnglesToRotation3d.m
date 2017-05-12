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

%EULERANGLESTOROTATION3D Convert 3D Euler angles to 3D rotation matrix
%
%   MAT = eulerAnglesToRotation3d(PHI, THETA, PSI)
%   Creates a rotation matrix from the 3 euler angles PHI THETA and PSI,
%   given in degrees, using the 'XYZ' convention (local basis), or the
%   'ZYX' convention (global basis). The result MAT is a 4-by-4 rotation
%   matrix in homogeneous coordinates.
%
%   PHI:    rotation angle around Z-axis, in degrees, corresponding to the
%!   'Yaw'. PHI is between -180 and +180.
%   THETA:  rotation angle around Y-axis, in degrees, corresponding to the
%!   'Pitch'. THETA is between -90 and +90.
%   PSI:    rotation angle around X-axis, in degrees, corresponding to the
%!   'Roll'. PSI is between -180 and +180. 
%   These angles correspond to the "Yaw-Pitch-Roll" convention, also known
%   as "Tait–Bryan angles". 
%
%   The resulting rotation is equivalent to a rotation around X-axis by an
%   angle PSI, followed by a rotation around the Y-axis by an angle THETA,
%   followed by a rotation around the Z-axis by an angle PHI. 
%   That is:
%!   ROT = Rz * Ry * Rx;
%
%   MAT = eulerAnglesToRotation3d(ANGLES)
%   Concatenates all angles in a single 1-by-3 array.
%
%   Example
%   [n e f] = createCube;
%   phi     = 20;
%   theta   = 30;
%   psi     = 10;
%   rot = eulerAnglesToRotation3d(phi, theta, psi);
%   n2 = transformPoint3d(n, rot);
%   drawPolyhedron(n2, f);
%
%   See also
%   transforms3d, createRotationOx, createRotationOy, createRotationOz
%   rotation3dAxisAndAngle

function mat = eulerAnglesToRotation3d(phi, theta, psi, varargin)

  % Process input arguments
  if size(phi, 2) == 3
      % manages arguments given as one array
      theta   = phi(:, 2);
      psi     = phi(:, 3);
      phi     = phi(:, 1);
  end

  % create individual rotation matrices
  k = pi / 180;
  rotX = createRotationOx(psi * k);
  rotY = createRotationOy(theta * k);
  rotZ = createRotationOz(phi * k);

  % concatenate matrices
  mat = rotZ * rotY * rotX;

endfunction

%!demo
%! [n e f] = createCube;
%! phi     = 20;
%! theta   = 30;
%! psi     = 10;
%! rot     = eulerAnglesToRotation3d (phi, theta, psi);
%! n2      = transformPoint3d (n, rot);
%! drawPolyhedron (transformPoint3d(n,createTranslation3d([-1 0 0])), f, 'g');
%! drawPolyhedron (n2, f);
%! view (3)
%! axis equal


