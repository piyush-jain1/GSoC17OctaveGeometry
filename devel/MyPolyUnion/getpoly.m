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

function [outpol, npol] = getpoly(outpol_x, outpol_y, xy_magn, xy_mean)

	s = numel(outpol_x);
    x_mean = xy_mean(1);
    y_mean = xy_mean(2);

   	X = outpol_x(1:s-1)/xy_magn + x_mean;
   	Y = outpol_y(1:s-1)/xy_magn + y_mean;
 	
   	inds = find(isnan(X));
    count = length(inds);
    npol = count+1;
    inds(count+1) = (size(X))(1)+1;
    for i=count:-1:1
    	tmp = X(inds(i)+1);
    	for j=inds(i+1)-1:-1:inds(i)
    		X(j+i) = X(j);
    	end
    	X(inds(i+1)+i) = tmp;
    end
    X(inds(1)) = X(1);

    inds = find(isnan(Y));
    count = length(inds);
    inds(count+1) = (size(Y))(1)+1;
    for i=count:-1:1
    	tmp = Y(inds(i)+1);
    	for j=inds(i+1)-1:-1:inds(i)
    		Y(j+i) = Y(j);
    	end
    	Y(inds(i+1)+i) = tmp;
    end
    Y(inds(1)) = Y(1);
   
    outpol = [X Y];

endfunction