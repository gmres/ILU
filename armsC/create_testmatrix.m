function A = create_testmatrix();
%%Bx = [-1 12 -1; 12 0 -1; -11 1 0];
%%Bz = 100*ones(3,3) ; 
shift = 0.1;
A = fd3d(20,20,10,0.1,0.1,0.01,shift); 
disp(' Lap + 0.1*conv + shift* I');
disp('mesh : 15 x 15 x 10 -- shift = 0.5')
