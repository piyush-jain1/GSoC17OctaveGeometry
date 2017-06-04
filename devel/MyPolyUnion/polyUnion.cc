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

#include <iostream>
#include <octave/oct.h>
#include <octave/parse.h>
#include <octave/Cell.h>
#include "clipper.hpp"

DEFUN_DLD(polyUnion, args, nargout , "polyUnion help")
{ 

  int nargin = args.length();
  if(nargin < 2)   print_usage();
  else
  { 
    // retval.resize(100);
    octave_map subpoly = args(0).map_value ();
    octave_map clippoly = args(1).map_value ();
    int64_t sub_size = subpoly.numel();
    int64_t clip_size = clippoly.numel();
    ClipperLib::Paths subj(sub_size), clip(clip_size), solution;
    octave_map::const_iterator px = subpoly.seek ("x");
    octave_map::const_iterator py = subpoly.seek ("y");
    for(uint64_t i = 0; i < sub_size; i++)
    {   
        Array<int64_t> X  =  subpoly.contents(px)(i).array_value(); 
        Array<int64_t> Y  =  subpoly.contents(py)(i).array_value();
        uint64_t n = X.numel();
        
        for(uint64_t j = 0; j < n; j++)
        {
            ClipperLib::IntPoint ip;
            ip.X = X(j);
            ip.Y = Y(j);
            subj[i].push_back(ip);
        }   
    }
    px = clippoly.seek ("x");
    py = clippoly.seek ("y");
    for(uint64_t i = 0; i < clip_size; i++)
    {   
        Array<int64_t> X  =  clippoly.contents(px)(i).array_value(); 
        Array<int64_t> Y  =  clippoly.contents(py)(i).array_value();
        uint64_t n = X.numel();

        for(uint64_t j = 0; j < n; j++)
        {
            ClipperLib::IntPoint ip;
            ip.X = X(j);
            ip.Y = Y(j);
            clip[i].push_back(ip);
        }   
    }


    ClipperLib::Clipper c;
    c.AddPaths(subj, ClipperLib::ptSubject, true);
    c.AddPaths(clip, ClipperLib::ptClip, true);
    c.Execute(ClipperLib::ctUnion, solution, ClipperLib::pftEvenOdd, ClipperLib::pftEvenOdd);
    octave_idx_type soln_size = solution.size();

    octave_value_list result;
    octave_idx_type points = 0;
    for(octave_idx_type i = 0; i < solution.size(); ++i)
    {   
        ClipperLib::Path p3 = solution.at(i);
        points += p3.size()+1;
    }
    Matrix tempx(dim_vector(points,1));
    Matrix tempy(dim_vector(points,1));
    octave_idx_type k = 0;
    for(octave_idx_type i = 0; i < solution.size(); ++i)
    {   

        ClipperLib::Path p3 = solution.at(i);
        for(octave_idx_type j = 0; j < p3.size(); ++j)
        {
            ClipperLib::IntPoint ip = p3.at(j);
            tempx(k,0) = ip.X;
            tempy(k,0) = ip.Y;  
            k++;  
        }
        tempx(k,0) = std::numeric_limits<double>::quiet_NaN();
        tempy(k,0) = std::numeric_limits<double>::quiet_NaN();
        k++;
    }
    result(0) = tempx;
    result(1)  = tempy;
    
    return result;
  
  }
  return  octave_value_list();

}