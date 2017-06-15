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

pol1 = [2 2; 6 2; 6 6; 2 6; 2 2; NaN NaN; 3 3; 3 5; 5 5; 5 3; 3 3];
pol2 = [1 2; 7 4; 4 7; 1 2; NaN NaN; 2 3; 5 4; 4 5; 2 3];


pol3 = [0 0; 50 0; 50 50 ; 0 50];
pol4 = [50 0; 150 0; 150 100; 50 100];

pkg load geometry

p0 = clipPolygon_mrf(pol1, pol2, 0);

p1 = clipPolygon_mrf(pol1, pol2, 1);

p2 = clipPolygon_mrf(pol1, pol2, 2);

p3 = clipPolygon_mrf(pol1, pol2, 3);
