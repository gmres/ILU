function z = droprow(v, droptol, lfil)
% 
% DROP  Drop elements in sparse row based on droptol and lfil.
% result in z
% 
 [i, discard, t] = find(v);
 n1 = nnz(v) ;
 [m,n] = size(v);
 if (droptol > 0)
%%%%% tol = droptol;
tol = droptol*norm(t,1)/(1+length(t));
   for k = 1:n1 
     if (abs(t(k))  < tol) t(k) = 0.0 ; end 
   end
 end    %% endif 
%% 
if (n1 > lfil)
   [tmp, perm] = sort(-abs(t)); 
   for k=lfil+1:n1
   t(perm(k)) = 0.0 ; 
   end 
end 
   z = sparse(i,discard,t,m,n) ;
