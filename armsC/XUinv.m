function S = XUinv(U, X, droptol, lfil) 
%-----------------------------------------------------------------------
%  function S = XUinv(U, X, droptol, lfil) 
%  S U = X 
%-----------------------------------------------------------------------
[n,m] = size(X) ;

S = sparse(n,m) ; 
if (n == 0 | m == 0)
    return
end
%% 
for ii=1:m 
   [iu, discard, tu] = find(U(:,ii)) ; 
   v = X(:,ii); 
   for k=1:length(iu)
     col = iu(k);
     if (col == ii) 
         diag = tu(k) ;
     else 
         v = v - tu(k) .* S(:,iu(k));
     end
   end 
   z = droprow(v, droptol, lfil); 
   S(:,ii) = z ./  diag; 
end 

