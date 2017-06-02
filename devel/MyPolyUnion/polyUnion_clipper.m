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

function [outpol, npol] = polyUnion_clipper (inpoly, clipoly, op, library = "clipper")
	if ~(ismember (tolower (library), {"clipper"}))
	    error ('Octave:invalid-fun-call', "clipPolygon: unimplemented polygon clipping library: '%s'", library);
	endif
	if (nargin < 3)
		print_usage ();
	endif
	if (! isnumeric (inpoly) || size (inpoly, 2) < 2)
		error (" polyUnion: inpoly should be a numeric Nx2 array");
	endif
	if (! isnumeric (clipoly) || size (clipoly, 2) < 2)
		error (" polyUnion: clipoly should be a numeric Nx2 array");
	elseif (! isnumeric (op) || op < 0 || op > 3)
		error (" polyUnion: operation must be a number in the range [0..3]");
	endif

	[inpol, xy_mean, xy_magn] = __dbl2int64__ (inpoly, clipoly);
	clipol = __dbl2int64__ (clipoly, [], xy_mean, xy_magn);

	[outpol_x, outpol_y] = polyUnion (inpol, clipol, op);

	[outpol, npol] = getpoly(outpol_x, outpol_y, xy_magn, xy_mean);

endfunction