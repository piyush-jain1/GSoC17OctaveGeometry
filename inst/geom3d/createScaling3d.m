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
## @deftypefn {Function File} {@var{trans} =} createScaling3d (@var{s})
## @deftypefnx {Function File} {@var{trans} =} createScaling3d (@var{sx}, @var{sy}, @var{sz})
## Create the 4x4 matrix of a 3D scaling
##
##   TRANS = createScaling3d(S);
##   returns the scaling transform corresponding to a scaling factor S in
##   each direction. S can be a scalar, or a 1x3 vector containing the
##   scaling factor in each direction.
##
##   TRANS = createScaling3d(SX, SY, SZ);
##   returns the scaling transform corresponding to a different scaling
##   factor in each direction.
##
##   The returned matrix has the form :
## @group
##   [SX  0  0  0]
##   [ 0 SY  0  0]
##   [ 0  0 SZ  0]
##   [ 0  0  0  0]
## @end group
##
## @seealso{transforms3d, transformPoint3d, transformVector3d, createTranslation3d,
## createRotationOx, createRotationOy, createRotationOz}
## @end deftypefn

function trans = createScaling3d(varargin)

  # process input parameters
  if isempty(varargin)
      # assert uniform scaling in each direction
      sx = 1;
      sy = 1;
      sz = 1;
  elseif length(varargin)==1
      # only one argument
      var = varargin{1};
      if length(var)==1
          # same scaling factor in each direction
          sx = var;
          sy = var;
          sz = var;
      elseif length(var)==3
          # scaling is a vector, giving different scaling in each direction
          sx = var(1);
          sy = var(2);
          sz = var(3);
      else
          error('wrong size for first parameter of "createScaling3d"');
      end
  elseif length(varargin)==3
      # 3 arguments, giving scaling in each direction
      sx = varargin{1};
      sy = varargin{2};
      sz = varargin{3};
  else
      error('wrong number of arguments for "createScaling3d"');
  end

  # create the scaling matrix
  trans = [sx 0 0 0;0 sy 0 0;0 0 sz 0;0 0 0 1];

endfunction
