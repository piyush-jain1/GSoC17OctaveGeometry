## Copyright (C) 2003-2011 David Legland
## Copyright (C) 2015 Adapted by Juan Pablo Carbajal
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
##
## The views and conclusions contained in the software and documentation are
## those of the authors and should not be interpreted as representing official
## policies, either expressed or implied, of the copyright holders.

## Author: David Legland <david.legland@grignon.inra.fr>
## Adapted: JuanPi Carbajal <ajuanpi+dev@gmail.com>

## -*- texinfo -*-
## @deftypefn {Function File} {[@var{P}, @var{D}] =} projPointOnPolyline (@var{point}, @var{poly})
## @deftypefnx {Function File} {[@dots{}] =} projPointOnPolyline (@dots{}, @var{closed})
##
## Compute the position of the orthogonal projection of a point on a
## polyline.
##
## @var{point} is a 1x2 row vector containing point coordinates
## @var{poly} is a Nx2 array containing coordinates of polyline vertices
## @var{pos} is the position of the point on the polyline, between 0 and the
## number of vertices of the polyline. @var{pos} can be a non-integer value, in
## this case, the integer part correspond to the polyline edge index
## (between 0 and N-1), and the floating-point part correspond to the
## relative position on i-th edge (between 0 and 1, 0: edge start, 1: edge
## end).
##
## When @var{point} is an array of points, returns a column vector with as many
## rows as the number of points.
##
## If third input argument @var{closed} is given, it specifies if the polyline
## is closed or not. @var{closed} can be one of:
## @table @asis
## @item 'closed'
## The polyline is closed
##
## @item 'open'
## The polyline is open
##
## @item a logical column vector
## It should have the same number of elements as the number of points and it
## specifies individually if each polyline is closed (true=closed).
##
## @end table
##
## @seealso{points2d, polygons2d, polylinePoint, distancePointPolyline}
## @end deftypefn

function [pos minDist] = projPointOnPolyline (point, poly, closed=false)

  warning ('Octave:deprecated-keyword', ...
           "This function is deprecated use distancePointPolyline instead.\n");

  [minDist pos] = distancePointPolyline (point, poly, closed);

#  # check if input polyline is closed or not
#  if strcmp ('closed', closed)
#      closed = true;
#  elseif strcmp ('open', closed)
#      closed = false;
#  endif

#  # closes the polyline if necessary
#  if closed
#      poly = [poly; poly(1,:)];
#  endif

#  # number of points
#  Np = size (point, 1);

#  # number of vertices in polyline
#  Nv = size (poly, 1);

#  # allocate memory results
#  pos     = zeros (Np, 1);
#  minDist = inf (Np, 1);

#  # iterate on points
#  for p=1:Np
#      # compute smallest distance to each edge
#      for i=1:Nv-1
#          # build current edge
#          edge = [poly(i,:) poly(i+1,:)];

#          # compute distance between current point and edge
#          [dist edgePos] = distancePointEdge (point(p, :), edge);

#          # update distance and position if necessary
#          if dist < minDist(p)
#              minDist(p) = dist;
#              pos(p)     = i - 1 + edgePos;
#          endif
#      endfor
#  endfor

endfunction

%!demo
%! warning ("off", "Octave:deprecated-keyword", "local");
%! point   = [2 1] .* rand (10,2) - [1 0];
%! t       = linspace (0,pi,25).';
%! poly    = [cos(t) sin(t)];
%! [pos d] = arrayfun (@(i)projPointOnPolyline (point(i,:),poly), (1:10).');
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
