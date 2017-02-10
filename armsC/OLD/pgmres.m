 function [sol] = pgmres (PRE, rhs, sol) 
% 
%  pgmres -- used for last level solve only !!
%  use schurprod for matvecs.. 
%  
arms_params; 
nlevp1 = size(PRE,2);
lev = nlevp1 ; 
[pperm, qperm, LS, US, F0, E0, C0] = unpack(PRE(lev)) ; 
%% take care of FB sweep for last level
if (imS == 0 | nlevp1 <=1) 
    sol = US \(LS \ rhs) ; 
    return; 
else
    [pperm,qperm,LB, UB, F, E, C] = unpack(PRE(lev-1)) ; 
end
%%%%
 n = size(sol,1)    ;
 its = 0    ;
% 
% main loop 
% only imS steps done !! 
 im = imS ; 
 maxits = imS; 
 while (its < maxits) 
      vv(1:n,1) = rhs - schurprod(LB,UB,F,E,C,sol) ; 
      %%
      ro = norm(vv(1:n,1),2)  ; 
      if (outputI) 
         fprintf(1,'   **inn-its %d  res %e \n',its,ro)
      end 
%%      
      if (its  == 0) 
	tol1=tolInner*ro  ;
      end  ; 
      if (ro <= tol1 | its >= maxits)  
	return
      end
      t = 1.0/ ro   ;
      vv(1:n,1) = vv(1:n,1) * t  ;
%       initialize 1-st term  of rhs of hessenberg system..  ;
      rs(1) = ro  ;
      i = 0  ;
%
 while (i < im  &  (ro  >  tol1)  &  its < maxits)
      i=i+1  ;
      its = its + 1  ;
      i1 = i + 1  ;
      z = US \ (LS\ vv(:,i)); 
% modified GS  ;
      vv(1:n,i1) = schurprod(LB,UB,F,E,C,z); 
      for j=1:i
           t = vv(1:n,j)'*vv(1:n,i1)  ;
           hh(j,i) = t  ;
	   vv(1:n,i1) = vv(1:n,i1) - t*vv(1:n,j)  ;
      end  ;
      t = norm(vv(1:n,i1),2)  ;
      hh(i1,i) = t  ;
      if (t  ~= 0.0)  
        t = 1.0 / t  ;
        vv(1:n,i1) = vv(1:n,i1)*t  ;
      end  ; %% IF 
% 
    if (i ~= 1) 
%
%       perfrom previous transformations  on i-th column of h  ;
%
      for k=2:i 
         k1 = k-1  ;
         t = hh(k1,i)  ;
         hh(k1,i) = c(k1)*t + s(k1)*hh(k,i)  ;
         hh(k,i) = -s(k1)*t + c(k1)*hh(k,i)  ;
      end;  %% FOR 
    end  ; %% IF 
%%
      gam = sqrt(hh(i,i)^2 + hh(i1,i)^2)  ;
      if (gam  == 0.0) 
	gam = tolmac  ;
      end  ; 
%
%       determine plane rotation and update rhs of ls pb   ;
% 
      c(i) = hh(i,i)/gam  ;
      s(i) = hh(i1,i)/gam  ;
      rs(i1) = -s(i)*rs(i)  ;
      rs(i) =  c(i)*rs(i)  ;
%
%       determine res. norm. and test for convergence-  ;
%
      hh(i,i) = c(i)*hh(i,i) + s(i)*hh(i1,i)  ;
      ro = abs(rs(i1))  ;
      if (outputI) 
         fprintf(1,'   **inn-its %d  res %e \n',its,ro)
      end 
% debug      fprintf(1,' ** inner  ** its %d  res %e \n',its,ro)
   end   ;  %% end of while (im) loop 
% 
%       now compute solution. first solve upper triangular system.  ;
% 
      rs(i) = rs(i)/hh(i,i)  ;
      for  k=i-1:-1:1  ;
         t=rs(k)  ;
         for j=k+1:i  ;
            t = t-hh(k,j)*rs(j)  ;
         end  ;
         rs(k) = t/hh(k,k)  ;
      end  ;
%
%       done with back substitution..  ;
%       now form linear combination to get solution  ;
%         ;
      z = rs(1) * vv(:,1) ;
      for j=2:i 
         z = z +rs(j)* vv(:,j)   ;
      end  ;
      sol = sol + US \ (LS \ z) ;
      
      if ((ro  <=  tol1) | (its >= maxits)) return; end; 
   end;  %% end while -- restart 


