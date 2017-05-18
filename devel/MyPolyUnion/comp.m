/* Both are same problems, there was an issue in handling NaN as delimeter, so I have provisionally used value
-100000 in place of NaN */

x1 = [0 0; 10 0; 10 10; 0 10; 0 0; NaN NaN; 2 2; 8 2; 8 8; 8 2; 2 2;];
y1 = [5 0; 15 0; 15 10; 5 10; 5 0; NaN NaN; 7 2; 7 8; 12 8; 12 2; 7 2;];

x2 = [0 0; 10 0; 10 10; 0 10; 0 0; -100000 -100000; 2 2; 8 2; 8 8; 8 2; 2 2;];
y2 = [5 0; 15 0; 15 10; 5 10; 5 0; -100000 -100000; 7 2; 7 8; 12 8; 12 2; 7 2;];

pkg load geometry

tic()

polyUnion(x2, y2)

toc()

tic()

clipPolygon(x1, y1, 3)

toc()



