   function [rperm, nB, blocks] = indset2(A,ndom) 
%% 
%% [rperm, nB, NBlocks] = indset(A,tol,bsize) 
%%
%% computes the permutation into block-independent
%% sets. identical to the one used in arms.
%% 
%% ON ENTRY :
%% A     = sparse matrix 
%% tol   = tolerance for rejecting not sufficiently diagonal
%%         dominant rows. [set to zero to turn off]
%% nDoms = number of blocks.. 
%%
%% RETURNED ARGUMENTS
%% rperm = permutation. A(rperm,rperm) will be permuted in
%%         the block-form of arms
%% nB    = size of the big upper-left block (which has the 
%%         block form) -- nB   = dimension of B-bock in permuted
%%         matrix (see paper):  
%%    
%%          | B   F |
%% P A P' = |       |
%%          | E   C | 
%% 
%% 
   [list,ptr,marker] =  rdis(A, ndom) ; 
   [rperm,blocks] = separx(A,ndom,marker,list,ptr) ; 
   blocks 
   nB   = sum(blocks(1:ndom)) 
   n = size(A)  

    hold off
    spy(A(rperm,rperm)) 
    hold on 
    plot([1,n],[nB,nB],'red')
    plot([nB,nB],[1,n],'red') 
    pause 


      
