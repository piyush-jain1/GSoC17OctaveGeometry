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

%GRREMOVEEDGES Remove several edges from a graph
%
%   [NODES2 EDGES2] = grRemoveEdges(NODES, EDGES, EDGES2REMOVE)
%   Remove some edges in the edges list, and return the modified graph.
%   The NODES array is not modified.
%
%   -----
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 13/08/2003.
%

%   HISTORY :
%   10/02/2004 : doc

function [nodes2, edges2] = grRemoveEdges(nodes, edges, rmEdges)

  rmEdges = sort(rmEdges);

  % do not change the node list
  nodes2 = nodes;

  % number of edges
  N   = size(edges, 1);
  NR  = length(rmEdges);
  N2  = N - NR;

  % allocate memory for new  edges list
  edges2 = zeros(N2, 2);

  % case of no edge to remove
  if NR == 0
      nodes2 = nodes;
      edges2 = edges;
      return;
  end

  % process the first edge
  edges2(1:rmEdges(1)-1,:) = edges(1:rmEdges(1)-1,:);

  % process the classical edges
  for i = 2:NR
      %if rmEdges(i)-i < rmEdges(i-1)-i+2 
      %    continue;
      %end
      edges2(rmEdges(i-1)-i+2:rmEdges(i)-i, :) = edges(rmEdges(i-1)+1:rmEdges(i)-1, :);
  end

  % process the last edge
  edges2(rmEdges(NR)-NR+1:N2, :) = edges(rmEdges(NR)+1:N, :);
endfunction

%!demo
%! nodes = [0 0; 0 1; 1 1; 0.3 0.7];
%! edges = [1 2; 2 3; 3 1; 1 4; 2 4; 3 4];
%! [n2 e2] = grRemoveEdges (nodes, edges, 1:3);
%! drawGraph (nodes,edges,{"k","markerfacecolor", "w"}, {"color","k"});
%! hold on
%! drawGraph (n2,e2,'none', {"color","r"});
%! hold off
