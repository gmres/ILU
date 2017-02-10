 function rhs = armsprec(PRE, rhs, lev) 
%%-------------------------------------------------
%% function rhs = armsprec(PRE, rhs, lev) 
%% arms preconditioning operation
%% PRE = struct for preconditioner
%% lev = current level number (set to 1 when calling
%%       from top level
%%-------------------------------------------------
 nlevp1 = length(PRE);   %%% nlev+1
 [pperm, qperm, LB, UB, F, E, C] = unpack(PRE(lev)) ; 
 nB = size(LB, 1); 
 n = nB + size(E, 1); 
%% if at last level solve with gmres or one preconditioning
%% sweep using LS and US ...
 if (lev == nlevp1) 
%%% include any orderings for Schur complement level here 
    rhs = qperm*rhs;
%%  solve last complement system 
    [rhs] = pgmres(PRE, rhs, zeros(nB,1)) ; 
%% otherwise descend to next level ... 
 else 
   rhs = descend(pperm, nB, LB, UB, F, E, rhs) ; 
%% .... solve [note the recursive call]
   rhs(nB+1:n)= armsprec(PRE, rhs(nB+1:n), lev+1) ; 
%% ... and ascend back to this level
   rhs = ascend(qperm, nB, LB, UB, F, E, rhs); 
 end
%%
