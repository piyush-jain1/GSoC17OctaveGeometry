## Copyright (C) 2004-2011 David Legland <david.legland@grignon.inra.fr>
## Copyright (C) 2004-2011 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas)
## Copyright (C) 2012 Adapted to Octave by Juan Pablo Carbajal <carbajal@ifi.uzh.ch>
## Copyright (C) 2016 Amr Mohamed <amr_mohamed@live.com>
##
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
## @deftypefn {Function File}[@var{cellx},@var{celly}] = polysplit(@var{vecx},@var{vecy})
## Convert NaN separated polygon vectors to cell arrays of polygons.
##
## @var{vecx}/@var{vecy} is a row/column vector of points, with possibly couples of NaN values.
##
## The function separates each component separated by NaN values, and
## returns a cell array of polygons.
##
## @seealso{polyjoin,ispolycw}
## @end deftypefn

function [cellx,celly] = polysplit(vecx,vecy)

if (nargin != 2)
  #case wrong number of input arguments
   print_usage();
endif

if (iscell (vecx))
  if (iscell (vecy))
    # case of having two cell array
    cellx = vecx;
    celly = vecy;
  else
    error ('vecx and vecy have different forms');
  endif

elseif (length (vecx)!=length (vecy))
  # case of having two vectors of different lengthes
  error ('vecx and vecy should have the same length');

elseif (sum (isnan (vecx(:)))==0) 
  # single polygon -> no break
  if(sum (isnan (vecy(:)))==0)
    cellx = {vecx};
    celly = {vecy};
  else
    error('vecx and vecy should have the same number of polygon segments');
  endif
      
else
  isrowvectors=0;
  # find indices of NaN couples
  if(isrow (vecx))
    if(isrow (vecy))
      isrowvectors=1;
    else
      error ('vecx and vecy have different sizes');
    endif
  endif

  xnans = sum (isnan (vecx));
  ynans = sum (isnan (vecy));
  if(xnans!=ynans)
    error ('vecx and vecy have different number of segments');
  endif
  # number of polygons
  N = xnans+1;
      
  # find positions of NaN(s) in the vector
  # a polygon is extracted as the range of points between two successive NaN values
  # N polygons -> N+1 range endpoints
  naninds=zeros (N+1,1);
  curindex=2;
  lastisnan=1;
  for i=1:length (vecx)
    if(isnan (vecx(i)) && isnan (vecy(i)))
      if(!lastisnan)
        naninds(curindex)=i;
        curindex++;
        lastisnan=1;
      else
        naninds(curindex)=i;
        curindex++;
        lastisnan=1;
        N--;
      endif
    elseif(isnan (vecx(i)) || isnan (vecy(i)))
      error ('Different NaN Locations');
    else
      lastisnan=0;
    endif    
  endfor

  naninds(end)=length(vecx)+1;
  if(isnan (vecx(end)))
    N--;
  endif
      
  cellx = cell (N, 1);
  celly = cell (N, 1);
  # iterate over NaN-separated regions to create new polygons 
  polyindex=1;
  for nancurind=1:length (naninds)-1
    if(isrowvectors)
      if(naninds(nancurind+1)!=1+naninds(nancurind))
        cellx{polyindex}=vecx(:, (naninds(nancurind)+1):(naninds(nancurind+1)-1));
        celly{polyindex}=vecy(:, (naninds(nancurind)+1):(naninds(nancurind+1)-1));
        polyindex++;
      endif
    else
      if(naninds(nancurind+1)!=1+naninds(nancurind))
        cellx{polyindex} =vecx((naninds(nancurind)+1):(naninds(nancurind+1)-1), :);
        celly{polyindex} =vecy((naninds(nancurind)+1):(naninds(nancurind+1)-1), :);
        polyindex++;
      endif   
    endif
  endfor
      
  endif
endfunction

%!test
%! x=[1 2 NaN 3 4]; y=[4 3 NaN 2 1];
%! [cellx,celly]=polysplit(x,y);
%! assert (cellx, {[1 2];[3 4]});
%! assert (celly, {[4 3];[2 1]});

%!test
%! x=[1 ;2 ;NaN ;3 ;4]; y=[4 ;3 ;NaN ;2 ;1];
%! [cellx,celly]=polysplit(x,y);
%! assert (cellx, {[1; 2];[3; 4]});
%! assert (celly, {[4; 3];[2; 1]});

%!test
%! x=[0 ;2 ;2 ;0 ;0 ;NaN ;NaN]; y=[0 ;0 ;3 ;3 ;0 ;NaN ;NaN];
%! [cellx,celly]=polysplit(x,y);
%! assert (cellx, {[0 ;2 ;2 ;0 ;0]});
%! assert (celly, {[0 ;0 ;3 ;3 ;0]});