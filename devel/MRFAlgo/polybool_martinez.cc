/*
Copyright (C) 2017 - Piyush Jain
Copyright (C) 2017 - Juan Pablo Carbajal

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>. 
*/

#include "polygon.h"
#include "utilities.h"
#include "martinez.h"
#include "connector.h"

#include <octave/oct.h>
#include <octave/parse.h>
#include <octave/Cell.h>


DEFUN_DLD(polybool_martinez, args, , 
          "\
-*- texinfo -*-\n\
@deftypefn {Loadable Function} {} polybool_martinez (@var{subj} ,@var{clip}, @var{operation}\n\
Perform Boolean Operations on polygons\n\n\
@var{subj}-@var{clip} are NaN Delimited Column/Row Vectors\n\n\
@var{Operation} is a string representing the operation to perform. \n\
Valid Operations are: 0 (DIFFERENCE), 1 (INTERSECTION), 2 (XOR) , 3 (UNION).\n\
It is an optional argument. If not provided, INTERSECTION is the default operation.\n\n\
@end deftypefn")
{ 
  int nargin = args.length();

  if(nargin < 2 || nargin > 3)
     print_usage();

  else
  { 
    Polygon subj, clip;

    octave_map subpoly  = args(0).map_value ();
    octave_map clippoly = args(1).map_value ();

    // Subject polygon
    octave_idx_type ncontours = subpoly.numel();
    double px, py;
    octave_map::const_iterator px_iter = subpoly.seek ("x");
    octave_map::const_iterator py_iter = subpoly.seek ("y");

    for (octave_idx_type i = 0; i < ncontours; i++) {
        Array<double> X  =  subpoly.contents(px_iter)(i).array_value();
        Array<double> Y  =  subpoly.contents(py_iter)(i).array_value();

        octave_idx_type npoints = X.numel();
        subj.push_back (Contour ());
        Contour& contour = subj.back ();

        for (octave_idx_type j = 0; j < npoints; j++) {
            px = X(j);
            py = Y(j);
            if (j > 0 && px == contour.back ().x && py == contour.back ().y)
                continue;
            if (j == npoints-1 && px == contour.vertex (0).x && py == contour.vertex (0).y)
                continue;
            contour.add (Point (px, py));
        }

        if (contour.nvertices () < 3) {
            subj.pop_back ();
            continue;
        }
    }

    // Clipping polygon
    ncontours = clippoly.numel();
    px_iter = clippoly.seek ("x");
    py_iter = clippoly.seek ("y");

    for (octave_idx_type i = 0; i < ncontours; i++) {
        Array<double> X  =  clippoly.contents(px_iter)(i).array_value();
        Array<double> Y  =  clippoly.contents(py_iter)(i).array_value();

        octave_idx_type npoints = X.numel();
        clip.push_back (Contour ());
        Contour& contour = clip.back ();

        for (octave_idx_type j = 0; j < npoints; j++) {
            px = X(j);
            py = Y(j);
            if (j > 0 && px == contour.back ().x && py == contour.back ().y)
                continue;
            if (j == npoints-1 && px == contour.vertex (0).x && py == contour.vertex (0).y)
                continue;
            contour.add (Point (px, py));
        }

        if (contour.nvertices () < 3) {
            clip.pop_back ();
            continue;
        }
    }

    // Selecting operation
    Martinez::BoolOpType op = Martinez::INTERSECTION;

    if (nargin > 2) {
        int opcode = args(2).scalar_value();
        switch (opcode) {
            case 0:
                op = Martinez::DIFFERENCE;
                break;
            case 1:
                op = Martinez::INTERSECTION;
                break;
            case 2:
                op = Martinez::XOR;
                break;
            case 3:
                op = Martinez::UNION;
                break;
        }
    }

    // Perform boolean operation
    Polygon martinezResult;
    martinezResult.clear ();
    Martinez mr (subj, clip);
    mr.compute (op, martinezResult);

    // Passing the result into matrix 
    octave_value_list result;
    octave_idx_type size = martinezResult.nvertices() + martinezResult.ncontours()-1;
    if(size >= 0)
    {
        Matrix tempx(dim_vector(size,1));
        Matrix tempy(dim_vector(size,1));
        octave_idx_type k = 0;

        for (octave_idx_type i = 0; i < martinezResult.ncontours (); i++) 
        {
            Contour::iterator c = martinezResult.contour (i).begin();
            while (c != martinezResult.contour (i).end()) {
                tempx(k,0) = c->x;
                tempy(k,0) = c->y;
                k++;
                ++c;
            }

            if(i != martinezResult.ncontours()-1){
                tempx(k,0) = std::numeric_limits<double>::quiet_NaN();
                tempy(k,0) = std::numeric_limits<double>::quiet_NaN();
                k++;
            }
        }

        result(0) = tempx;
        result(1) = tempy;
        result(2) = martinezResult.ncontours();    
    }
    else
    {   
        result(0) = std::numeric_limits<double>::quiet_NaN();
        result(1) = std::numeric_limits<double>::quiet_NaN();
        result(2) = 0;
    }

    return result;
  }

  return  octave_value_list();
}

