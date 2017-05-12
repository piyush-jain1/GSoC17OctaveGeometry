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
## @deftypefn {Function File} {[@var{xc}, @var{yc}] =} polynomialCurveFit (@var{t}, @var{xt}, @var{yt}, @var{order})
## @deftypefnx {Function File} {[@var{xc}, @var{yc}] =} polynomialCurveFit (@var{t}, @var{points}, @var{order})
## @deftypefnx {Function File} {[@var{xc}, @var{yc}] =} polynomialCurveFit (@dots{}, @var{ti}, @var{condi})
## Fit a polynomial curve to a series of points
##
## @var{t} is a Nx1 vector.
##
## @var{xt} and @var{yt} are coordinate for each parameter value (column vectors).
## @var{order} is the degree of the polynomial used for interpolation.
## @var{xc} and @var{yc} are polynomial coefficients, given in @var{order}+1 row vectors,
## starting from degree 0 and up to degree @var{order}.
## @var{points} specifies coordinate of points in a Nx2 array.
##
## Impose some specific conditions using @var{ti} and @var{condi}.
##
## @var{ti} is a value of the parametrization variable. @var{condi} is a cell
## array, with 2 columns, and as many rows as
## the derivatives specified for the given @var{ti}. Format for @var{condi} is:
##
## @var{condi} = @{X_I, Y_I; X_I', Y_I'; X_I", Y_I"; ...@};
##
## with X_I and Y_I being the imposed coordinate at position @var{ti}, X_I' and
## Y_I' being the imposed first derivatives, X_I" and Y_I" the imposed
## second derivatives, and so on...
## To specify a derivative without specifying derivative with lower
## degree, value of lower derivative can be let empty, using '[]'.
##
##
## Requires the optimization Toolbox.
##
## Run @command{demo polynomialCurveFit} to see exaples of use.
##
## @seealso{polynomialCurves2d}
## @end deftypefn

function varargout = polynomialCurveFit(t, varargin)

  ## extract input arguments

  # extract curve coordinate
  var = varargin{1};
  if min(size(var))==1
      # curve given as separate arguments
      xt = varargin{1};
      yt = varargin{2};
      varargin(1:2)=[];
  else
      # curve coordinate bundled in a matrix
      if size(var, 1)<size(var, 2)
          var = var';
      end
      xt = var(:,1);
      yt = var(:,2);
      varargin(1)=[];
  end

  # order of the polynom
  var = varargin{1};
  if length(var)>1
      Dx = var(1);
      Dy = var(2);
  else
      Dx = var;
      Dy = var;
  end
  varargin(1)=[];


  ## Initialize local conditions

  # For a solution vector 'x', the following relation must hold:
  #   Aeq * x == beq,
  # with:
  #   Aeq   Matrix M*N
  #   beq   column vector with length M
  # The coefficients of the Aeq matrix are initialized as follow:
  # First point and last point are considered successively. For each point,
  # k-th condition is the value of the (k-1)th derivative. This value is
  # computed using relation of the form:
  #   value = sum_i ( fact(i) * t_j^pow(i) )
  # with:
  #   i     indice of the (i-1) derivative.
  #   fact  row vector containing coefficient of each power of t, initialized
  #       with a row vector equals to [1 1 ... 1], and updated for each
  #       derivative by multiplying by corresponding power minus 1.
  #   pow   row vector of the powers of each monome. It is represented by a
  #       row vector containing an increasing series of power, eventually
  #       completed with zeros for lower degrees (for the k-th derivative,
  #       the coefficients with power lower than k are not relevant).

  # Example for degree 5 polynom:
  #   iter deriv  pow                 fact
  #   1    0      [0 1 2 3 4 5]       [1 1 1 1 1 1]
  #   2    1      [0 0 1 2 3 4]       [0 1 2 3 4 5]
  #   3    2      [0 0 0 1 2 3]       [0 0 1 2 3 4]
  #   4    3      [0 0 0 0 1 2]       [0 0 0 1 2 3]
  #   ...
  #   The process is repeated for coordinate x and for coordinate y.

  # Initialize empty matrices
  Aeqx = zeros(0, Dx+1);
  beqx = zeros(0, 1);
  Aeqy = zeros(0, Dy+1);
  beqy = zeros(0, 1);

  # Process local conditions
  while ~isempty(varargin)
      if length(varargin)==1
          warning('MatGeom:PolynomialCurveFit:ArgumentNumber', ...
              'Wrong number of arguments in polynomialCurvefit');
      end

      # extract parameter t, and cell array of local conditions
      ti = varargin{1};
      cond = varargin{2};

      # factors for coefficients of each polynomial. At the beginning, they
      # all equal 1. With successive derivatives, their value increase by the
      # corresponding powers.
      factX = ones(1, Dx+1);
      factY = ones(1, Dy+1);

      # start condition initialisations
      for i = 1:size(cond, 1)
          # degrees of each polynomial
          powX = [zeros(1, i) 1:Dx+1-i];
          powY = [zeros(1, i) 1:Dy+1-i];

          # update conditions for x coordinate
          if ~isempty(cond{i,1})
              Aeqx = [Aeqx ; factY.*power(ti, powX)]; ##ok<AGROW>
              beqx = [beqx; cond{i,1}]; ##ok<AGROW>
          end

          # update conditions for y coordinate
          if ~isempty(cond{i,2})
              Aeqy = [Aeqy ; factY.*power(ti, powY)]; ##ok<AGROW>
              beqy = [beqy; cond{i,2}]; ##ok<AGROW>
          end

          # update polynomial degrees for next derivative
          factX = factX.*powX;
          factY = factY.*powY;
      end

      varargin(1:2)=[];
  end


  ## Initialisations

  # ensure column vectors
  t  = t(:);
  xt = xt(:);
  yt = yt(:);

  # number of points to fit
  L = length(t);


  ## Compute coefficients of each polynomial

  # main matrix for x coordinate, size L*(degX+1)
  T = ones(L, Dx+1);
  for i = 1:Dx
      T(:, i+1) = power(t, i);
  end

  # compute interpolation
  # Octave compatibility - JPi 2013
  xc = lsqlin (T, xt, zeros(1, Dx+1), 1, Aeqx, beqx)';

  # main matrix for y coordinate, size L*(degY+1)
  T = ones(L, Dy+1);
  for i = 1:Dy
      T(:, i+1) = power(t, i);
  end

  # compute interpolation
  # Octave compatibility - JPi 2013
  yc = lsqlin (T, yt, zeros(1, Dy+1), 1, Aeqy, beqy)';


  ## Format output arguments
  if nargout <= 1
      varargout{1} = {xc, yc};
  else
      varargout{1} = xc;
      varargout{2} = yc;
  end

endfunction

function x = lsqlin (C, d, A, b, Aeq, beq)
  H = C'*C;
  q = -C'*d;
  x0 = zeros (size(C,2),size(d,2));

  x = qp (x0, H, q, Aeq, beq, [], [],[], A, b);
endfunction

%!demo
%!   # defines a curve (circle arc) with small perturbations
%!   N  = 50;
%!   t  = linspace(0, 3*pi/4, N)';
%!   xp = cos(t) + 5e-2*randn(size(t));
%!   yp = sin(t) + 5e-2*randn(size(t));
%!
%!   [xc yc] = polynomialCurveFit(t, xp, yp, 3);
%!
%!   figure(1);
%!   clf;
%!   drawPolynomialCurve(t([1 end]), xc, yc);
%!   hold on
%!   plot(xp,yp,'.g');
%!   hold off
%!   axis tight
%!   axis equal

%!demo
%!   # defines a curve (circle arc) with small perturbations
%!   N  = 100;
%!   t  = linspace(0, 3*pi/4, N)';
%!   xp = cos(t) + 7e-2*randn(size(t));
%!   yp = sin(t) + 7e-2*randn(size(t));
%!
%!   # plot the points
%!   figure (1); clf; hold on;
%!   axis ([-1.2 1.2 -.2 1.2]); axis equal;
%!   drawPoint (xp, yp, ".g");
%!
%!   # fit without knowledge on bounds
%!   [xc0 yc0] = polynomialCurveFit (t, xp, yp, 5);
%!   h = drawPolynomialCurve (t([1 end]), xc0, yc0);
%!   set(h, "color", "b")
%!
%!   # fit by imposing coordinate on first point
%!   [xc1 yc1] = polynomialCurveFit (t, xp, yp, 5, 0, {1, 0});
%!   h = drawPolynomialCurve (t([1 end]), xc1, yc1);
%!   set(h, "color", "r")
%!
%!   # fit by imposing coordinate (1,0) and derivative (0,1) on first point
%!   [xc2 yc2] = polynomialCurveFit (t, xp, yp, 5, 0, {1, 0;0 1});
%!   h = drawPolynomialCurve (t([1 end]), xc2, yc2);
%!   set(h, "color", "m")
%!
%!   # fit by imposing several conditions on various points
%!   [xc3 yc3] = polynomialCurveFit (t, xp, yp, 5, ...
%!       0, {1, 0;0 1}, ...      # coord and first derivative of first point
%!       3*pi/4, {-sqrt(2)/2, sqrt(2)/2}, ...    # coord of last point
%!       pi/2, {[], [];-1, 0});      # derivative of point on the top of arc
%!   h = drawPolynomialCurve (t([1 end]), xc3, yc3);
%!   set(h, "color", "k")
%!   axis tight
%!   axis equal
