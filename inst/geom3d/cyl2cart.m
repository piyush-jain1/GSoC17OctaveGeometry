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
## @deftypefn {Function File} {@var{cart} =} cyl2cart (@var{cyl})
## @deftypefnx {Function File} {@var{cart} =} cyl2cart (@var{theta},@var{r},@var{z})
##  Convert cylindrical to cartesian coordinates
##
##   CART = cyl2cart(CYL)
##   convert the 3D cylindrical coordinates of points CYL (given by
##   [THETA R Z] where THETA, R, and Z have the same size) into cartesian
##   coordinates CART, given by [X Y Z].
##   The transforms is the following :
##   X = R*cos(THETA);
##   Y = R*sin(THETA);
##   Z remains inchanged.
##
##   CART = cyl2cart(THETA, R, Z)
##   provides coordinates as 3 different parameters
##
##   Example
## @example
##   cyl2cart([-1 0 2])
##   gives : 4.7124    1.0000     2.0000
## @end example
##
## @seealso{angles3d, cart2pol, cart2sph2, cart2cyl}
## @end deftypefn

function varargout = cyl2cart(varargin)

  # process input parameters
  if length(varargin)==1
      var = varargin{1};
      theta = var(:,1);
      r = var(:,2);
      z = var(:,3);
  elseif length(varargin)==3
      theta = varargin{1};
      r = varargin{2};
      z = varargin{3};
  end

  # convert coordinates
  dim = size(theta);
  x = reshape(r(:).*cos(theta(:)), dim);
  y = reshape(r(:).*sin(theta(:)), dim);

  # process output parameters
  if nargout==0 ||nargout==1
      if length(dim)>2 || dim(2)>1
          varargout{1} = {x y z};
      else
          varargout{1} = [x y z];
      end
  elseif nargout==3
      varargout{1} = x;
      varargout{2} = y;
      varargout{3} = z;
  end

endfunction
