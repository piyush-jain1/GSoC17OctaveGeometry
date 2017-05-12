## Copyright (C) 2004-2016 David Legland <david.legland@grignon.inra.fr>
## Copyright (C) 2004-2016 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas)
## Copyright (C) 2016 Adapted to Octave by Juan Pablo Carbajal <ajuanpi+dev@gmail.com>
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

%DRAWLINE3D Draw a 3D line on the current axis
%
%   drawline3d(LINE);
%   Draws the line LINE on the current axis, by clipping with the current
%   axis. If line is not clipepd by the axis, function return -1.
%
%   drawLine3d(LINE, PARAM, VALUE)
%   Accepts parameter/value pairs, like for plot function.
%   Color of the line can also be given as a single parameter.
%   
%   H = drawLine3d(...)
%   Returns a handle to the created graphic line object.
%
%
%   See also:
%   lines3d, createLine3d, clipLine3d

function varargout = drawLine3d(lin, varargin)

  % ensure color is given as name-value pair
  if length(varargin)==1
      varargin = {'color', varargin{1}};
  end

  % extract limits of the bounding box
  lim = get(gca, 'xlim');
  xmin = lim(1);
  xmax = lim(2);
  lim = get(gca, 'ylim');
  ymin = lim(1);
  ymax = lim(2);
  lim = get(gca, 'zlim');
  zmin = lim(1);
  zmax = lim(2);

  % clip the ine with the limits of the current axis
  edge = clipLine3d (lin, [xmin xmax ymin ymax zmin zmax]);

  % draw the clipped line
  if sum(isnan(edge))==0
      h  = drawEdge3d(edge);
      if ~isempty(varargin)
          set(h, varargin{:});
      end
  else
      h  = -1;
  end

  % process output
  if nargout>0
      varargout{1}=h;
  end

endfunction
