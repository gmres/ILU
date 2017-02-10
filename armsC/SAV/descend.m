function [rhs1] = descend(pperm, nB, LB, UB, F, E, rhs); 
% Computes the one-level arms factorization 
%  
%
%
%            |\         |       |
%            |  \       |       |
%            |    \     |       | 
%            |  L   \   |       |  
%            |        \ |       |  * rhs  = rhs 
%            |----------|-------|
%            |          |       |
%            | E U^(-1) |   I   | 
%            |          |       |
%            
nB= size(LB,1);
n = nB+size(E,1); 
rhs1 = rhs(pperm) ; 
rhs1(1:nB) = LB \ rhs1(1:nB); 
rhs1(nB+1:n) = rhs1(nB+1:n) - E  * (UB \ rhs1(1:nB)); 




