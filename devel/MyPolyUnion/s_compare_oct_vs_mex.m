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
# with the one provided by the mex interface.
pkg load geometry

c1 = [ 0.5, 0, 5];
c2 = [-0.5, 0, 5];

N = 5;
p1 = circleAsPolygon (c1, N);
p2 = circleAsPolygon (c2, N);
PU = union(p1, p2, 3);
cPU = clipPolygon(p1, p2, 3);

# generating data for the elapsed time for both the methods over a parameter N
# JPi: pre-allocate the arrays to speed up!
# spaces not TABS!
for N=100:100:10000
  p1 = circleAsPolygon (c1, N);
  p2 = circleAsPolygon (c2, N);
  tic
  PU                 = union (p1, p2, 3);
  elapsed_time_PU(N) = toc;
  tic
  cPU                 = clipPolygon (p1, p2, 3);
  elapsed_time_cPU(N) = toc;
end

## Plotting graphs to compare the elapsed time of both
x  = 100:100:10000;
y1 = elapsed_time_PU(x);
y2 = elapsed_time_cPU(x);
## polyUnion in blue color
## clipPolygon in red color
plot (x,y1,'b;oct;', x, y2,'r;mex;');
xlabel ("# of polygon vertices")
ylabel ("Elapsed time [s]")








