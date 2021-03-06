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
## @deftypefn {Function File} {@var{h} =} drawBox (@var{box})
## @deftypefnx {Function File} {@var{h} =} drawBox (@var{box}, @var{param}, @var{value}, @dots{})
## Draw a box defined by coordinate extents
## 
## Draws a box defined by its extent: @var{box} = [@var{xmin} @var{xmax}
## @var{ymin} @var{ymax}]. Addtional
## arguments are passed to function @code{plot}. If requested, it returns the
## handle to the graphics object created.
##
## @seealso{drawOrientedBox, drawRect, plot}
## @end deftypefn

function varargout = drawBox(box, varargin)

  # default values
  xmin = box(:,1);
  xmax = box(:,2);
  ymin = box(:,3);
  ymax = box(:,4);

  nBoxes = size(box, 1);
  r = zeros(nBoxes, 1);

  # iterate on boxes
  for i = 1:nBoxes
      # exract min and max values
      tx(1) = xmin(i);
      ty(1) = ymin(i);
      tx(2) = xmax(i);
      ty(2) = ymin(i);
      tx(3) = xmax(i);
      ty(3) = ymax(i);
      tx(4) = xmin(i);
      ty(4) = ymax(i);
      tx(5) = xmin(i);
      ty(5) = ymin(i);

      # display polygon
      r(i) = plot(tx, ty, varargin{:});
  end

  # format output
  if nargout > 0
      varargout = {r};
  end
  
endfunction
