 function [pord, qord, nB] = PQ (A, tol) 
 %%% function [pord,qord, nB] = pq(Q, tol) 
 n = size(A,1); 
 Pord = -ones(n,1) ; 
 Qord = -ones(n,1) ; 
 numnode = 1;
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
%%-------------------- */
   [discard, row, mrow] = find(A(ii,:)) ;
   nzi = length(row);
%------------------ rnz = already assigned cols (either in L or F) */
   [rn,kmax] = max(abs(mrow));
   rnz = (nzi-1) ; 
   for k=1:nzi 
       aij = abs(mrow(k));
       col = row(k);
       if (Qord(col) >=0 )
        	rn = rn -aij; 
        	rnz=rnz-1;
       elseif (Qord(col) == -2)
               rnz=rnz-1;
       end
       if (rn < 0.0)
             continue;   
       end 
       Pord(ii) = numnode;
       Qord(jj) = numnode;
       numnode = numnode+1;
   end
  end
%%-------------------- acceptance test among others */    
  for k=1:nzi
      col = row(k);
      if (Qord(col) ~= -1) 
          continue;
      end
      aij = abs(mrow(k));
      if (rnz*aij > rn) 
	Qord(col) = -2;
      else 
	rn = rn - aij;
      end
      rnz = rnz - 1;
  end
%%-------------------- number of B nodes */
  nB = numnode; 
%%  end-main-loop - complete permutation arrays
  for i=1:n 
    if (Pord(i) < 0) 
      numnode = numnode+1
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
      numnode = numnode+1'
      Qord(j) = numnode;
    end
  end
%%--------------------              */ 
  if (numnode ~= n) 
    error('  ** counting error - type 2 ') 
  end
