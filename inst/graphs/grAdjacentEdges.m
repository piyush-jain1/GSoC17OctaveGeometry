## Copyright (C) 2004-2016 David Legland <david.legland@grignon.inra.fr>
## Copyright (C) 2004-2016 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas)
## Copyright (C) 2016 Adapted to Octave by Juan Pablo Carbajal <ajuanpi+dev@gmail.com>
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

%GRADJACENTEDGES Find list of edges adjacent to a given node
%
%   NEIGHS = grAdjacentEdges(EDGES, NODE)
%   EDGES  the complete edges list (containing indices of neighbor nodes)
%   NODE   index of the node
%   NEIGHS the indices of edges containing the node index
%
%   See also
%     grAdjacentNodes

%   -----
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 13/08/2003.
%

%   HISTORY
%   10/02/2004 : documentation
%   13/07/2004 : faster algorithm
%   17/01/2006 : rename and change implementation

function neigh = grAdjacentEdges(edges, node)

  neigh = find(edges(:,1) == node | edges(:,2) == node);

endfunction

%!demo
%! pos                 = rand (10,2);
%! [~,idx] = min(sumsq(pos- mean(pos),2));
%! [nodes edges faces] = voronoi2d (pos);
%! neigh               = grAdjacentEdges (edges, idx);
%! #drawGraph (nodes, edges);
%! hold on
%! drawGraphEdges (nodes, edges(neigh,:), '-r');
%! plot(nodes(idx,1),nodes(idx,2),'og','markerfacecolor','g');
%! hold off
