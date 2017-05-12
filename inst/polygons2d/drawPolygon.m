## Copyright (C) 2004-2011 David Legland <david.legland@grignon.inra.fr>
## Copyright (C) 2004-2011 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas)
## Copyright (C) 2016 Adapted to Octave by Juan Pablo Carbajal <carbajal@ifi.uzh.ch>
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
## @deftypefn {Function File} {@var{h} = } drawPolygon (@var{coord})
## @deftypefnx {Function File} {@var{h} = } drawPolygon (@var{px}, @var{py})
## @deftypefnx {Function File} {@var{h} = } drawPolygon (@var{polys})
## @deftypefnx {Function File} {@var{h} = } drawPolygon (@var{ax}, @dots{})
## Draw a polygon specified by a list of points.
##
##   drawPolygon (@var{coord}):
##   Packs coordinates in a single N-by-2 array in the form:
##   @code{[@var{x1}, @var{y1}; @var{x2}, @var{y2}; ... ; @var{xN}, @var{yN}]}.
##   Multiple polygons may be drawn by using @code{[...; NaN, NaN; ...]} as a separator
##   between coordinate sets.
##
##   drawPolygon (@var{px}, @var{py}):
##   Specifies coordinates with @var{x} and @var{y} components in separate
##   column vectors.
##
##   drawPolygon (@var{polys}):
##   Packs coordinate of several polygons in a cell array. Each element of
##   the cell array, @var{polys}, is a N-by-2 double array using the same form as described
##   for @var{coord} above.
##
##   drawPolygon (@var{ax}, @dots{}):
##   Specifies the axis, @var{ax}, to draw the polygon on.
##
##   @var{h} = drawPolygon (...):
##   Also return a handle to the list of line objects.
##
##   For more complete explanation of the polygon format and functions the
##   user should reference the @code{polygons2d} function.
##
##   @seealso{polygons2d, drawCurve}
## @end deftypefn

function h = drawPolygon (px, varargin)

  # Store hold state
  state = ishold (gca);
  hold on;

  ## Check input
  if nargin < 1
      print_usage ();
  end
  # check for empty polygons
  if isempty (px)
    return
  end
  ax = gca;
  if ( isAxisHandle (px) )
   % extract handle of axis to draw on
    ax          = px;
    px          = varargin{1};
    varargin(1) = [];
  end

  ## Manage cell arrays of polygons
  # case of a set of polygons stored in a cell array
  if iscell (px)

    opt = varargin(2:end);
    h   = cellfun (@(x)drawPolygon (x, opt{:}), px, 'UniformOutput', 0);
    h   = horzcat (h{:});
  else

    # Check size vs number of arguments
    if (size (px, 2) == 1)

      if ( (nargin < 2) || (nargin == 2 && ~isnumeric(varargin{1})) )
        error('Matgeom:invalid-input-arg', ...
        'Should specify either a N-by-2 array, or 2 N-by-1 vectors');
      else

        ## Parse coordinates and options
        # Extract coordinates of polygon vertices
        py          = varargin{1};
        varargin(1) = [];

        if (length (py) ~= length (px))
          error ('Matgeom:invalid-input-arg', ...
          'X and Y coordinates should have same numebr of rows (%d,%d)', ...
          length (px), length (px))
        end

      end

    elseif (size (px, 2) == 2)

      py = px(:, 2);
      px = px(:, 1);

    else
      error('Matgeom:invalid-input-arg', 'Should specify a N-by-2 array');
    end

    # Check case of polygons with holes
    if ( any (isnan (px(:)) ) )
        polygons = splitPolygons ([px py]);
        h        = drawPolygon (polygons, varargin{:});
    else
      # set default line format
      if isempty (varargin)
          varargin = {'b-'};
      end

      #TODO use patch to plot polygon
      txtarg = find (cellfun (@ischar, varargin));
      if ismember ({'patch'},varargin(txtarg))
        [~,tmp] = ismember ({'patch'}, varargin(txtarg));
        varargin(txtarg(tmp)) = [];
        warning ('Matgeom:option-ignored', 'patch option is not implemented yet.\n');
      endif
      ## Draw the polygon
      # ensure last point is the same as the first one
      px(end+1, :) = px(1,:);
      py(end+1, :) = py(1,:);
      # draw the polygon outline
      h = plot (px, py, varargin{:});

    end % whether there where holes

  end % whether input arg was a cell

  if ~state
    hold off
  end

end

%!demo
%! figure()
%! p  = [0 0; 0 1; 1 1; 1 0]; %ccw
%! ph = p + [1.2 0];
%! # add hole
%! ph(end+1,:) = nan;
%! ph          = [ph; ([0 0; 1 0; 1 1; 0 1]-[0.5 0.5])*0.5+[1.7 0.5]];
%! drawPolygon ({p, ph});

%!shared p, ph, pc, pch, opt
%! p  = [0 0; 0 1; 1 1; 1 0]; %ccw
%! ph = p;
%! # add hole
%! ph(end+1,:) = nan;
%! ph          = [ph; ([0 0; 1 0; 1 1; 0 1]-[0.5 0.5])*0.5+[0.5 0.5]];
%! # cells
%! pc  = arrayfun(@()p+rand(length(p),2), 1:5, 'Uniformoutput', 0);
%! pch = arrayfun(@()ph+rand(length(ph),2), 1:5, 'Uniformoutput', 0);
%! # options
%! opt = {'.-', 'color', 'r', 'linewidth', 2};

%!test
%! fig = figure();
%! set (fig, 'visible', 'off');
%! # Cell
%! h = drawPolygon (pc);
%! h = drawPolygon (pc, opt{:});
%! close (fig)

%!test
%! fig = figure();
%! set (fig, 'visible', 'off');
%! # Cell with holes
%! h = drawPolygon (pch);
%! h = drawPolygon (pch, opt{:});
%! close (fig)

%!test
%! fig = figure();
%! set (fig, 'visible', 'off');
%! # X,Y coordinates in single array
%! h = drawPolygon (p);
%! h = drawPolygon (p, opt{:});
%! close (fig)

%!test
%! fig = figure();
%! set (fig, 'visible', 'off');
%! # X,Y coordinates in single array with holes
%! h = drawPolygon (ph);
%! h = drawPolygon (ph, opt{:});
%! close (fig)

%!test
%! fig = figure();
%! set (fig, 'visible', 'off');
%! # X,Y coordinates two arrays
%! h = drawPolygon (p(:,1), p(:,2));
%! h = drawPolygon (p(:,1),p(:,2), opt{:});
%! close (fig)

%!test
%! fig = figure();
%! set (fig, 'visible', 'off');
%! # X,Y coordinates two arrays with holes
%! h = drawPolygon (ph(:,1), ph(:,2));
%! h = drawPolygon (ph(:,1), ph(:,2), opt{:});
%! close (fig)

%!error
%! fig = figure();
%! set (fig, 'visible', 'off');
%! # Single bad-formed input arg
%! h = drawPolygon (p(:,1));
%! h = drawPolygon (p(:,[1 1 2]));
%! close (fig)

%!warning
%! fig = figure();
%! set (fig, 'visible', 'off');
%! # Future options
%! opt_futur = {opt{:}, 'patch'};
%! h = drawPolygon (p, opt_futur{:});
%! h = drawPolygon (ph, opt_futur{:});
%! h = drawPolygon (pc, opt_futur{:});
%! h = drawPolygon (pch, opt_futur{:});
%! h = drawPolygon (p(:,1),p(:,2), opt_futur{:});
%! h = drawPolygon (ph(:,1), ph(:,2), opt_futur{:});
%! close (fig)
