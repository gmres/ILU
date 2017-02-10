%%-------------------------------------------------
%% generate a "block " finite difference matrix -- using fd3dB
%%-------------------------------------------------

A = create_testmatrix(shift) ;

n = size(A,1);
spy(A) 
title([' block elliptic matrix of size  n = ', num2str(n)]);
pause(1)
close 
%%
%%-------------------------------------------------
%% create artificial rhs
rhs = A * ([1:n]') ; 
%% random initial guess
sol = rand(n,1); 
%%-------------------------------------------------
% read parameters from file 
 arms_params;
%%-------------------------------------------------- 
 disp(' solution with ARMS(2)-GMRES') 
 rhs = A * ([1:n]') ; sol = rand(n,1); 
 PRE = armsC(A,2) ;
 [sol,res1,its1] = fgmres(A, PRE,'armsprecC', rhs, sol) ; 
 ffact = memus(PRE)/nnz(A) ;
 fprintf('fill-factor = %f \n',ffact)

 disp(' ** done ** ') 
%% 
