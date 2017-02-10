%%-------------------------------------------------
%% generate a "block " finite difference matrix -- using fd3dB
%%-------------------------------------------------

A = create_testmatrix(shift);

n = size(A,1);

spy(A) 
title([' block elliptic matrix of size  n = ', num2str(n)]) 
disp('pausing -- push any key to continue ') 
pause(1)
close 
%%-------------------------------------------------
%% create artificial rhs
rhs = A * ([1:n]') ; 
%% random initial guess
sol = rand(n,1); 
%--------------------------------------------------
% read parameters from file 
 arms_params;
%%------------------------------------------------- 
 rhs = A * ([1:n]') ; sol = rand(n,1); 
%%  Call arms preconditioner set-up
 nlev = 3;
 PRE = armsC(A,nlev) ;
%%--------------------------------------------------- 
%% ready to call fgmres
 disp(' solution with ARMS(3)-GMRES') 
 [sol,res,its] = fgmres(A, PRE,'armsprecC', rhs, sol);
 ffact = memus(PRE)/nnz(A) ;
 fprintf('fill-factor = %f \n',ffact)
 disp(' ** done ** ') 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
