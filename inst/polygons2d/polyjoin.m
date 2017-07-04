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
## @deftypefn {Function File}[@var{vecx},@var{vecy}] = polyjoin(@var{cellx},@var{celly})
## Convert cell arrays of polygons into NaN delimited coulmn vectors.
##
## @var{cellx}/@var{celly} is a cell array of polygons, representing the x/y coordinates of the points.
## 
## The function converts the cell arrays into column vectors containing the polygons separated by NaN(s)
##
## @seealso{polysplit,ispolycw}
## @end deftypefn


function [vecx,vecy] = polyjoin(cellx,celly)

if (nargin != 2)
  #case wrong number of input arguments
   print_usage();
endif

if(!iscell(cellx) || !iscell(cellx))
  #case of wrong input format
  print_usage();
endif


#check if the input is an empty cell
if (isempty (cellx) || isempty (celly))
  if(isempty (cellx) && isempty (celly))
    vecx=[];
    vecy=[];
  else
    error ('Different arguments sizes');
  endif
endif

#find the lengthes of all the vectors   
xlen=cellfun ('length', cellx);
ylen=cellfun ('length', celly);

if(sum (xlen==ylen) != length (cellx))
  error ('Some polygons have unequal number of points');
endif

#calulate the final length of the nan-delimited vector arrays
totalLength=sum (xlen)+length (cellx)-1;
vecx=zeros (totalLength,1);
vecy=zeros (totalLength,1);

#copy the values to the vector arrays and separate polygons by NaN(s)
index=1;
for i=1:length (cellx)-1
  vecx(index:index-1+length(cellx{i}))=cellx{i};
  vecy(index:index-1+length(celly{i}))=celly{i};
  index+=length (cellx{i});
  vecx(index)=NaN;
  vecy(index)=NaN;
  index++;
endfor
vecx(index:index-1+length(cellx{length(cellx)}))=cellx{length(cellx)};
vecy(index:index-1+length(celly{length(celly)}))=celly{length(celly)};
        
endfunction

%!test
%! x={[1 2],[3 4]}; y={[10 20],[30 40]};
%! [vecx,vecy]=polyjoin(x,y);
%! assert (vecx, [1; 2; NaN; 3; 4]);
%! assert (vecy, [10; 20; NaN; 30; 40]);

%!test
%! x={[1;2]',[3;4]',[3]'}; y={[10;20]',[30;40]',[10]'};
%! [vecx,vecy]=polyjoin(x,y);
%! assert (vecx, [1; 2; NaN; 3; 4; NaN; 3]);
%! assert (vecy, [10; 20; NaN; 30; 40; NaN; 10]);
