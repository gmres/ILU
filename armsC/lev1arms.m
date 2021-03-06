   function [str,S] = lev1arms(A,nB,rperm,ARMSopt) 
 % [str,S] = lev1arms(A,nB,rperm) 
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
 %   rperm   permutation for this level
 %   L       L matrix [see diagram] 
 %   U       U matrix [see diagram] 
 %   F       F matrix [see diagram]     
 %   E       E matrix [see diagram] 
 %   C       C matrix [see diagram]  <-- replace by sparse(0,0) if not last 
 %                                       level -- 
 % also returns the schur complement matrix S 
 % S = approx[C - (E U\inv) (L\inv F)]
 %-----------------------------------------------------------------------
  n = size(A,1);
  nzperrow = nnz(A)/(n+1);
  A1 = A(rperm,rperm); 
  spy(A1);
  hold on;
  plot([nB+0.5,nB+0.5],[0,n],'red') 
  plot([0,n],[nB+0.5,nB+0.5],'red') 
  disp(' reordered matrix at next level ')
  disp('pausing ... ') 
  pause(2)
  close 
 %%-----------------------------------------------------------------------
  F  = A1(1:nB,nB+1:n) ;
  E  = A1(nB+1:n,1:nB); 
  C  = A1(nB+1:n,nB+1:n); 
 %%
 %% factor the B block -- ILUINC from matlab used
 %% 
   opt.droptol = ARMSopt.ilutolB;    opt.thresh = 0.0;   opt.udiag = 1;
   [L,U] = luinc(A1(1:nB,1:nB),opt); 
 %%
 %% at this point the struct for this level can be defined -- 
 %% 
    str = struct('rperm',rperm,'L',L,'U',U,'F',F,'E',E,'C',C);
 %%
 %% compute the G and W factors
 %% 
 %%   G = A1(nB+1:n,1:nB)* inv(U);     <<  leave these here for 
%%   W = L \ A1(1:nB,nB+1:n);         <<  debugging --  
%% 
     droptolE = ARMSopt.droptolE; lfilE = ARMSopt.lfilE;
     lfil = ceil(lfilE*nzperrow);
     G = XUinv(U, A1(nB+1:n,1:nB), droptolE, lfil); 
     W = LinvX(L, A1(1:nB,nB+1:n), droptolE, lfil); 
%%     W = XUinv(L', A1(1:nB,nB+1:n)', droptolE, lfil); 
%% 
%% compute the Schur matrix and perform dropping
%% 
   
   droptolS = ARMSopt.droptolS; lfilS = ARMSopt.lfilS;
   S = A1(nB+1:n,nB+1:n) - G*W;
   lfil = ceil(lfilS *nzperrow);
   S = drop2(S, droptolS, lfil); 
%%
%%----------------------- end -------------------------------------------
%%
