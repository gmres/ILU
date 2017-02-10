function X = LinvX(L, X, droptol, lfil) 
% function S = LinvX(L, X, droptol, lfil) 
% L S = X
%-----------------------------------------------------------------------
% doing the computation row-wise is *SLOW*
X = XUinv(L', X', droptol, lfil);
X = X';




