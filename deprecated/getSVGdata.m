## Copyright (C) 2012 Juan Pablo Carbajal <carbajal@ifi.uzh.ch>
##
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation; either version 3 of the License, or (at your option) any later
## version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License along with
## this program; if not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{} =} getSVGdata (@var{}, @var{})
##
## @end deftypefn
function svgData = getSVGdata(svg)

    svgData = struct('height',[],'width',[]);
    attr    = fieldnames(svgData);
    nattr   = numel(attr);

    [s e te data] = regexpi(svg,'<[ ]*svg(?:(?!>).)*>');
    data=strtrim(data{1});

    for a = 1:nattr
        pattr =sprintf('%s="(?:(?!").)*',attr{a});
        [s e te m] = regexpi(data,pattr);
        m=strtrim(m{1});
        [dummy value] = strread(m,'%s%f','delimiter','"');
        svgData.(attr{a}) = value;
    end

end
