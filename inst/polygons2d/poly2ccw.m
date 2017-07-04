## Copyright (C) 2016 Amr Mohamed <amr_mohamed@live.com>
##
## This file is part of Octave.
##
## Octave is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## Octave is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not,
## see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} [@var{xccw},@var{yccw}] = poly2ccw (@var{x},@var{y})
## Convert Polygons to counterclockwise contours(polygons).
##
## @var{x}/@var{y} is a cell array or NaN delimited vector of polygons, representing the x/y coordinates of the points.
## @var{xccw}/@var{yccw} has the same format of the input.
##
## @seealso{poly2cw,ispolycw}
## @end deftypefn

function [xccw yccw]=poly2ccw(x,y)
  if (nargin != 2)
  #case of wrong number of input arguments
   print_usage();
  endif

  #Cell Array Format
  if(iscell (x) || iscell (y))
    if(!iscell(x) || !iscell (y))
      error ('X and Y should have the same format')
    endif

    if(numel (x)!=numel (y))
      error ('X and Y should contain the same number of contours(polygons)')
    endif
    
    #Check the orientation of the polygons
    iscw=feval ('ispolycw',x,y);
    xccw=x;
    yccw=y;
    for pol=1:numel (x)
      if(iscw (pol))
        xccw{pol}=x{pol}(end:-1:1);
        yccw{pol}=y{pol}(end:-1:1);
      endif  
    endfor
    
  else
    #NaN Delimited Vectors
    if(numel (x)!=numel (y))
      error ('X and Y should have the same number of points')
    endif

    #Find the location of NaN separators (delimiters)
    xnanidxs=[0 reshape(find (isnan(x)),[1 numel(find (isnan(x)))]) length(x)+1];
    ynanidxs=[0 reshape(find (isnan(y)),[1 numel(find (isnan(y)))]) length(y)+1];
    
    if(xnanidxs!=ynanidxs)
      error ('X and Y should contain the same number of contours(polygons)')
    endif

    #Count no of empty contours (2 Successive NaNs with no intermediate points)
    emptycontours=0;
    for nanlocation=1:length (xnanidxs)-1
      if(xnanidxs(nanlocation+1)==xnanidxs(nanlocation)+1)
        emptycontours++;
      endif
    endfor
    
    
    #Prepare the output variables
    if(isrow (x))
      xccw=zeros (1,numel (x)-emptycontours);
      yccw=zeros (1,numel (y)-emptycontours);
    else
      xccw=zeros (numel (x)-emptycontours,1);
      yccw=zeros (numel (y)-emptycontours,1);
    endif
    
    iscw=feval ('ispolycw',x,y);
    
    curpoint=1;
    curpolygon=1;
    for nanlocation=1:numel (xnanidxs)-1
      #Non Empty Contour
      if(xnanidxs(nanlocation+1)!=xnanidxs(nanlocation)+1)
        if(iscw (curpolygon))

          #Reverse the current contour
          noofpoints=xnanidxs(nanlocation+1)-1-xnanidxs(nanlocation);
          xccw(curpoint:curpoint+noofpoints-1)=x(xnanidxs(nanlocation+1)-1:-1:xnanidxs(nanlocation)+1);
          yccw(curpoint:curpoint+noofpoints-1)=y(ynanidxs(nanlocation+1)-1:-1:ynanidxs(nanlocation)+1);
          curpoint+=noofpoints;
          
          #Add a NaN Delimiter
          if(curpoint!=length (xccw)+1)
            xccw(curpoint)=NaN;
            yccw(curpoint++)=NaN;
          endif
          
        else

          #Copy the current contour
          noofpoints=xnanidxs(nanlocation+1)-1-xnanidxs(nanlocation);
          xccw(curpoint:curpoint+noofpoints-1)=x(xnanidxs(nanlocation)+1:xnanidxs(nanlocation+1)-1);
          yccw(curpoint:curpoint+noofpoints-1)=y(ynanidxs(nanlocation)+1:ynanidxs(nanlocation+1)-1);
          curpoint+=noofpoints;
          
          #Add a NaN Delimiter
          if(curpoint!=length (xccw)+1)
            xccw(curpoint)=NaN;
            yccw(curpoint++)=NaN;
          endif
        endif

        curpolygon++;
      endif
    endfor
    
  endif  
endfunction

%!test
%! x={[1 2],[3 4]}; y={[10 20],[30 40]};
%! [xccw,yccw]=poly2ccw(x,y);
%! xexp={[2 1],[4 3]};
%! yexp={[20 10],[40 30]};
%! assert (xccw,xexp);
%! assert (yccw,yexp);

%!test
%! x=[0 0 2 2 NaN 0 2 0]; y=[0 2 2 0 NaN 0 0 3];
%! [xccw,yccw]=poly2ccw(x,y);
%! xexp=[2 2 0 0 NaN 0 2 0];
%! yexp=[0 2 2 0 NaN 0 0 3];
%! assert (xccw,xexp);
%! assert (yccw,yexp);