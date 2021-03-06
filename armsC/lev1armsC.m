function [str,S] = lev1arms(A,nB,pperm,qperm,ARMSopt,lev)
% [str,S] = lev1arms(A,nB,pperm) 
% Computes one level of the arms factorization 
%
%
%            |\         |       |
%            |  \   U   |       |
%            |    \     |   F   |
%            |  L   \   |       |
%            |        \ |       |
%            |----------|-------|
%            |          |       |
%            |    E     |   C   |  
%            |          |       |
%            
% mode == 0 --> store C -- otherwise store a NULL matrix for C. 
%
% returns a struct which contains 
% str = 
%   pperm, qperm   permutations for this level
%   L       L matrix [see diagram] 
%   U       U matrix [see diagram] 
%   F       F matrix [see diagram]     
%   E       E matrix [see diagram] 
%   C       C matrix [see diagram]  <-- replace by sparse(0,0) if not last 
%                                       level -- 
% also returns the schur complement matrix S 
% S = approx[C - (E U\inv) (L\inv F)]
%-----------------------------------------------------------------------
%%%   arms_params; 
   n = size(A,1);
   nzperrow = nnz(A)/(n+1);
   A1 = A(pperm,qperm); 
   spy(A1);
hold on;
plot([nB+0.5,nB+0.5],[0,n],'red') 
plot([0,n],[nB+0.5,nB+0.5],'red') 
title(['Level ',num2str(lev),' ;  n = ',num2str(n),' ; n_B = ',num2str(nB)],...
 'fontsize',18) 
     outp = strcat('bp',num2str(lev))
     print(gcf,'-deps2', outp); 

disp(' reordered matrix at next level ')
disp('pausing ...  ') 
     pause(2)
close 
%%
   F  = A1(1:nB,nB+1:n) ;
   E  = A1(nB+1:n,1:nB); 
   C  = A1(nB+1:n,nB+1:n); 
%%
%% factor the B block -- ILUINC from matlab used
%% 
opt.thresh = 0.0;   opt.udiag = 1.0;  opt.droptol = ARMSopt.ilutolB; 
[L,U] = luinc(A1(1:nB,1:nB),opt); 
%%
%% at this point the struct for this level can be defined -- 
%% 
   str = struct('pperm',pperm,'qperm',qperm,'L',L,'U',U,'F',F,'E',E,'C',C);
%%
%% compute the G and W factors
%% 
%%   G = A1(nB+1:n,1:nB)* inv(U);     <<  leave these here for 
%%   W = L \ A1(1:nB,nB+1:n);         <<  debugging --  
%% 
lfilE = ARMSopt.lfilE;
lfil = ceil(lfilE*nzperrow); droptolE = ARMSopt.droptolE ; 
     G = XUinv(U, A1(nB+1:n,1:nB), droptolE, lfil); 
     W = LinvX(L, A1(1:nB,nB+1:n), droptolE, lfil); 
%% 
%% compute the Schur matrix and perform dropping
%% 
   S = A1(nB+1:n,nB+1:n) - G*W;
%%   S = S';  %% in order to drop by rows -- 
   lfil = ceil(ARMSopt.lfilS*nzperrow);
   S = drop2(S, ARMSopt.droptolS, lfil); 
%%   S = S';  
%%
%%----------------------- end -------------------------------------------
%%
