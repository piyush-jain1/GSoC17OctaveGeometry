#include <iostream>
#include <octave/oct.h>
#include <octave/parse.h>
#include <octave/Cell.h>
#include "clipper.hpp"


DEFUN_DLD(polyUnion, args, , "polyUnion help")
{ 

  int nargin = args.length();
  if(nargin != 2)   print_usage();

  if (1)
    {
      Array<double> pol1=args(0).vector_value();
      Array<double> pol2=args(1).vector_value();
      std::vector<double> xcor1,xcor2,ycor1,ycor2;
      ClipperLib::Paths subj(2), clip(2) , solution;
      unsigned int pointindex1=0, pointindex2=0, polcount=1, i=0,j=1 , yflag=0;

      while (pointindex1<pol1.numel())
      {     
            // Ignore NaN's 
            // Taking (-100000 -100000) as delimeter
            if(pol1(pointindex1) == -100000) 
            {
                  polcount++;
                  j=i;
                  i=0;
            }
            else
            {     // X-Coordinates
                  if(yflag==0)
                  {     
                        // 1st path
                        if(polcount==1)   
                        {     
                              // std::cout<<"pointindex1 : "<<pointindex1<<" ------------- xcor1 : "<<pol1(pointindex1)<<std::endl;
                             xcor1.push_back(pol1(pointindex1)); 
                             i++;
                        }
                        // 2nd path
                        else if(polcount==2 and j>0)
                        {     
                              // std::cout<<"pointindex1 : "<<pointindex1<<" ------------- xcor2 : "<<pol1(pointindex1)<<std::endl;
                              xcor2.push_back(pol1(pointindex1));
                              j--;
                        }
                        if(j==0)
                        {
                              yflag = 1;
                              polcount = 1;
                              i = 0;
                        }
                  }
                  // Y-Coordinates
                  else
                  {     
                        // 1st path
                        if(polcount==1)   
                        {     
                              // std::cout<<"pointindex1 : "<<pointindex1<<" ------------- ycor1 : "<<pol1(pointindex1)<<std::endl;
                             ycor1.push_back(pol1(pointindex1)); 
                             i++;
                        }
                        // 2nd path
                        else if(polcount==2 and j>0)
                        {     
                              // std::cout<<"pointindex1 : "<<pointindex1<<" ------------- ycor2 : "<<pol1(pointindex1)<<std::endl;
                              ycor2.push_back(pol1(pointindex1));
                              j--;
                        }
                  }
            }
            pointindex1++;
      }
      // std::cout<<"Subject1 :"<<std::endl;
      for(j=0;j<xcor1.size();j++)
      {
            ClipperLib::IntPoint ip;
            ip.X = xcor1[j];
            ip.Y = ycor1[j];
            // std::cout<<ip.X<<"      "<<ip.Y<<std::endl;
            subj[0].push_back(ip);
      }
      // std::cout<<"Subject2 :"<<std::endl;
      for(j=0;j<xcor2.size();j++)
      {
            ClipperLib::IntPoint ip;
            ip.X = xcor2[j];
            ip.Y = ycor2[j];
            // std::cout<<ip.X<<"      "<<ip.Y<<std::endl;
            subj[1].push_back(ip);
      }
      polcount=1;
      i=0;
      j=1;
      yflag=0;
      xcor1.clear();
      xcor2.clear();
      ycor1.clear();
      ycor2.clear();
      while (pointindex2<pol2.numel())
      {     
            // Ignore NaN's
            // Taking (-100000 -100000) as delimeter
            if(pol2(pointindex2) == -100000)
            {     
                  polcount++;
                  j=i;
                  i=0;
            }
            else
            {
                  if(yflag==0)
                  {
                        if(polcount==1)   
                        {     
                             xcor1.push_back(pol2(pointindex2)); 
                             i++;
                        }
                        else if(polcount==2 and j>0)
                        {     
                              xcor2.push_back(pol2(pointindex2));
                              j--;
                        }
                        if(j==0)
                        {
                              yflag = 1;
                              polcount = 1;
                              i = 0;
                        }
                  }
                  else
                  {
                        if(polcount==1)   
                        {     
                             ycor1.push_back(pol2(pointindex2)); 
                             i++;
                        }
                        else if(polcount==2 and j>0)
                        {     
                              ycor2.push_back(pol2(pointindex2));
                              j--;
                        }
                  }
            }
            
            pointindex2++;
      }
      // std::cout<<"Clip1 :"<<std::endl;
      for(j=0;j<xcor1.size();j++)
      {
            ClipperLib::IntPoint ip;
            ip.X = xcor1[j];
            ip.Y = ycor1[j];
            // std::cout<<ip.X<<"      "<<ip.Y<<std::endl;
            clip[0].push_back(ip);
      }
      // std::cout<<"Clip2 :"<<std::endl;
      for(j=0;j<xcor2.size();j++)
      {
            ClipperLib::IntPoint ip;
            ip.X = xcor2[j];
            ip.Y = ycor2[j];
            // std::cout<<ip.X<<"      "<<ip.Y<<std::endl;
            clip[1].push_back(ip);
      }
      ClipperLib::Clipper c;
      c.AddPaths(subj, ClipperLib::ptSubject, true);
      c.AddPaths(clip, ClipperLib::ptClip, true);
      c.Execute(ClipperLib::ctUnion, solution, ClipperLib::pftNonZero, ClipperLib::pftNonZero);
      std::cout<<"Union conatins "<<solution.size()<<" disjoint polygon(s)"<<std::endl<<std::endl;
             
      for(int i = 0; i < solution.size(); ++i)
          {
              ClipperLib::Path p3 = solution.at(i);
                  //Vertex i.j represents jth vertex of ith disjoint polygon of the union
              for(int j = 0; j < p3.size(); ++j)
              {
                  ClipperLib::IntPoint ip = p3.at(j);
                  std::cout<<ip.X<<"      "<<ip.Y<<std::endl;
              }
              std::cout<<"NaN"<<"      "<<"NaN"<<std::endl;
              
            }
      
      
    }
    return  octave_value_list();
  
}



