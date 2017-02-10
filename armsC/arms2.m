function PRE = arms2(A,ARMSopt)
%% PRE = arms2(A,nlev) 
%% computes the arms preconditioner for A.
%% notes: parameters are read from arms_params.m
%% important: for nlev levels, we actually have nlev+1
%% structs -- one for the las schur complement which
%% assumes the same data structure as any other levels
%% (E,F, and C) are void matrices for the level nlev+1
%%------------------------------------------------------
S = A; 
%% at all levels except the last do not store C..
%% may be changed with other arms methods...

tolInd = ARMSopt.tolInd;
bsize = ARMSopt.bsize;
nlev =  ARMSopt.nlev;
lev = 0;
while (lev < nlev) 
    [rperm,nB] = indset(S,tolInd,bsize) ;
    if (nB >= size(S,1))
       break
    end
    lev = lev+1;
    if (lev >1)
       PRE(lev-1).C = sparse(0,0);  
    end
    [str, S] = lev1arms(S,nB,rperm,ARMSopt);
    PRE(lev)  = str; 
end
nlev = lev; 
%% 
opt.thresh = 1.0; opt.droptol = ARMSopt.ilutolS; opt.udiag = 1;
[LS,US,PS] = luinc(S,opt);
%%
nS =  size(S,1);
%% define a struct for precon
%% possible to reorder the last system -- 
rperm = PS;
F = sparse(nS,0) ;
E = sparse(0,nS);
C = sparse(0,0); 
spy(S) 
title('last schur complement') 
disp('pausing ... ') 
     pause(1)  
close
PRE(nlev+1)  = struct('rperm',rperm,'L',LS,'U',US,'F',F,'E',E,'C',C);

