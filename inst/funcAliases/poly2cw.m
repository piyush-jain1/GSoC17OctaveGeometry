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
## @deftypefn {Function File} [@var{xcw},@var{ycw}] = poly2cw (@var{x},@var{y})
## Convert Polygons to clockwise contours(polygons).
##
## @var{x}/@var{y} is a cell array or NaN delimited vector of polygons, representing the x/y coordinates of the points.
## @var{xcw}/@var{ycw} has the same format of the input.
##
## @seealso{poly2ccw,ispolycw}
## @end deftypefn

function [xcw ycw]=poly2cw(x,y)
  if (nargin != 2)
  #case of wrong number of input arguments
   print_usage();
  endif
  
  #Cell Array Format
  if(iscell (x) || iscell (y))
    if(!iscell(x) || !iscell (y))
      error ('X and Y should have the same format')
    endif

    if( numel(x)!=numel(y))
      error ('X and Y should contain the same number of contours(polygons)')
    endif
    
    #Check the orientation of the polygons
    iscw=feval ('ispolycw',x,y);
    xcw=x;
    ycw=y;
    for pol=1:numel (x)
      if(iscw(pol)==0)
        xcw{pol}=x{pol}(end:-1:1);
        ycw{pol}=y{pol}(end:-1:1);
      endif  
    endfor
    
  else
    #NaN Delimited Vectors
    if(numel (x)!=numel (y))
      error ('X and Y should have the same number of points')
    endif

    #Find the location of NaN separators (delimiters)
    xnanidxs=[0 reshape(find (isnan (x)),[1 numel(find(isnan(x)))]) length(x)+1];
    ynanidxs=[0 reshape(find (isnan (y)),[1 numel(find(isnan(y)))]) length(y)+1];
    
    if(xnanidxs!=ynanidxs)
      error('X and Y should contain the same number of contours(polygons)')
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
      xcw=zeros (1,numel (x)-emptycontours);
      ycw=zeros (1,numel (y)-emptycontours);
    else
      xcw=zeros (numel (x)-emptycontours,1);
      ycw=zeros (numel (y)-emptycontours,1);
    endif
    
    iscw=feval('ispolycw',x,y);
    
    curpoint=1;
    curpolygon=1;
    for nanlocation=1:numel (xnanidxs)-1
      #Non Empty Contour
      if(xnanidxs(nanlocation+1)!=xnanidxs(nanlocation)+1)
        if(iscw (curpolygon)==0)
    
          #Reverse the current contour 
          noofpoints=xnanidxs(nanlocation+1)-1-xnanidxs(nanlocation);
          xcw(curpoint:curpoint+noofpoints-1)=x(xnanidxs(nanlocation+1)-1:-1:xnanidxs(nanlocation)+1);
          ycw(curpoint:curpoint+noofpoints-1)=y(ynanidxs(nanlocation+1)-1:-1:ynanidxs(nanlocation)+1);
          curpoint+=noofpoints;
          
          #Add a NaN Delimiter
          if(curpoint!=length (xcw)+1)
            xcw(curpoint)=NaN;
            ycw(curpoint++)=NaN;
          endif
          
        else

          #Copy the current contour
          noofpoints=xnanidxs(nanlocation+1)-1-xnanidxs(nanlocation);
          xcw(curpoint:curpoint+noofpoints-1)=x(xnanidxs(nanlocation)+1:xnanidxs(nanlocation+1)-1);
          ycw(curpoint:curpoint+noofpoints-1)=y(ynanidxs(nanlocation)+1:ynanidxs(nanlocation+1)-1);
          curpoint+=noofpoints;

          #Add a NaN Delimiter
          if(curpoint!=length (xcw)+1)
            xcw(curpoint)=NaN;
            ycw(curpoint++)=NaN;
          endif
        endif

        curpolygon++;
      endif
    endfor
  
  endif  
endfunction

%!test
%! x={[1 2],[3 4]}; y={[10 20],[30 40]};
%! [xcw,ycw]=poly2cw(x,y);
%! assert (xcw,x);
%! assert (ycw,y);

%!test
%! x=[0 0 2 2 NaN 0 2 0]; y=[0 2 2 0 NaN 0 0 3];
%! [xcw,ycw]=poly2cw(x,y);
%! xexp=[0 0 2 2 NaN 0 2 0];
%! yexp=[0 2 2 0 NaN 3 0 0];
%! assert (xcw,xexp);
%! assert (ycw,yexp);