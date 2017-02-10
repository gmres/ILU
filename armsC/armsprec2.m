 function rhs = armsprec(PRE, rhs, lev) 
%%-------------------------------------------------
%% function rhs = armsprec(PRE, rhs, lev) 
%% arms preconditioning operation
%% PRE = struct for preconditioner 
%% lev = current level number (set to 1 when calling
%% from top level)
%%-------------------------------------------------
 if (nargin < 3) 
	lev = 1;
 end
 nlevp1 = length(PRE);   %%% nlev+1
%%%%  unpack -- 
rperm = getfield(PRE(lev),'rperm');
LB = getfield(PRE(lev),'L');
UB = getfield(PRE(lev),'U');
F  = getfield(PRE(lev),'F');
E  = getfield(PRE(lev),'E');
C  = getfield(PRE(lev),'C');
%%
 nB = size(LB, 1); 
 n = nB + size(E, 1); 
%% if at last level solve with LS / US 
 if (lev == nlevp1) 
%%% include any orderings for Schur complement level here 
%%  solve last complement system 
 [rhs] = (UB \ (LB \ (rperm*rhs))) ;
%% otherwise descend to next level ... 
  else 
   rhs = descend(rperm, nB, LB, UB, F, E, rhs) ; 
%% .... solve [note the recursive call]
   rhs(nB+1:n)= armsprec2(PRE, rhs(nB+1:n), lev+1) ; 
%% ... and ascend back to this level
   rhs = ascend(rperm, nB, LB, UB, F, E, rhs); 
 end
%%
