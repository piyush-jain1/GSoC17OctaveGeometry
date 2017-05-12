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
## @deftypefn {Function File} {@var{c} =} polynomialCurveCentroid (@var{t}, @var{xcoef}, @var{ycoef})
## @deftypefnx {Function File} {@var{c} =} polynomialCurveCentroid (@var{t}, @var{coefs})
## @deftypefnx {Function File} {@var{c} =} polynomialCurveCentroid (@dots{}, @var{tol})
## Compute the centroid of a polynomial curve
##
##   @var{xcoef} and @var{ycoef} are row vectors of coefficients, in the form:
##       [a0 a1 a2 ... an]
##   @var{t} is a 1x2 row vector, containing the bounds of the parametrization
##   variable: @var{t} = [T0 T1], with @var{t} taking all values between T0 and T1.
##   @var{c} contains coordinate of the polynomial curve centroid.
##
##   @var{coefs} is either a 2xN matrix (one row for the coefficients of each
##   coordinate), or a cell array.
##
##   @var{tol} is the tolerance fo computation (absolute).
## 
## @seealso{polynomialCurves2d, polynomialCurveLength}
## @end deftypefn

function centroid = polynomialCurveCentroid(tBounds, varargin)
  ## Extract input parameters

  # parametrization bounds
  t0 = tBounds(1);
  t1 = tBounds(end);

  # polynomial coefficients for each coordinate
  var = varargin{1};
  if iscell(var)
      cx = var{1};
      cy = var{2};
      varargin(1) = [];
  elseif size(var, 1)==1
      cx = varargin{1};
      cy = varargin{2};
      varargin(1:2)=[];
  else
      cx = var(1,:);
      cy = var(2,:);
      varargin(1)=[];
  end
  # convert to Octave polyval format
  cx = cx(end:-1:1);
  cy = cy(end:-1:1);

  # tolerance
  tol = 1e-6;
  if ~isempty(varargin)
      tol = varargin{1};
  end

  ## compute length by numerical integration

  # compute derivative of the polynomial
  dx = polyder (cx);
  dy = polyder (cy);

  # compute curve length by integrating the Jacobian
  L = quad(@(t)sqrt(polyval(dx, t).^2+polyval(dy, t).^2), t0, t1, tol);

  # compute first coordinate of centroid
  xc = quad(@(t)polyval(cx, t).*sqrt(polyval(dx, t).^2+polyval(dy, t).^2), t0, t1, tol);

  # compute first coordinate of centroid
  yc = quad(@(t)polyval(cy, t).*sqrt(polyval(dx, t).^2+polyval(dy, t).^2), t0, t1, tol);

  # divide result of integration by total length of the curve
  centroid = [xc yc]/L;

endfunction

%!demo
%! bounds = [-1 1];
%! coefs = [0 1 1; 0 -1 2];
%! c = polynomialCurveCentroid (bounds, coefs);
%!
%! drawPolynomialCurve (bounds, coefs(1,:), coefs(2,:));
%! hold on
%! plot (c(1),c(2),'sr')
%! hold off
%! # -------------------------------------------------
%! # Centriod of a polynomial curve
