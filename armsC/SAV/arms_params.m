%---------------------------------------------------- 
% This file  is read by  many of the codes.  It sets
% all  the  parameters  needed  for setting  up  the
% preconditioner and for  the iterations (global and
% inner).  This avoids  having to  search  for these
% parameters  in the  various files  to  change them
% when doing tests.
%----------------------------------------------------
%%
%% PART 1: parameters for the arms reduction
%% 
tolInd   = 0.3;         % tolerance for diagonal dominance filtration.
ilutolB  = 0.01  ;         % tolerance for dropping in B
bsize    = 200;           % block size in reduction [For standard arms] 
lfilB     = 3;         % lfil in L, U 
droptolE = 0.01   ;      % drop tol for E*inv(U) and inv(L)*F
lfilE    =  3;         % lfil for E*inv(U) and inv(L)*F  may 
                         % have the meaning of level of fill when 
                         % level strategies will be used later. 
%%
%% Part 2 : parameters for the last schur complement 
%%
droptolS = 0.01   ;       % droptol used to prune S
ilutolS  = 0.000001  ;       % droptol for S = LS  US 
lfilS    = 4;        % fill paramerer for S = LS US 
%% 
%% Part 3 : parameters for the outer gmres iteration
%% 
im       = 40     ;     % krylov subspace dimension 
tolIts   = 0.00000000001 ;      % stopping criterion
maxits   = 100     ;    % max number of outer steos      --
outputG  = 1      ;    % whether or not to print residual vs iterations
                        % in global gmres. 
%% 
%% Part 4 : general paramters 
%%
tolmac   = 1.e-16  ;    % machine eps [used only in gmres.] can be removed
%
%-----------------------------------------------------------------------



