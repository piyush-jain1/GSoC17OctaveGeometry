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
## @deftypefn {Function File} @var{SVG} = loadSVG (@var{filename})
## Reads the plain SVG file @var{filename} and returns an SVG structure.
## 
## In the current version only SVG path elements are parsed and stored in the field
## path of the @var{SVG} structure.
## The coordinates of the path are not modified in anyway. This produces the path
## to be ploted vertically reflected.
##
## @seealso{svgnormalize, svgpath2polygon}
## @end deftypefn


function SVG = svgload (filename)

    SVG = struct ('height', [], 'width', [], 'path', [], 'normalized', []);

    SVG.normalized = false;

    fid = fopen (filename);
    svg = char (fread (fid, "uchar")');
    fclose (fid);
    svgF = formatSVGstr (svg);

    # Get SVG Data
    data        = getSVGdata (svgF);
    SVG.height  = data.height;
    SVG.width   = data.width;

    # Get SVG Paths
    SVGstrPath  = getSVGstrPath (svgF);
    SVGpath     = SVGstrPath2SVGpath (SVGstrPath);
    SVG.path    = SVGpath;

end

%!demo
%! file    = 'tmp__.svg';
%! fid     = fopen (file,'w');
%! svgfile = '<html><body><svg xmlns="http://www.w3.org/2000/svg" version="1.1" height="250" width="250"><path d="M150,0 75,200 225,200 Z" /></svg></body></html>';
%! fprintf (fid,"#s\n",svgfile);
%! fclose (fid);
%! SVG     = svgload (file);
%! SVG
%! plot([SVG.path.coord(:,1); SVG.path.coord(1,1)], ...
%!      [SVG.path.coord(:,2); SVG.path.coord(1,2)]);
%! delete (file);
