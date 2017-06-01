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


#include <iostream>
#include <cmath>
#include <limits>
#include <octave/oct.h>
#include <octave/parse.h>
#include <octave/Cell.h>
#include "clipper.hpp"


DEFUN_DLD(polyUnion, args, , "polyUnion help")
{ 

  int nargin = args.length();
  if(nargin < 2)   print_usage();
  else
  { 
    octave_value_list retval;
    // retval.resize(100);
    Matrix A = args(0).matrix_value ();
    Matrix B = args(1).matrix_value ();
    ClipperLib::Paths subj(2), clip(2) ,subjpol(2), clippol(2) , solution;
    dim_vector dvA = A.dims();
    dim_vector dvB = B.dims();
    int subjIndex = 0, clipIndex = 0;
    for(int j = 0; j < dvA(0); ++j)
    { 
        if(std::isnan(A(j,0)))  subjIndex++;
        else
        {
          ClipperLib::IntPoint ip;
          ip.X = A(j,0);
          ip.Y = A(j,1);
          subj[subjIndex].push_back(ip);
        }
    }
    for(int j = 0; j < dvB(0); ++j)
    { 
        if(std::isnan(B(j,0)))  clipIndex++;
        else
        {
          ClipperLib::IntPoint ip;
          ip.X = B(j,0);
          ip.Y = B(j,1);
          clip[clipIndex].push_back(ip);
        }   
    }

    ClipperLib::Clipper c;
    c.AddPaths(subj, ClipperLib::ptSubject, true);
    c.AddPaths(clip, ClipperLib::ptClip, true);
    c.Execute(ClipperLib::ctUnion, solution, ClipperLib::pftNonZero, ClipperLib::pftNonZero);
    std::cout<<"Union conatins "<<solution.size()<<" disjoint polygon(s)"<<std::endl<<std::endl;

    for(int i = 0; i < solution.size(); ++i)
    {
        ClipperLib::Path p3 = solution.at(i);
        for(int j = 0; j < p3.size(); ++j)
        {
            ClipperLib::IntPoint ip = p3.at(j);
            std::cout<<"x = "<<ip.X<<"  y = "<<ip.Y<<std::endl;
        }
        std::cout<<"nan"<<"     nan"<<std::endl;
    }

    return octave_value_list();
  
  }
  return  octave_value_list();

}