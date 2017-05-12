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

function SVGpath = SVGstrPath2SVGpath (SVGstrPath)

    nPaths = numel (SVGstrPath);
    SVGpath = repmat (struct('coord', [], 'closed', [], 'id', []), 1, nPaths);

    for ip = 1:nPaths
        path = SVGstrPath{ip};

        # Match data
        [s e te m] = regexpi (path, 'd="(?:(?!").)*');
        data=strtrim (m{1});
        # parse data
        d = parsePathData (data);
        SVGpath(ip).coord = d.coord;
        SVGpath(ip).closed = d.closed;

        # Match id
        [s e te m] = regexp (path, 'id="(?:(?!").)*');
        if ~isempty (m)
            SVGpath(ip).id = strtrim (m{1}(5:end));
        end
    end

end

function d = parsePathData (data)
    
    d = struct ('coord', [], 'closed', []);
    
    [s e te comm] = regexp (data, '[MmLlHhVvCcSsQqTtAaZz]{1}');
    # TODO
    # This info could be used to preallocate d
    [zcomm zpos] = ismember ({'Z','z'}, comm);
    
    if any (zcomm)
      d.closed = true;
    else
      d.closed = false;
      s(end+1) = length (data);
    end  
    comm(zpos(zcomm)) = [];
    ncomm = size (comm, 2);
    for ic = 1:ncomm
    
      switch comm{ic}
          case {'M','L'}
            [x y] = strread (data(s(ic) + 1 : s(ic + 1) - 1), ...
                                              '#f#f', 'delimiter', ', ');
            coord = [x y];

          case 'm'
            [x y] = strread( data(s(ic) + 1 : s(ic + 1) - 1), ...
                                              '#f#f', 'delimiter', ', ');
            nc = size (x, 1);
            coord = [x y];
            if ic == 1
                # relative moveto at begining of data.
                # First coordinates are absolute, the rest are relative.
                coord = cumsum (coord);
            else
                # Relative moveto.
                # The coordinates are relative to the last one loaded
              coord(1,:) =coord(1,:) + d.coord(end,:);
              coord = cumsum(coord);
              warning('svg2octWarning',['Relative moveto in path data.'...
               ' May mean that the orginal path was not a simple polygon.' ...
               ' If that is the case, the path will not display equally.'])
            end

          case 'l'
            # Relative lineto, coordinates are relative to last point loaded.
            [x y] = strread( data(s(ic) + 1 : s(ic + 1) - 1), ...
                                              '#f#f', 'delimiter', ', ');
            nc = size (x, 1);
            coord = [x y]
            coord(1,:) =coord(1,:) + d.coord(end,:);
            coord = cumsum(coord);

          otherwise
              warning('svg2oct:Warning',...
                      'Path data command "#s" not implemented yet.',comm{ic});
      end

      nc = size(coord,1);
      d.coord(end+1:end+nc,:) = coord;

    end
end
