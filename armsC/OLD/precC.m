 function rhs = precC(PRE, rhs) 
%%--------------- wrapper for armsprec ------------
%% function rhs = precC(PRE, rhs) 
%% arms preconditioning operation
%% PRE = struct for preconditioner
%%-------------------------------------------------
 rhs = armsprec(PRE,rhs,1);
%%
