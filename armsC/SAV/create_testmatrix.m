function A = create_testmatrix(shift) 
Bx = [-1 12 -1; 12 0 -1; -11 1 0];
Bz = 100*ones(3,3) ; 
A = fd3d(15,15,20,0.1,0.1,0.1,shift); 
