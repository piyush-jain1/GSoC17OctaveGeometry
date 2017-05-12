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
## @deftypefn {Function File} @var{SVGn} = loadSVG (@var{SVG})
## Scales and reflects the @var{SVG} structure and returns a modified @var{SVGn}
## structure.
## 
## The height and width of the SVG are scaled such that the diagonal of the 
## bounding box has length 1. Coordinates are trasnfomed such that a plot of the
## paths coincides with the visualization of the original SVG.
##
## @seealso{svgload, svgpath2polygon}
## @end deftypefn

function SVGn = svgnormalize (SVG)
    
  SVGn = SVG;
  if ~SVG.normalized
    # Translate
    TransV = [0, SVG.height/2];
    # Scale
    Dnorm = sqrt (SVG.width ^ 2 + SVG.height ^ 2);
    S = (1 / Dnorm) * eye (2);
    for i = 1:numel (SVG.path)
        nc = size (SVG.path(i).coord, 1);
        # Translate to middle
        T = repmat (TransV,nc, 1);
        SVGn.path(i).coord = SVG.path(i).coord - T;
        # Reflect 
        SVGn.path(i).coord(:, 2) = -SVGn.path(i).coord(:,2);
        T(:,2) = -T(:,2);
        # Translate to bottom
        SVGn.path(i).coord = SVGn.path(i).coord - T;
        #Scale
        SVGn.path(i).coord = SVGn.path(i).coord * S;
    end
    SVGn.height = SVG.height / Dnorm;
    SVGn.width = SVG.width / Dnorm;
    SVGn.normalized = true;
  end

end

%!demo
%! file    = 'tmp__.svg';
%! fid     = fopen (file,'w');
%! svgfile = '<html><body><svg xmlns="http://www.w3.org/2000/svg" version="1.1" height="250" width="250"><path d="M150,0 75,200 225,200 Z" /></svg></body></html>';
%! fprintf (fid,"#s\n",svgfile);
%! fclose (fid);
%! SVG     = svgload (file);
%! SVGn    = svgnormalize (SVG);
%! SVGn
%! plot([SVGn.path.coord(:,1); SVGn.path.coord(1,1)], ...
%!      [SVGn.path.coord(:,2); SVGn.path.coord(1,2)]);
%! delete (file);
