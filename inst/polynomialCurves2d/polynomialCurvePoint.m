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
## @deftypefn {Function File} {@var{point} =} polynomialCurvePoint (@var{t}, @var{xcoef},@var{ycoef})
## @deftypefnx {Function File} {@var{point} =} polynomialCurvePoint (@var{t}, @var{coefs})
## Compute point corresponding to a position
##
##   @var{xcoef} and @var{ycoef} are row vectors of coefficients, in the form:
##       [a0 a1 a2 ... an]
##   @var{t} is a either a scalar, or a column vector, containing values of the
##   parametrization variable.
##   @var{point} is a 1x2 array containing coordinate of point corresponding to
##   position given by @var{t}. If @var{t} is a vector, @var{point} has as many rows as @var{t}.
##
##   @var{coefs} is either a 2xN matrix (one row for the coefficients of each
##   coordinate), or a cell array.
## 
## @seealso{polynomialCurves2d, polynomialCurveLength}
## @end deftypefn

function point = polynomialCurvePoint (t, varargin)
  ## Extract input parameters

  # polynomial coefficients for each coordinate
  var = varargin{1};
  if iscell (var)
      xCoef = var{1};
      yCoef = var{2};
  elseif size (var, 1)==1
      xCoef = varargin{1};
      yCoef = varargin{2};
  else
      xCoef = var(1,:);
      yCoef = var(2,:);
  end

  ## compute length by numerical integration

  # convert polynomial coefficients to polyval convention
  cx = xCoef(end:-1:1);
  cy = yCoef(end:-1:1);

  # numerical integration of the Jacobian of parametrized curve
  point = [polyval(cx, t) polyval(cy, t)];

endfunction
