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
## @deftypefn {Function File} {@var{cyl} =} cart2cyl (@var{point})
## @deftypefnx {Function File} {@var{cyl} =} cart2cyl (@var{x}, @var{y}, @var{z})
##  Convert cartesian to cylindrical coordinates
##
##   CYL = cart2cyl(POINT)
##   convert the 3D cartesian coordinates of points POINT (given by [X Y Z]
##   where X, Y, Z have the same size) into cylindrical coordinates CYL,
##   given by [THETA R Z].
##   THETA is the arctangent of the ratio Y/X (between 0 and 2*PI)
##   R     can be computed using sqrt(X^2+Y^2)
##   Z     keeps the same value.
##   The size of THETA, and R is the same as the size of X, Y and Z.
##
##   CYL = cart2cyl(X, Y, Z)
##   provides coordinates as 3 different parameters
##
##   Example
## @example
##   cart2cyl([-1 0 2])
##   gives : 4.7124    1.0000     2.0000
## @end example
##
## @seealso{agles3d, cart2pol, cart2sph2}
## @end deftypefn

function varargout = cart2cyl(varargin)

  # process input parameters
  if length(varargin)==1
      var = varargin{1};
      x = var(:,1);
      y = var(:,2);
      z = var(:,3);
  elseif length(varargin)==3
      x = varargin{1};
      y = varargin{2};
      z = varargin{3};
  end

  # convert coordinates
  dim = size(x);
  theta = reshape(mod(atan2(y(:), x(:))+2*pi, 2*pi), dim);
  r = reshape(sqrt(x(:).*x(:) + y(:).*y(:)), dim);

  # process output parameters
  if nargout==0 ||nargout==1
      if length(dim)>2 || dim(2)>1
          varargout{1} = {theta r z};
      else
          varargout{1} = [theta r z];
      end
  elseif nargout==3
      varargout{1} = theta;
      varargout{2} = r;
      varargout{3} = z;
  end

endfunction
