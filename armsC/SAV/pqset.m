   function [pperm, qperm, nB] = indset(A,tol,bsize) 
%% 
%% [pperm, nB] = indset(A,tol,bsize) 
%%
%% computes the permutation into block-independent
%% sets. identical to the one used in arms.
%% 
%% ON ENTRY :
%% A     = sparse matrix 
%% tol   = tolerance for rejecting not sufficiently diagonal
%%         dominant rows. [set to zero to turn off]
%% bsize = block size.. actual size of each is >= bsize
%%
%% RETURNED ARGUMENTS
%% pperm = permutation. A(pperm,pperm) will be permuted in
%%         the block-form of arms
%% nB    = size of the big upper-left block (which has the 
%%         block form) -- nB   = dimension of B-bock in permuted
%%         matrix (see paper):  
%%    
%%          | B   F |
%% P A Q' = |       |
%%          | E   C | 
%% 
%% 
n = size(A,1)  ; 
%% compute weights.
for i=1:n
   w(i) = abs(A(i,i)) / norm(A(i,:),1); 
end
w = w ./ max(w) ;
%% initialize perm; 
perm(1:n) = -1; 
pperm = perm; 
nback = n+1; 
for j=1:n
    if (w(j) < tol) 
      nback = nback-1;
      perm(j) = nback;
      pperm(nback) = j;
    end
end
%% 
%%   main loop 
%% 
last = 0; 
for nod=1:n 
   if (perm(nod) <=0 )
%% add to IS
     last=last+1;
     perm(nod) = last;
     pperm(last) = nod; 
%%  traversal initialization 
     begin = last;
     blk_start = begin;
     count = 1;
     prog = 1;
%% traversal of last level 
     while ((count < bsize) & (prog))
           prev_last = last; 
           prev_count = count;
           for inod=begin:prev_last
               jnod = pperm(inod);
               [i,j,r] = find(A(jnod,:));
               [i,j1,r] = find(A(:,jnod));
               j = union(i',j);
               for k=1:length(j)
                    jcol = j(k) ;
                    if (perm(jcol) == -1) 
                       last = last+1;
		       perm(jcol) = last;
		       pperm(last) = jcol;
		       count = count+1;
         	    end
               end
            end
	    prog = (count > prev_count) ;
            begin = prev_last+1;
     end  %% while (count ..) 
%%% put next level to complement set/
     for inod=begin:last
         jnod = pperm(inod);
         [i,j,r] = find(A(jnod,:));
         [i,j1,r] = find(A(:,jnod));
         j = union(j,j1);
         for k=1:length(j)
             jcol = j(k) ;
	     if (perm(jcol) == -1) 
                nback = nback-1 ; 
	        perm(jcol) = nback;
	        pperm(nback) = jcol;
             end
	 end
     end
%%% reverse ordering for this level 
    mid = (blk_start + last )/2; 
    for (inod=blk_start:mid) 
        k = last - inod + blk_start;
        jnod = pperm(inod) ;
        pperm(inod) = pperm(k);
        pperm(k) = jnod;
    end
%% end for loop 
 end
end

nB   = last;
qperm = pperm;
      
