## Copyright (C) 2004-2011 David Legland
## Copyright (C) 2004-2011 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas)
## Copyright (C) 2012-2017 Juan Pablo Carbajal
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

## Author: David Legland <david.legland@grignon.inra.fr>
## Author: Juan Pablo Carbajal <ajuanpi+dev@gmail.com>

## -*- texinfo -*-
## @deftypefn {Function File} {@var{edge2} = } transformEdge (@var{edge1}, @var{T})
## Transform an edge with an affine transform.
##
##   Where @var{edge1} has the form [x1 y1 x2 y1], and @var{T} is a transformation
##   matrix, return the edge transformed with affine transform @var{T}. 
##
##   Format of TRANS can be one of :
##   [a b]   ,   [a b c] , or [a b c]
##   [d e]       [d e f]      [d e f]
##                            [0 0 1]
##
##   Also works when @var{edge1} is a [Nx4] array of double. In this case, @var{edge2}
##   has the same size as @var{edge1}. 
##
## @seealso{edges2d, transforms2d, transformPoint, translation, rotation}
## @end deftypefn

function dest = transformEdge (edge, trans)

  # allocate memory
  dest = zeros (size (edge));
  
  # compute position
  for i=1:2
    T           = trans(i,1:2).';
    dest(:,i)   = edge(:,1:2) * T;
    dest(:,i+2) = edge(:,3:4) * T;
  endfor
  
  # add translation vector, if exist
  if size(trans, 2) > 2
    dest = bsxfun (@plus, dest, trans([1:2 1:2],3).');
  endif
  
endfunction

%!demo
%! e1 = [0 0 1 1] / sqrt (2);
%! T  = createTranslation ([0.5 0.25]) * ...
%!      createRotation (pi/2) * ...
%!      createScaling (0.5);
%! e2 = transformEdge (e1,T);
%! 
%! figure (1);
%! drawEdge(e1, 'color', 'g','linewidth', 2);
%! drawEdge(e2, 'color', 'r','linewidth', 2);
%! axis normal equal
%! legend({'original','transformed'})
%! grid on
%! box off

