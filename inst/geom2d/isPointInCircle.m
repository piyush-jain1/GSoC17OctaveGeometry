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
## @deftypefn {Function File} {@var{b} = } isPointInCircle (@var{point}, @var{circle})
## Test if a point is located inside a given circle
##
##   B = isPointInCircle(POINT, CIRCLE) 
##   Returns true if point is located inside the circle, i.e. if distance to
##   circle center is lower than the circle radius.
##
##   B = isPointInCircle(POINT, CIRCLE, TOL) 
##   Specifies the tolerance value
##
##   Example:
##   isPointInCircle([1 0], [0 0 1])
##   isPointInCircle([0 0], [0 0 1])
##   returns true, whereas
##   isPointInCircle([1 1], [0 0 1])
##   return false
##
##   @seealso{circles2d, isPointOnCircle}
## @end deftypefn

function b = isPointInCircle(point, circle, varargin)

  # extract computation tolerance
  tol = 1e-14;
  if ~isempty(varargin)
      tol = varargin{1};
  end

  d = sqrt(sum(power(point - circle(:,1:2), 2), 2));
  b = d-circle(:,3)<=tol;

endfunction

