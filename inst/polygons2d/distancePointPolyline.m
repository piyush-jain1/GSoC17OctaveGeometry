## Copyright (C) 2004-2011 David Legland
## Copyright (C) 2004-2011 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas)
## Copyright (C) 2016 Juan Pablo Carbajal
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

## Author: 2004-2011 David Legland <david.legland@grignon.inra.fr>
## Author: 2016 Juan Pablo Carbajal <ajuanpi+dev@gmail.com>

## -*- texinfo -*-
## @deftypefn {Function File} {@var{dist} = } distancePointPolyline (@var{point},@var{poly})
## @deftypefnx {Function File} {[@var{dist} @var{pos}] = } distancePointPolyline (@var{point},@var{poly})
##  Compute shortest distance @var{dist} between a point and a polyline
##
## If the the second output argument @var{pos} is requested, the function also
## returns the position of closest point on the polyline. @var{pos} is comprised
## between 0 and NV, the number of polyline vertices.
##
##   Example:
## @example
##       pt1 = [30 20];
##       pt2 = [30 5];
##       poly = [10 10;50 10;50 50;10 50];
##       distancePointPolyline([pt1;pt2], poly)
##       ans =
##           10
##            5
## @end example
##
## @seealso{polygons2d, points2d,distancePointEdge, projPointOnPolyline}
## @end deftypefn

function [minDist pos] = distancePointPolyline (point, poly, closed = false)

  # check if input polyline is closed or not
  if strcmp ('closed', closed)
      closed = true;
  elseif strcmp ('open', closed)
      closed = false;
  endif

  # closes the polyline if necessary
  if closed
      poly = [poly; poly(1,:)];
  endif

  # number of points
  Np = size (point, 1);

  # allocate memory for result
  minDist = inf (Np, 1);

  ## construct the set of edges
  edges = [poly(1:end-1, :) poly(2:end, :)];

  ## compute distance between current each point and all edges
  [dist edgepos] = distancePointEdge (point, edges);

  ## get the minimum distance
  [minDist i] = min (dist, [], 2);

  # Contributed by Raghu Charan A 02.2016
  pos = [];
  if nargout == 2
    Ne = size (edgepos, 2);
    j  = sub2ind ([Np,Ne], (1:Np).', i);
    pos = i - 1 + edgepos(j);
  endif

endfunction

%!demo
%! point   = [2 1] .* rand (10,2) - [1 0];
%! t       = linspace (0,pi,25).';
%! poly    = [cos(t) sin(t)];
%! [d pos] = distancePointPolyline (point,poly);
%!
%! # Calculate the projection on the polyline to plot
%! p_ = zeros (10, 2);
%!
%! # projection on vertices of the polyline
%! isvertex       = abs (pos - fix (pos)) < eps;
%! p_(isvertex,:) = poly (pos(isvertex)+1,:);
%!
%! # the rest
%! pos             = pos (!isvertex);
%! i               = fix (pos) + 1;
%! x               = pos - fix (pos);
%! p_(!isvertex,:) = poly(i,:) + x.*(poly(i+1,:)-poly(i,:));
%!
%! # Plot
%! plot (poly(:,1), poly(:,2),'.-', ...
%!       point(:,1), point(:,2), 'o', ...
%!       p_(:,1), p_(:,2),'.');
%! legend ('Polyline', 'Points', 'Projections');
%! line ([point(:,1) p_(:,1)].',[point(:,2) p_(:,2)].');
%! arrayfun (@(i)text ((p_(i,1)+point(i,1))/2, (p_(i,2)+point(i,2))/2, ...
%!               sprintf("%.2f", d(i))), 1:10);
%! axis tight
%! axis equal
