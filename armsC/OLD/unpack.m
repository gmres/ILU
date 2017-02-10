function [pperm, qperm, L, U, F, E, C] = unpack(ST)
%% unpacks struct onto its fiedls
pperm = getfield(ST,'pperm');
qperm = getfield(ST,'qperm');
L = getfield(ST,'L');
U = getfield(ST,'U');
F = getfield(ST,'F');
E = getfield(ST,'E');
C = getfield(ST,'C');
