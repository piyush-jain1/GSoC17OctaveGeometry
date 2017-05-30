## Copyright (C) 2017 - Piyush Jain
## Copyright (C) 2017 - Juan Pablo Carbajal
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program. If not, see <http://www.gnu.org/licenses/>.

## Benchmarking polynomial union
# We compare the oct-file implementation of polygon union of the clipper library
# with the oine provided by th emex interface.
pkg load geometry
c1 = [ 0.5, 0, 1];
c2 = [-0.5, 0, 1];
N  = 10;
p1 = circleAsPolygon (c1, N);
p2 = circleAsPolygon (c2, N);

tic
%PU = polyUnion(p1, p2);
toc

tic
cPU = clipPolygon(p1, p2, 3);
toc

clf
%drawPolygon (PU);
drawPolygon (cPU);

# Piyush: Both are same problems, there was an issue in handling NaN as
# delimeter, so I have provisionally used value-100000 in place of NaN
#x1 = [0 0; 10 0; 10 10; 0 10; 0 0; NaN NaN; 2 2; 8 2; 8 8; 8 2; 2 2;];
#y1 = [5 0; 15 0; 15 10; 5 10; 5 0; NaN NaN; 7 2; 7 8; 12 8; 12 2; 7 2;];

#x2 = [0 0; 10 0; 10 10; 0 10; 0 0; -100000 -100000; 2 2; 8 2; 8 8; 8 2; 2 2;];
#y2 = [5 0; 15 0; 15 10; 5 10; 5 0; -100000 -100000; 7 2; 7 8; 12 8; 12 2; 7 2;];


#tic()

#polyUnion(x2, y2)

#toc()

#tic()

#clipPolygon(x1, y1, 3)

#toc()
