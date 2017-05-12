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
## @deftypefn {Function File} {@var{coefs}=} polynomialCurveSetFit (@var{img})
## @deftypefnx {Function File} {@dots{} =} polynomalCurveSetFit (@var{img}, @var{deg})
## @deftypefnx {Function File} {[@dots{} @var{lbl}] =} polynomalCurveSetFit (@dots{})
## Fit a set of polynomial curves to a segmented image
##
##   Result is a cell array of matrices. Each matrix is @var{deg}+1-by-2, and
##   contains coefficients of polynomial curve for each coordinate.
##   @var{bnds} contains the boundary of the parametrizations.
##   @var{img} is first binarised, then skeletonized.
##
##   Also returns an image of labels @var{lbl} for the segmented curves. The max label
##   is the number of curves, and the length of @var{coefs}.
##
##   Requires the toolboxes:
##   - Optimization
##   - Image Processing
##
## @seealso{polynomialCurves2d, polynomialCurveFit}
## @end deftypefn

function [coefs lblBranches] = polynomialCurveSetFit(seg, varargin)
  # default degree for curves
  deg = 2;
  if ~isempty(varargin)
      deg = varargin{1};
  end

  # ajoute un contour
  seg([1 end], :) = 1;
  seg(:, [1 end]) = 1;

  # skeletise le segmentat
  seg = bwmorph (seg, 'shrink', Inf);

  # compute image of multiple points (intersections between curves)
  imgNodes = imfilter (double (seg), ones ([3 3])) .* seg > 3;

  # compute coordinate of nodes, as c entroids of the multiple points
  lblNodes = bwlabel (imgNodes, 8);
  strct    = regionprops (lblNodes, 'Centroid');

  nodes = zeros (length (strct), 2);
  for i = 1:length (strct)
      nodes(i, [2 1]) = strct(i).Centroid;
  end

# debug
#  figure(1)
#  subplot(1,2,1)
#  imshow(seg);
#  hold on
#  plot(nodes(:,1),nodes(:,2),'og')
#  subplot(1,2,2)
#  imshow(imgNodes);
#  hold on
#  plot(nodes(:,1),nodes(:,2),'og')
#  keyboard

  # enleve les bords de l'image
  seg([1 end], :) = 0;
  seg(:, [1 end]) = 0;

  # Isolate the branches
  imgBranches = seg & ~imgNodes;
  lblBranches = bwlabel (imgBranches, 8);

  # # donne une couleur a chaque branche, et affiche
  # map = colorcube(max(lblBranches(:))+1);
  # rgbBranches = label2rgb(lblBranches, map, 'w', 'shuffle');
  # imshow(rgbBranches);

  # number of curves
  nBranches = max (lblBranches(:));

  # allocate memory
  coefs = cell (nBranches, 1);
  bnds  = cell (nBranches, 1);

  # For each curve, find interpolated polynomial curve
  for i = 1:nBranches
      # extract points corresponding to current curve
      imgBranch = lblBranches == i;
      points    = chainPixels (imgBranch);

      # check number of points is sufficient
      if size (points, 1) < max (deg+1-2, 2)
          # find labels of nodes
          inds = unique (lblNodes(imdilate(imgBranch, true (3,3))));
          inds = inds(inds ~= 0);

          if length (inds) < 2
              warning ("geometry:poylnomialCurveSetFit", ...
                       "Could not find extremities of branch number %d\n", i);
              continue;
          end

          # consider extremity nodes
          node0 = nodes(inds(1), :);
          node1 = nodes(inds(2), :);

          # use only a linear approximation
          xc = zeros(1, deg+1);
          yc = zeros(1, deg+1);
          xc(1) = node0(1);
          yc(1) = node0(2);
          xc(2) = node1(1)-node0(1);
          yc(2) = node1(2)-node0(2);

          # assigne au tableau de courbes
          coefs{i} = [xc;yc];
          # next branch
          continue;
      end

      # find nodes closest to first and last points of the current curve
      [dist, ind0] = minDistancePoints (points(1, :), nodes); ##ok<*ASGLU>
      [dist, ind1] = minDistancePoints (points(end, :), nodes);

      # add nodes to the curve.
      points = [nodes(ind0,:); points; nodes(ind1,:)]; ##ok<AGROW>

      # parametrization of the polyline
      t = parametrize (points);
      t = t / max (t);

      # fit a polynomial curve to the set of points
      [xc yc] = polynomialCurveFit (...
          t, points, deg, ...
          0, {points(1,1), points(1,2)},...
          1, {points(end,1), points(end,2)});

#debug
#      plot(points(:,1),points(:,2),'or')
#      hold on
#      drawPolynomialCurve ([0 1], xc,yc);
#      axis tight
#      v = axis();
#      hold off
#      imshow (~imgBranch)
#      hold on
#      plot(points(:,1),points(:,2),'or')
#      drawPolynomialCurve ([0 1], xc,yc);
#      axis xy
#      axis (v);
#      pause

      # stores result
      coefs{i} = [xc;yc];
  end

endfunction


function points = chainPixels(img, varargin)
#CHAINPIXELS return the list of points which constitute a curve on image
#   output = chainPixels(input)

  conn = 8;
  if ~isempty(varargin)
      conn = varargin{1};
  end

  # matrice de voisinage
  if conn == 4
      f = [0 1 0;1 1 1;0 1 0];
  elseif conn == 8
      f = ones([3 3]);
  end

  # find extremity points
  nb = imfilter(double(img), f) .* img;
  imgEnding = nb == 2 | nb == 1;
  [yi xi] = find(imgEnding);

  # extract coordinates of points
  [y x] = find(img);

  # index of first point
  if isempty(xi)
      # take arbitrary point
      ind = 1;
  else
      ind = find(x==xi(1) & y==yi(1));
  end

  # allocate memory
  points  = zeros(length(x), 2);

  if conn == 8
      for i = 1:size(points, 1)
          # avoid multiple neighbors (can happen in loops)
          ind = ind(1);

          # add current point to chained curve
          points(i,:) = [x(ind) y(ind)];

          # remove processed coordinate
          x(ind) = [];
          y(ind) = [];

          # find next candidate
          ind = find(abs(x-points(i,1))<=1 & abs(y-points(i,2))<=1);
      end

  else
      for i = 1:size(points, 1)
          # avoid multiple neighbors (can happen in loops)
          ind = ind(1);

          # add current point to chained curve
          points(i,:) = [x(ind) y(ind)];

          # remove processed coordinate
          x(ind) = [];
          y(ind) = [];

          # find next candidate
          ind = find(abs(x-points(i,1)) + abs(y-points(i,2)) <=1 );
      end
  end

endfunction

#FIXME not the best photo
%!demo
%! try
%!  pkg load image
%! catch
%!  error ('You need the image package');
%! end
%! disp ('Affected by bug https://savannah.gnu.org/bugs/?49757');
%!
%! [m, cmap] = imread ("default.img");
%! m         = ind2gray (m, cmap);
%! mbw       = im2bw(m, graythresh(m)*1.3);
%!
%! warning ("off", "geometry:poylnomialCurveSetFit", "local");
%! [c t] = polynomialCurveSetFit (mbw);
%!
%! figure(1)
%! clf;
%! imshow (m)
%! hold on
%! for i=1:numel(c)
%!   if !isempty (c{i})
%!     drawPolynomialCurve ([0 1], c{i});
%!   endif
%! endfor
%! hold off
