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
## @deftypefn {Function File} @var{P} = svgpath2polygon (@var{SVGpath})
## Converts the SVG path structure @var{SVGpath} to an array of polygons 
## compatible with the geometry package and matGeom (@url{http://matgeom.sf.net}).
## 
## @var{SVGpath} is a substructure of the SVG structure output by loadSVG. This
## function extracts the field named "coord" if there is only one path. If there
## are more than oe path it puts the "coord" field of each path in the same 
## array, separated by nans.
##
## @seealso{svgnormalize, svgload}
## @end deftypefn

function P = svgpath2polygon (SVGpath)

    P = SVGpath(1).coord;
    for ip = 2:numel (SVGpath)
        P = [P; nan(1,2); SVGpath(ip).coord];
    end

end

%!demo
%! file    = 'tmp__.svg';
%! fid     = fopen (file,'w');
%! svgfile = '<html><body><svg xmlns="http://www.w3.org/2000/svg" version="1.1" height="250" width="250"><path d="M150,0 75,200 225,200 Z" /></svg></body></html>';
%! fprintf (fid,"#s\n",svgfile);
%! fclose (fid);
%! SVG     = svgload (file);
%! SVG     = svgnormalize (SVG);
%! P       = svgpath2polygon (SVG.path);
%! plot (P(:,1),P(:,2));
%! delete (file);

%!demo
%! file    = 'tmp__.svg';
%! fid     = fopen (file,'w');
%! svgfile = '<html><body><svg xmlns="http://www.w3.org/2000/svg" version="1.1" height="250" width="250"><path d="M150,0 75,200 225,200 Z" /><path d="M0,0 100,0 100,100 0,100 Z" /></svg></body></html>';
%! fprintf (fid,"#s\n",svgfile);
%! fclose (fid);
%! SVG     = svgload (file);
%! SVG     = svgnormalize (SVG);
%! P       = svgpath2polygon (SVG.path);
%! plot (P(:,1),P(:,2));
%! delete (file);
