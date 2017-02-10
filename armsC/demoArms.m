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

 disp(' solution with ARMS(2)-GMRES') 
 rhs = A * ([1:n]') ; sol = rand(n,1); 
%%% ARMSopt.nlev  = 4;
 PRE = arms2(A,ARMSopt) ;
%
 [sol,res2,its2] = fgmres(A, PRE,'armsprec2', rhs, sol,ARMSopt);

 ffact2 = memus(PRE)/nnz(A) ;
ffact2 = round(ffact2*100)/100;
 fprintf('fill-factor = %f \n',ffact2)

 disp(' ** done ** ') 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot convergence curves. 
 close

 disp(' solution with ARMSC(3) GMRES') 
 rhs = A * ([1:n]') ; sol = rand(n,1); 
 PRE = armsC(A,ARMSopt) ;
 [sol,res3,its3] = fgmres(A, PRE,'armsprecC', rhs, sol,ARMSopt);
 ffact3 = memus(PRE)/nnz(A) ;
 ffact3 = round(ffact3*100)/100;
 fprintf('fill-factor = %f \n',ffact3)

 disp(' ** done ** ') 
%% 

semilogy([0:its1],res1,'linestyle','--','marker','*','LineWidth',2,'color','r')
text(its1,res1(its1)/2,num2str(ffact1),'fontsize',18) 

hold on;
semilogy([0:its2],res2,'linestyle','-.','marker','v','LineWidth',2,'color','b')
text(its2,res2(its2)/2,num2str(ffact2),'fontsize',18) 

semilogy([0:its3],res3,'linestyle','-','marker','d','LineWidth',2,'color','m')
text(its3,res3(its3)/2,num2str(ffact3),'fontsize',18) 


legend('ILUT-gmres','ARMS(3)-GMRES','ARMS-C(3)-GMRES') 
