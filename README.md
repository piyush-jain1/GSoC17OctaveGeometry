# GSoC17OctaveGeometry
GSoC 2017 - Geometry Package for Octave

Full Details of the work can be seen in the blog : [GSoC 2017](https://piyush-jain1.github.io/GeometryPackage/)<br/>

This repository is a clone(fork) of the Geometry Package which is a part of the [Octave Forge Project](http://octave.sourceforge.net/).<br/>

As part of GSoC 2017 , this project is intended to implement a set of boolean operations and supporting function for acting on polygons. These include the standard set of potential operations such as union/OR, intersection/AND, difference/subtraction, and exclusiveor/XOR. Other things to be implemented are the following functions: polybool, ispolycw, poly2ccw, poly2cw, poly2fv, polyjoin, and polysplit.<br/>

This fork adds new functions to the official Geometry Package as part of GSoC (Google Summer of Code) 2016.

The official Geometry Package can be found [here](https://sourceforge.net/p/octave/geometry/ci/default/tree/)

Link to commits on official repo :
- [19a35e](https://sourceforge.net/p/octave/geometry/ci/19a35efc16dbe645e0bbfbffe9cfaa14e5ec9c96/)
- [fc3710](https://sourceforge.net/p/octave/geometry/ci/fc3710b6cce55502e6eff4dc4251d507bc5b4ff1/)

## Added files and functions
1. /inst/polygons2d/clipPolygon_mrf.m
2. /inst/polygons2d/private/\__poly2struct\__.m
3. /src/martinez.cpp
4. /src/polygon.cpp
5. /src/utilities.cpp
6. /src/polybool_mrf.cc
7. /inst/polygons2d/funcAliases
