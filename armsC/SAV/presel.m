function [icor, jcor, count] = presel(A, tol) 
%% function [icor, jcor, count] = presel(A, tol) ;
n = size(A,1);
%% this is in order to work by columns - 
%% matlab is very slow in working by rows
B = A';
wmax = 0.0;
for i=1:n
    [row, discard, mrow] = find(B(:,i));
    [t,k] = max(abs(mrow));
    t = t / norm(mrow,1);
    weight(i) = t;
    jcor(i) = row(k) ;
    wmax = max(t,wmax); 
end

%% now select according to tol 
  count = 0; 
  for i=1:n 
    t = weight(i) ;
    col = jcor(i) ;
    if (t >= wmax*tol)
      count = count+1;
      weight(count) =  t / nnz(B(:,i)); 
      icor0(count) = i; 
      jcor0(count) = col;
    end
  end
%%%% SORT DECREASINGLY 
  [weight,perm] = sort(-weight(1:count));
  icor = icor0(perm);
  jcor = jcor0(perm);

