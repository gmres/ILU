 function [Pord, Qord, nB] = PQ (A, tol) 
 %%% function [pord,qord, nB] = pq(Q, tol) 
 n = size(A,1); 
 Pord = -ones(n,1) ; 
 Qord = -ones(n,1) ; 
 numnode = 0;
%%-------------------- wDiag selects candidate entries in a sorted oder */
  [icor, jcor, count] = presel(A, tol) ;
%%-------------------- add entries one by one to diagnl */
%% needs recoding so as to scan rows only once instead of 2 */
%%
 for i=1:count 
     ii = icor(i);
     jj = jcor(i); 
     if (Qord(jj) ~= -1)
        continue;
     end 
     numnode = numnode+1;
     Pord(ii) = numnode;
     Qord(jj) = numnode;
 end
%%-------------------- acceptance test among others */    
  nB = numnode; 
%%  end-main-loop - complete permutation arrays
  for i=1:n 
    if (Pord(i) < 0) 
     numnode = numnode+1;
      Pord(i) = numnode; 
    end
  end 
%% 
  if (numnode ~= n)
    error('  ** counting error - type 1 ') 
  end
  numnode = nB;

  for j=1:n 
    if (Qord(j) < 0)
     numnode = numnode+1;
     Qord(j) = numnode;
    end
  end
%%--------------------              */ 
  if (numnode ~= n) 
    error('  ** counting error - type 2 ') 
  end
