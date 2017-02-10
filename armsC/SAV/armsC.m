function PRE = armsC(A,nlev) 
%% PRE = armsC(A,nlev) 
%% computes the arms preconditioner for A.
%% notes: parameters are read from arms_params.m
%% important: for nlev levels, we actually have nlev+1
%% structs -- one for the las schur complement which
%% assumes the same data structure as any other levels
%% (E,F, and C) are void matrices for the level nlev+1
%%------------------------------------------------------
arms_params; 
S = A; 
%% at all levels except the last do not store C..
%% may be changed with other arms methods...
%%

lev = 0;
while (lev < nlev) 
    [ip, iq, nB] = PQ(S,tolInd) ;
    pperm = rev_ord(ip); 
    qperm = rev_ord(iq);
    if (nB >= size(S,1))
       break
    end
    lev = lev+1;
    if (lev >1)
       PRE(lev-1).C = sparse(0,0);  
    end
    [str, S] = lev1armsC(S,nB,pperm,qperm);
    PRE(lev)  = str; 
end
nlev = lev;
%% factor last schur complement -- Problem
%% with luinc of matlab -- does factorization by
%% columns. 
opt.thresh = 1.0; opt.droptol = ilutolS; opt.udiag = 1.0;
[LS,US,PS] = luinc(S,opt);
nS =  size(S,1);
%% Define a struct for precon
%% Possible to reorder the last system -- 
pperm = [1:nS]' ;
qperm = PS; 
F = sparse(nS,0) ;
E = sparse(0,nS);
C = sparse(0,0); 
spy(S) 
title('last schur complement') 
disp('pausing -- push any key to continue ') 
pause(1)  
close
PRE(nlev+1)=...
struct('pperm',pperm,'qperm',qperm,'L',LS,'U',US,'F',F,'E',E,'C',C);

