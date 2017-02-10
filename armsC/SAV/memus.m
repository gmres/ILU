function nzp = memus(PRE)
%% function nzp = memus(PRE)
%% 
nlev = length(PRE);
nzp = 0;
for lev = 1:nlev 
     ST = PRE(lev);
fprintf(' lev %d nzU %d nzL %d nzE %d nzF %d nzC %d sofar %d \n',...
        lev, nnz(ST.L),nnz(ST.U),nnz(ST.E),nnz(ST.F),nnz(ST.C),nzp) 
     nzp = nzp + nnz(ST.L) + nnz(ST.U) +  nnz(ST.E) + nnz(ST.F)+nnz(ST.C);
     nzp = nzp  -  size(ST.L,1)  ;
end
