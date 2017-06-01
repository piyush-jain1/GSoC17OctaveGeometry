pol1 = [2 2; 6 2; 6 6; 2 6; 2 2; NaN NaN; 3 3; 3 5; 5 5; 5 3; 3 3];
pol2 = [1 2; 7 4; 4 7; 1 2; NaN NaN; 2 3; 5 4; 4 5; 2 3];


pol3 = [0 0; 100 0; 100 100; 0 100];
pol4 = [120 0; 150 0; 150 100; 120 100];


union(pol3, pol4, 3);
##pkg load geometry

#clipPolygon(pol3, pol4, 3)

