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
## @deftypefn {Function File} {@var{T} = } createHomothecy (@var{point}, @var{ratio})
## Create the the 3x3 matrix of an homothetic transform.
#
#   @var{point} is the center of the homothecy, @var{ratio} is its factor.
#
#   @seealso{transforms2d, transformPoint, createTranslation}
## @end deftypefn

function T = createHomothecy(point, ratio)
  point = point (:);
  if length (point) > 2
    error ("Octave:invalid-input-arg", "Only one point accepted.");
  endif
  if length (ratio) > 1
    error ("Octave:invalid-input-arg", "Only one ratio accepted.");
  endif

  T        = diag ([ratio ratio 1]);
  T(1:2,3) = point .* (1 - ratio);
endfunction

%!demo
%! p  = [0 0; 1 0; 0 1];
%! s  = [-0.5 0.4];
%! T  = createHomothecy (s, 1.5);
%! pT = transformPoint (p, T);
%! drawPolygon (p,'-b')
%! hold on;
%! drawPolygon (pT,'-r');
%! drawEdge (s([1 1 1])(:),s([2 2 2])(:), pT(:,1), pT(:,2), ...
%!           'color', 'k','linestyle','--');
%! hold off;
%! axis tight equal;

%!error createHomothecy ([0,0;1,1], 1)
%!error createHomothecy ([0,0], [1;2])
%!assert (createHomothecy([-1,-1], 1.5),createHomothecy([-1;-1], 1.5))
