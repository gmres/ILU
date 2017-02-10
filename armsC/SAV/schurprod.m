function y = schurprod(LB,UB,F,E,C,x) 
%function y = schurprod(LB,UB,F,E,C,x) 
% computes the schur prodct 
%%          (C - E U\inv L\inv F ) x
     y = C*x -  E * ( UB\ (LB \ (F*x) )); 


