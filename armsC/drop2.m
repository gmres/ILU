function B = drop2(A, droptol, lfil)
% DROP  Drop elements in sparse matrix A based on droptol and lfil.
% dropping done by column -- 
[m,n] = size(A); 
B = sparse(m,n);
for ii=1:n
  v = A(:,ii) ;
  [i, discard, t] = find(v);
  n1 = length(t) ; 
  if (droptol > 0)
     tol = droptol*norm(t,1)/(length(t)+1);
    for k = 1:n1 
     if (abs(t(k))  < tol) t(k) = 0.0 ; end 
    end
   end    %% endif 
%%
   if (n1 > lfil)
      [tmp, perm] = sort(-abs(t)); 
      t(perm(lfil+1:n1)) = 0.0;
   end
   B(:,ii) = sparse(i, discard, t, m, 1);
end


