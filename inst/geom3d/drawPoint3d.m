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
## @deftypefn {Function File} {@var{h} =} drawPoint3d (@var{x}, @var{y}, @var{z})
## @deftypefnx {Function File} {@var{h} =} drawPoint3d (@var{coord})
## @deftypefnx {Function File} {@var{h} =} drawPoint3d (@dots{})
## Draw 3D point on the current axis.
##
##   drawPoint3d(X, Y, Z) 
##   will draw points defined by coordinates X and Y. 
##   X and Y are N*1 array, with N being number of points to be drawn.
##   
##   drawPoint3d(COORD) 
##   packs coordinates in a single [N*3] array.
##
##   drawPoint3d(..., OPT) 
##   will draw each point with given option. OPT is a string compatible with
##   'plot' model.
##
##   H = drawPoint3d(...) 
##   Also return a handle to each of the drawn points.
##
## @seealso{points3d, clipPoints3d}
## @end deftypefn

function varargout = drawPoint3d(varargin)

  var = varargin{1};
  if size(var, 2)==3
      # points are given as one single array with 3 columns
      px = var(:, 1);
      py = var(:, 2);
      pz = var(:, 3);
      varargin = varargin(2:end);
  elseif length(varargin)<3
      error('wrong number of arguments in drawPoint3d');
  else
      # points are given as 3 columns with equal length
      px = varargin{1};
      py = varargin{2};
      pz = varargin{3};
      varargin = varargin(4:end);
  end

  # default draw style: no line, marker is 'o'
  if length(varargin)~=1
      varargin = ['linestyle', 'none', 'marker', 'o', varargin];
  end

  # plot only points inside the axis.
  h = plot3(px, py, pz, varargin{:});

  if nargout>0
      varargout{1} = h;
  end

endfunction
