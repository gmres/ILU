%%-------------------------------------------------
%% generate a "block " finite difference matrix -- using fd3dB
%%-------------------------------------------------

%% NEED TO DEFINE SHIFT FIRST -
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
% call ILU factorization from matlab -- store result
% in struct PRE 
%
 disp(' solution with ILUT-GMRES') 
 opt.thresh = 1.0; opt.udiag = 1; opt.droptol=ilutolB;
 [L, U, P] = luinc(A, opt);
 PRE = struct('L',L,'U',U, 'P',P) ; 
%-------------------------------------------------- 
% call fgmres accelerator
 [sol,res1,its1] = fgmres(A, PRE,'precLU', rhs, sol) ; 
 disp(' ** done ** ') 
 ffact = (nnz(L)+nnz(U)-n)/nnz(A) ;
 fprintf('fill-factor = %f \n',ffact)
%--------------------------------------------------
% repeat with ILU(0) 

 disp(' solution with ILU(0)-GMRES') 
 rhs = A * ([1:n]') ; sol = rand(n,1); 
% 
 [L, U] = iluk(A, 0); 
 PRE = struct('L',L,'U',U,'P',speye(n)) ;

 [sol,res2,its2] = fgmres(A, PRE,'precLU', rhs, sol) ; 
 disp(' ** done ** ') 

%--------------------------------------------------
% repeat with ILU(2) 
%% 
%%  disp(' solution with ILU(2)-GMRES') 
%%  rhs = A * ([1:n]') ; sol = rand(n,1); 
% 
%%  [L, U] = iluk(A, 2); 
%%  PRE = struct('L',L,'U',U) ;
%% 
%%  [sol,res3,its3] = fgmres(A, PRE,'precLU', rhs, sol) ; 
%%  disp(' ** done ** ') 
%--------------------------------------------------

% repeat with arms with nlev=4

 disp(' solution with ARMS(2)-GMRES') 
 rhs = A * ([1:n]') ; sol = rand(n,1); 
 PRE = arms2(A,2) ;
%
 [sol,res3,its3] = fgmres(A, PRE,'armsprec2', rhs, sol) ; 

 ffact = memus(PRE)/nnz(A) ;
 fprintf('fill-factor = %f \n',ffact)

 disp(' ** done ** ') 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot convergence curves. 
 close

semilogy([0:its1],res1,'linestyle','--','marker','*','LineWidth',2,'color','r') 
hold on;
semilogy([0:its2],res2,'linestyle','-.','marker','v','LineWidth',2,'color','b') 
semilogy([0:its3],res3,'linestyle','-','marker','d','LineWidth',2,'color','m')
%%milogy([0:its4],res4,'linestyle','--','marker','+','LineWidth',2,'color','k')
legend('ILUT-gmres','ILU(0)-GMRES','ARMS(2)-GMRES') 


