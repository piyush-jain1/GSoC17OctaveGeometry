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


function [outpol, npol] = union (inpoly, clipoly, op, library = "clipper", varargin)
	if ~(ismember (tolower (library), {"clipper"}))
		error ('Octave:invalid-fun-call', "polyUnion: unimplemented polygon clipping library: '%s'", library);
	endif
	[outpol, npol] = polyUnion_clipper (inpoly, clipoly, op, varargin{:});
endfunction