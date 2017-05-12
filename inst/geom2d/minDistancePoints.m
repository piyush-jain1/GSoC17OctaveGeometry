%% Copyright (C) 2004-2011 David Legland <david.legland@inra.fr>
%% Copyright (C) 2016 Juan Pablo Carbajal <ajuanpi+dev@gmail.com>
%% All rights reserved.
%%
%% Redistribution and use in source and binary forms, with or without
%% modification, are permitted provided that the following conditions are met:
%%
%%     1 Redistributions of source code must retain the above copyright notice,
%%       this list of conditions and the following disclaimer.
%%     2 Redistributions in binary form must reproduce the above copyright
%%       notice, this list of conditions and the following disclaimer in the
%%       documentation and/or other materials provided with the distribution.
%%
%% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ''AS IS''
%% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
%% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
%% ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
%% ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
%% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
%% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
%% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
%% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
%% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

%% -*- texinfo -*-
%% @deftypefn {Function File} {@var{dist} = } minDistancePoints (@var{pts})
%% @deftypefnx {Function File} {@var{dist} = } minDistancePoints (@var{pts1},@var{pts2})
%% @deftypefnx {Function File} {@var{dist} = } minDistancePoints (@dots{},@var{norm})
%% @deftypefnx {Function File} {[@var{dist} @var{i} @var{j}] = } minDistancePoints (@var{pts1}, @var{pts2}, @dots{})
%% @deftypefnx {Function File} {[@var{dist} @var{j}] = } minDistancePoints (@var{pts1}, @var{pts2}, @dots{})
%% Minimal distance between several points.
%%
%%   Returns the minimum distance between all couple of points in @var{pts}. @var{pts} is
%%   an array of [NxND] values, N being the number of points and ND the
%%   dimension of the points.
%%
%%   Computes for each point in @var{pts1} the minimal distance to every point of
%%   @var{pts2}. @var{pts1} and @var{pts2} are [NxD] arrays, where N is the number of points,
%%   and D is the dimension. Dimension must be the same for both arrays, but
%%   number of points can be different.
%%   The result is an array the same length as @var{pts1}.
%%
%%   When @var{norm} is provided, it uses a user-specified norm. @var{norm}=2 means euclidean norm (the default),
%%   @var{norm}=1 is the Manhattan (or "taxi-driver") distance.
%%   Increasing @var{norm} growing up reduces the minimal distance, with a limit
%%   to the biggest coordinate difference among dimensions.
%%
%%   Returns indices @var{i} and @var{j} of the 2 points which are the closest. @var{dist}
%%   verifies relation:
%%   @var{dist} = distancePoints(@var{pts}(@var{i},:), @var{pts}(@var{j},:));
%%
%%   If only 2 output arguments are given, it returns the indices of points which are the closest. @var{j} has the
%%   same size as @var{dist}. for each I It verifies the relation :
%%   @var{dist}(I) = distancePoints(@var{pts1}(I,:), @var{pts2}(@var{J},:));
%%
%%
%%   Examples:
%%
%% @example
%%   % minimal distance between random planar points
%%       points = rand(20,2)*100;
%%       minDist = minDistancePoints(points);
%%
%%   % minimal distance between random space points
%%       points = rand(30,3)*100;
%%       [minDist ind1 ind2] = minDistancePoints(points);
%%       minDist
%%       distancePoints(points(ind1, :), points(ind2, :))
%%   % results should be the same
%%
%%   % minimal distance between 2 sets of points
%%       points1 = rand(30,2)*100;
%%       points2 = rand(30,2)*100;
%%       [minDists inds] = minDistancePoints(points1, points2);
%%       minDists(10)
%%       distancePoints(points1(10, :), points2(inds(10), :))
%%   % results should be the same
%% @end example
%%
%%   @seealso{points2d, distancePoints}
%% @end deftypefn

function varargout = minDistancePoints (p1, varargin)

  %% Initialisations
  % default norm (euclidean)
  n = 2;
  % a single array is given
  one_array = true;
  % process input variables
  if nargin == 1
      % specify only one array of points, not the norm
      p2 = p1;
  elseif nargin == 2
      if isscalar (varargin{1})
          % specify array of points and the norm
          n   = varargin{1};
          p2  = p1;
      else
          % specify two arrays of points
          p2           = varargin{1};
          one_array = false;
      end
  elseif nargin == 3
      % specify two array of points and the norm
      p2        = varargin{1};
      n         = varargin{2};
      one_array = false;
  else
    error ('Wrong number of input arguments');
  end

  % number of points in each array
  n1  = size (p1, 1);
  n2  = size (p2, 1);
  % dimension of points
  d   = size (p1, 2);

  %% Computation of distances
  % allocate memory
  dist = zeros (n1, n2);
  % Compute difference of coordinate for each pair of point (n1-by-n2 array)
  % and for each dimension. -> dist is a n1-by-n2 array.
  % in 2D: dist = dx.*dx + dy.*dy;
  if n == inf
    % infinite norm corresponds to maximum absolute value of differences
    % in 2D: dist = max(abs(dx) + max(abs(dy));
    for i=1:d
        dist = max (dist, abs(bsxfun (@minus, p1(:,i), p2(:,i).')));
    end
  else
    for i=1:d
        dist = dist + abs (bsxfun (@minus, p1(:,i), p2(:,i).')).^n;
    end
  end
  % TODO the previous could be optimized when a single array  is given (maybe!)

  % If two array of points where given
  if ~one_array
    [minSqDist ind] = min(dist, [], 2);
    minDist         = power (minSqDist, 1/n);
    [ind2 ind1]     = ind2sub ([n1 n2], ind);
  else
    % A single array was given
    dist            = dist + diag (inf (n1,1)); % remove zeros from diagonal
    dist            = vech (dist);
    [minSqDist ind] = min (dist); % index on packed lower trinagular matrix
    minDist         = power (minSqDist, 1/n);

    [ind2 ind1]     = ind2sub_tril (n1, ind);
    ind             = sub2ind ([n1 n1], ind2, ind1);
  endif

  %% format output parameters
  % format output depending on number of asked parameters
  if nargout<=1
      varargout{1} = minDist;
  elseif nargout==2
      % If two arrays are asked, 'ind' is an array of indices of p2, one for each
      % point in p1, corresponding to the result in minDist
      varargout{1} = minDist;
      varargout{2} = ind;
  elseif nargout==3
      % If only one array is asked, minDist is a scalar, ind1 and ind2 are 2
      % indices corresponding to the closest points.
      varargout{1} = minDist;
      varargout{2} = ind1;
      varargout{3} = ind2;
  end

endfunction

%!xtest
%!  pts = [50 10;40 60;30 30;20 0;10 60;10 30;0 10];
%!  assert (minDistancePoints(pts), 20);

%!xtest
%!  pts = [10 10;25 5;20 20;30 20;10 30];
%!  [dist ind1 ind2] = minDistancePoints(pts);
%!  assert (10, dist, 1e-6);
%!  assert (3, ind1, 1e-6);
%!  assert (4, ind2, 1e-6);

%!xtest
%!  pts = [0 80;10 60;20 40;30 20;40 0;0 0;100 0;0 100;0 -10;-10 -20];
%!  assert (minDistancePoints([40 50], pts), 10*sqrt(5), 1e-6);
%!  assert (minDistancePoints([25 30], pts), 5*sqrt(5), 1e-6);
%!  assert (minDistancePoints([30 40], pts), 10, 1e-6);
%!  assert (minDistancePoints([20 40], pts), 0, 1e-6);

%!xtest
%!  pts = [50 10;40 60;40 30;20 0;10 60;10 30;0 10];
%!  assert (minDistancePoints(pts, 1), 30, 1e-6);
%!  assert (minDistancePoints(pts, 100), 20, 1e-6);

%!xtest
%! points = rand(30,3)*100;
%! [minDist ind1 ind2] = minDistancePoints(points);
%! assert (minDist, distancePoints(points(ind1, :), points(ind2, :)), sqrt(eps));

%!test
%!  pts = [0 80;10 60;20 40;30 20;40 0;0 0;100 0;0 100;0 -10;-10 -20];
%!  assert (minDistancePoints([40 50], pts, 2), 10*sqrt(5), 1e-6);
%!  assert (minDistancePoints([25 30], pts, 2), 5*sqrt(5), 1e-6);
%!  assert (minDistancePoints([30 40], pts, 2), 10, 1e-6);
%!  assert (minDistancePoints([20 40], pts, 2), 0, 1e-6);
%!  assert (minDistancePoints([40 50], pts, 1), 30, 1e-6);
%!  assert (minDistancePoints([25 30], pts, 1), 15, 1e-6);
%!  assert (minDistancePoints([30 40], pts, 1), 10, 1e-6);
%!  assert (minDistancePoints([20 40], pts, 1), 0, 1e-6);

%!test
%!  pts1 = [40 50;25 30;40 20];
%!  pts2 = [0 80;10 60;20 40;30 20;40 0;0 0;100 0;0 100;0 -10;-10 -20];
%!  res = [10*sqrt(5);5*sqrt(5);10];
%!  assert (minDistancePoints(pts1, pts2), res, 1e-6);


%!test
%!  pts1 = [40 50;25 30;40 20];
%!  pts2 = [0 80;10 60;20 40;30 20;40 0;0 0;100 0;0 100;0 -10;-10 -20];
%!  res1 = [10*sqrt(5);5*sqrt(5);10];
%!  assert (minDistancePoints(pts1, pts2, 2), res1, 1e-6);
%!  res2 = [30;15;10];
%!  assert (minDistancePoints(pts1, pts2, 1), res2);

%!test
%!  pts1    = [40 50;20 30;40 20];
%!  pts2    = [0 80;10 60;20 40;30 20;40 0;0 0;100 0;0 100;0 -10;-10 -20];
%!  dists0  = [10*sqrt(5);10;10];
%!  inds1   = [3;3;4];
%!  [minDists inds] = minDistancePoints(pts1, pts2);
%!  assert (dists0, minDists);
%!  assert (inds1, inds);

%!xtest %bug 50084
%! pt1 = [1  1];
%! pts = [0 0; 1 0; 1 1; 0 1; 1 2];
%! [d, r, c] = minDistancePoints (pt1, pts);
%! assert (d, 0, sqrt(eps));
%! assert (r, 3, sqrt(eps));
%! assert (c, 1, sqrt(eps));

%%%%%%%%%%%%%
% SUBFUNCTION

%% -*- texinfo -*-
%% @deftypefn {Function File} {[ @var{r}, @var{c} ] = } ind2sub_tril (@var{N}, @var{idx})
%% Convert a linear index to subscripts of a trinagular matrix.
%%
%% An example of trinagular matrix linearly indexed follows
%%
%% @example
%%          N = 4;
%%          A = -repmat (1:N,N,1);
%%          A += repmat (diagind, N,1) - A.';
%%          A = tril(A)
%%          => A =
%%              1    0    0    0
%%              2    5    0    0
%%              3    6    8    0
%%              4    7    9   10
%% @end example
%%
%% The following example shows how to convert the linear index `6' in
%% the 4-by-4 matrix of the example into a subscript.
%%
%% @example
%%          [r, c] = ind2sub_tril (4, 6)
%%          => r =  3
%%            c =  2
%% @end example
%%
%% when @var{idx} is a row or column matrix of linear indeces then @var{r} and
%% @var{c} have the same shape as @var{idx}.
%%
%% @seealso{vech, ind2sub, sub2ind_tril}
%% @end deftypefn

function [r c] = ind2sub_tril (N,idx)

  endofrow = 0.5 * (1:N) .* (2*N:-1:N + 1);
  c        = lookup (endofrow, idx - 1) + 1;
  r        = N - endofrow(c) + idx ;

end
