function err = check_perm(perm,m) 
%% function err = check_perm(perm) ;
%% err = 0 --> OK; -1 -->incorrect size
%% i>1  --> perm incorrect 
err = 0;
n = length(perm);
if (n ~= m) 
     err = -1;
     return
end
temp = zeros(n,1);
for j=1:n 
     k = perm(j) ;
    if (k <= 0 || k>n)
      err = j;
      return;
    end 
    temp(k) = temp(k) + 1;
    if (temp(k) > 1) 
        err = j;
     return 
     end
end 
