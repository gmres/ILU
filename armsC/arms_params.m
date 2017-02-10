function [ARMSopt] = arms_param()
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
ARMSopt.tolInd   = 0.2;         % tolerance for diagonal dominance filtration.
ARMSopt.ilutolB  = 0.01  ;         % tolerance for dropping in B
ARMSopt.bsize    = 200;           % block size in reduction [For standard arms]
ARMSopt.nlev     = 4; 
ARMSopt.lfilB    = 3;         % lfil in L, U 
ARMSopt.droptolE = 0.01   ;      % drop tol for E*inv(U) and inv(L)*F
ARMSopt.lfilE    = 3;         % lfil for E*inv(U) and inv(L)*F  may 
                         % have the meaning of level of fill when 
                         % level strategies will be used later. 
%%
%% Part 2 : parameters for the last schur complement 
%%
ARMSopt.droptolS = 0.01   ;       % droptol used to prune S
ARMSopt.ilutolS  = 0.000001  ;       % droptol for S = LS  US 
ARMSopt.lfilS    = 4;        % fill paramerer for S = LS US 
%% 
%% Part 3 : parameters for the outer gmres iteration
%% 
ARMSopt.im       = 40     ;     % krylov subspace dimension 
ARMSopt.tolIts   = 0.00000000001 ;      % stopping criterion
ARMSopt.maxits   = 100     ;    % max number of outer steos      --
ARMSopt.outputG  = 1      ;    % whether or not to print residual vs iterations
                        % in global gmres. 
%% 
%% Part 4 : general paramters 
%%
ARMSopt.tolmac   = 1.e-16  ;    % machine eps [used only in gmres.] can be removed
%
%-----------------------------------------------------------------------



