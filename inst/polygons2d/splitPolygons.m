## Copyright (C) 2004-2011 David Legland <david.legland@grignon.inra.fr>
## Copyright (C) 2004-2011 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas)
## Copyright (C) 2012-2016 Juan Pablo Carbajal <ajuanpi+dev@gmail.com>
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
## @deftypefn {Function File} {@var{polygons} = } splitPolygons (@var{polygon})
## Convert a NaN separated polygon list to a cell array of polygons.
##
## @var{polygon} is a N-by-M array of points, with possibly couples of NaN values.
## The functions separates each component separated by NaN values, and
## returns a cell array of polygons.
##
## @seealso{polygons2d}
## @end deftypefn

function [polygons inds] = splitPolygons(polygon)

  if iscell (polygon)
      # TODO: cell of nan separated polygons
      # case of a cell array
      error ("geometry:invalid-input-arg", ...
             "splitPolygons: can't handle cell of nan separated polygons");
             %polygons = polygon;

  else
    breakr = isnan (polygon(:,1));
    if all (~breakr)
      # single polygon -> no break
      polygons = {polygon};
    else
      # find indices of NaN couples
      inds = find (breakr);

      # number of polygons
      N        = length (inds);
      polygons = cell (N+1, 1);

      # iterate over NaN-separated regions to create new polygon
      polygons{1}   = polygon(1:(inds(1)-1), :);
      polygons{end} = polygon((inds(end)+1):end, :);
      for i=2:N
          polygons{i} = polygon((inds(i-1)+1):(inds(i)-1), :);
      end
    end
  end

endfunction

%!test
%! p = [1; nan; 2]; pc = {1;2};
%! assert (splitPolygons (p), pc);

%!test
%! p = [1; nan; 2; nan; 3]; pc = {1;2;3};
%! assert (splitPolygons (p), pc);

%!test
%! p = [1; nan; 2; nan; 3]; idx_ = [2;4];
%! [~,idx] = splitPolygons (p);
%! assert (idx, idx_)
