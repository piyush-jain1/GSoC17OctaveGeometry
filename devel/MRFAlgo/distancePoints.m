## Copyright (C) 2004-2011 David Legland <david.legland@grignon.inra.fr>
## Copyright (C) 2004-2011 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas)
## Copyright (C) 2012 Adapted to Octave by Juan Pablo Carbajal <carbajal@ifi.uzh.ch>
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

## -*- texinfo -*-
## @deftypefn {Function File} {@var{d} = } distancePoints (@var{p1}, @var{p2})
## @deftypefnx {Function File} {@var{d} = } distancePoints (@var{p1}, @var{p2}, @var{norm})
## @deftypefnx {Function File} {@var{d} = } distancePoints (@dots{}, 'diag')
## Compute distance between two points.
##
##   Returns the Euclidean distance between points @var{p1} and @var{p2}.
##   If @var{p1} and @var{p2} are two arrays of points, result is a N1xN2 array
##   containing distance between each point of @var{p1} and each point of @var{p2}. 
##
##   Is @var{norm} is given, computes distance using the specified norm. @var{norm}=2 corresponds to usual
##   euclidean distance, @var{norm}=1 corresponds to Manhattan distance, @var{norm}=inf
##   is assumed to correspond to maximum difference in coordinate. Other
##   values (>0) can be specified.
##
##   When 'diag' is given, computes only distances between @var{p1}(i,:) and @var{p2}(i,:).
##
##   @seealso{points2d, minDistancePoints}
## @end deftypefn

function dist = distancePoints(p1, p2, varargin)

  ## Setup options

  # default values
  diag = false;
  norm = 2;

  # check first argument: norm or diag
  if ~isempty(varargin)
      var = varargin{1};
      if isnumeric(var)
          norm = var;
      elseif strncmp('diag', var, 4)
          diag = true;
      end
      varargin(1) = [];
  end

  # check last argument: diag
  if ~isempty(varargin)
      var = varargin{1};
      if strncmp('diag', var, 4)
          diag = true;
      end
  end


  # number of points in each array and their dimension
  n1  = size(p1, 1);
  n2  = size(p2, 1);
  d   = size(p1, 2);

  if diag
      # compute distance only for apparied couples of pixels
      dist = zeros(n1, 1);
      if norm==2
          # Compute euclidian distance. this is the default case
          # Compute difference of coordinate for each pair of point
          # and for each dimension. -> dist is a [n1*n2] array.
          for i=1:d
              dist = dist + (p2(:,i)-p1(:,i)).^2;
          end
          dist = sqrt(dist);
      elseif norm==inf
          # infinite norm corresponds to maximal difference of coordinate
          for i=1:d
              dist = max(dist, abs(p2(:,i)-p1(:,i)));
          end
      else
          # compute distance using the specified norm.
          for i=1:d
              dist = dist + power((abs(p2(:,i)-p1(:,i))), norm);
          end
          dist = power(dist, 1/norm);
      end
  else
      # compute distance for all couples of pixels
      dist = zeros(n1, n2);
      if norm==2
          # Compute euclidian distance. this is the default case
          # Compute difference of coordinate for each pair of point
          # and for each dimension. -> dist is a [n1*n2] array.
          for i=1:d
              # equivalent to:
              # dist = dist + ...
              #   (repmat(p1(:,i), [1 n2])-repmat(p2(:,i)', [n1 1])).^2;
              dist = dist + (p1(:, i*ones(1, n2))-p2(:, i*ones(n1, 1))').^2;
          end
          dist = sqrt(dist);
      elseif norm==inf
          # infinite norm corresponds to maximal difference of coordinate
          for i=1:d
              dist = max(dist, abs(p1(:, i*ones(1, n2))-p2(:, i*ones(n1, 1))'));
          end
      else
          # compute distance using the specified norm.
          for i=1:d
              # equivalent to:
              # dist = dist + power((abs(repmat(p1(:,i), [1 n2]) - ...
              #     repmat(p2(:,i)', [n1 1]))), norm);
              dist = dist + power((abs(p1(:, i*ones(1, n2))-p2(:, i*ones(n1, 1))')), norm);
          end
          dist = power(dist, 1/norm);
      end
  end

endfunction

%!shared pt1,pt2,pt3,pt4
%!  pt1 = [10 10];
%!  pt2 = [10 20];
%!  pt3 = [20 20];
%!  pt4 = [20 10];

%!assert (distancePoints(pt1, pt2), 10, 1e-6);
%!assert (distancePoints(pt2, pt3), 10, 1e-6);
%!assert (distancePoints(pt1, pt3), 10*sqrt(2), 1e-6);
%!assert (distancePoints(pt1, pt2, 1), 10, 1e-6);
%!assert (distancePoints(pt2, pt3, 1), 10, 1e-6);
%!assert (distancePoints(pt1, pt3, 1), 20, 1e-6);
%!assert (distancePoints(pt1, pt2, inf), 10, 1e-6);
%!assert (distancePoints(pt2, pt3, inf), 10, 1e-6);
%!assert (distancePoints(pt1, pt3, inf), 10, 1e-6);
%!assert (distancePoints(pt1, [pt1; pt2; pt3]), [0 10 10*sqrt(2)], 1e-6);

%!test
%!  array1 = [pt1;pt2;pt3];
%!  array2 = [pt1;pt2;pt3;pt4];
%!  res = [0 10 10*sqrt(2) 10; 10 0 10 10*sqrt(2); 10*sqrt(2) 10 0 10];
%!  assert (distancePoints(array1, array2), res, 1e-6);
%!  assert (distancePoints(array2, array2, 'diag'), [0;0;0;0], 1e-6);

%!test
%!  array1 = [pt1;pt2;pt3];
%!  array2 = [pt2;pt3;pt1];
%!  assert (distancePoints(array1, array2, inf, 'diag'), [10;10;10], 1e-6);

%!shared pt1,pt2,pt3,pt4
%!  pt1 = [10 10 10];
%!  pt2 = [10 20 10];
%!  pt3 = [20 20 10];
%!  pt4 = [20 20 20];

%!assert (distancePoints(pt1, pt2), 10, 1e-6);
%!assert (distancePoints(pt2, pt3), 10, 1e-6);
%!assert (distancePoints(pt1, pt3), 10*sqrt(2), 1e-6);
%!assert (distancePoints(pt1, pt4), 10*sqrt(3), 1e-6);
%!assert (distancePoints(pt1, pt2, inf), 10, 1e-6);
%!assert (distancePoints(pt2, pt3, inf), 10, 1e-6);
%!assert (distancePoints(pt1, pt3, inf), 10, 1e-6);
%!assert (distancePoints(pt1, pt4, inf), 10, 1e-6);


%!shared pt1,pt2,pt3,pt4
%!  pt1 = [10 10 30];
%!  pt2 = [10 20 30];
%!  pt3 = [20 20 30];
%!  pt4 = [20 20 40];

%!assert (distancePoints(pt1, pt2, 1), 10, 1e-6);
%!assert (distancePoints(pt2, pt3, 1), 10, 1e-6);
%!assert (distancePoints(pt1, pt3, 1), 20, 1e-6);
%!assert (distancePoints(pt1, pt4, 1), 30, 1e-6);

%!test
%!  array1 = [pt1;pt2;pt3];
%!  array2 = [pt2;pt3;pt1];
%!  assert (distancePoints(array1, array2, 'diag'), [10;10;10*sqrt(2)], 1e-6);
%!  assert (distancePoints(array1, array2, 1, 'diag'), [10;10;20], 1e-6);
