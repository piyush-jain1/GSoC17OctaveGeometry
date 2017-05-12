## Copyright (C) 2012 Juan Pablo Carbajal <carbajal@ifi.uzh.ch>
##
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation; either version 3 of the License, or (at your option) any later
## version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License along with
## this program; if not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{} =} getSVGPaths_py (@var{}, @var{})
##
## @end deftypefn
function Paths = getSVGPaths_py (svg, varargin)

  ## Call python script
  if exist (svg,'file')
  # read from file
    [st str]=system (sprintf ('python parsePath.py %s', svg));

  else
  # inline SVG
    [st str]=system (sprintf ('python parsePath.py < %s', svg));
  end

  ## Parse ouput
  strpath = strsplit (str(1:end-1), '$', true);

  npaths = numel (strpath);

  ## Convert path data to polygons
  for ip = 1:npaths

    eval (strpath{ip});
    ## FIXME: intialize struct with cell field
    svgpath2.cmd = svgpath(1).cmd;
    svgpath2.data = {svgpath.data};

    nD = length(svgpath2.cmd);
    pathdata = cell (nD-1,1);

    point_end=[];
    ## If the path is closed, last command is Z and we set initial point == final
    if svgpath2.cmd(end) == 'Z'
      nD -= 1;
      point_end = svgpath2.data{1};
    end

    ## Initial point
    points(1,:) = svgpath2.data{1};

    for jp = 2:nD
      switch svgpath2.cmd(jp)
        case 'L'
          ## Straigth segment to polygon
          points(2,:) = svgpath2.data{jp};
          pp = [(points(2,:)-points(1,:))' points(1,:)'];
          clear points
          points(1,:) = [polyval(pp(1,:),1) polyval(pp(2,:),1)];

        case 'C'
          ## Cubic bezier to polygon
          points(2:4,:) = reshape (svgpath2.data{jp}, 2, 3).';
          pp = cbezier2poly (points);
          clear points
          points(1,:) = [polyval(pp(1,:),1) polyval(pp(2,:),1)];
      end

      pathdata{jp-1} = pp;
    end

    if ~isempty(point_end)
      ## Straight segmet to close the path
      points(2,:) = point_end;
      pp = [(points(2,:)-points(1,:))' points(1,:)'];

      pathdata{end} = pp;
    end

    Paths.(svgpathid).data = pathdata;
  end
endfunction

%!test
%! figure(1)
%! hold on
%! paths = getSVGPaths_py ('../drawing.svg');
%!
%! # Get path ids
%! ids = fieldnames(paths);
%! npath = numel(ids);
%!
%! t = linspace (0, 1, 64);
%!
%! for i = 1:npath
%!    x = []; y = [];
%!    data = paths.(ids(i)).data;
%!
%!    for j = 1:numel(data)
%!     x = cat (2, x, polyval (data{j}(1,:),t));
%!     y = cat (2, y, polyval (data{j}(2,:),t));
%!    end
%!
%!    plot(x,y,'-');
%! end
%! axis ij
%! if strcmpi(input('You should see drawing.svg [y/n] ','s'),'n')
%!  error ("didn't get what was expected.");
%! end
%! close
