%%-------------------------------------------------
%% generate a "block " finite difference matrix -- using fd3dB
%%-------------------------------------------------

close;

A = create_testmatrix;
n = size(A,1);

spy(A) 
title([' Diffusion - convection matrix -- N = ', num2str(n)]);

pause(3)
close 
%%
%%-------------------------------------------------
%% create artificial rhs
rhs = A * ([1:n]') ; 
%% random initial guess
sol = rand(n,1); 
%%-------------------------------------------------
% read parameters from file 
 ARMSopt = arms_params;
%%-------------------------------------------------- 
%
 disp(' solution with ILUT-GMRES') 
 opt.thresh = 1.0; opt.udiag = 1; opt.droptol=ARMSopt.ilutolB;
 [L, U, P] = luinc(A, opt);
 PRE = struct('L',L,'U',U, 'P',P) ; 
%-------------------------------------------------- 
% call fgmres accelerator
 [sol,res1,its1] = fgmres(A, PRE,'precLU', rhs, sol,ARMSopt) ; 
 disp(' ** done ** ') 
 ffact1 = (nnz(L)+nnz(U)-n)/nnz(A) 
 ffact1 = round(ffact1*100)/100;

 fprintf('fill-factor = %f \n',ffact1)
%%
%% arms with nlev=3


