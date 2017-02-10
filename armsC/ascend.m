function [x] = ascend(qperm,nB, L, U, F, E, rhs); 
% Computes the one-level arms factorization 
%  
%
%
%            |\         |        |
%            |  \       |        |
%            |    \  U  |L^{-1}F | 
%            |      \   |        |  
%            |        \ |        |  * rhs  = rhs 
%            |----------|------- |
%            |          |        |
%            |          |   I    | 
%            |          |        |
%            
nB= size(L,1);
n = nB+size(E,1); 
x(nB+1:n) = (rhs(nB+1:n));
x = x';
x(1:nB) = U \ (rhs(1:nB) - L \ (F*x(nB+1:n))) ; 
x(qperm) = x;
%%---------------------------------------------------------------------


