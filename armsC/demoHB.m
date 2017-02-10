close; %% to remove all previous plots 

%%-------------------------------------------------
%% load a Harwell-Boeing matrix 
%%-------------------------------------------------
%%%addpath '/home/saad/matlab/HB'
load('bp_1000')
%%%%load('west2021');

A = Problem.A;

n = size(A,1);

     spy(A) 
     title(['Level  0 ;  n = ',num2str(n)],'fontsize',18) 
     outp = 'bp0'; 
     print(gcf,'-deps2', '-r864',outp); 

disp('pausing ... ') 
pause(3)
close 
%%-------------------------------------------------
%% create artificial rhs
rhs = A * ([1:n]') ; 
%% random initial guess
sol = rand(n,1); 
%--------------------------------------------------
% read parameters from file 
%%------------------------------------------------- 
 rhs = A * ([1:n]') ; sol = rand(n,1); 
%%  Call arms preconditioner set-up
 ARMSopt = arms_params;
ARMSopt.nlev = 5; ARMSopt.tolInd = 0.2;
 %%%ARMSopt.tolInd = 0.8;  ARMSopt.ilutolB = 0.001; ARMSopt.lfilB = 15;
 %%%ARMSopt.lfilE = 15; ARMSopt.droptolE = 0.001; 
 PRE = armsC(A,ARMSopt) ;
%%--------------------------------------------------- 
%% ready to call fgmres
 disp(' solution with ARMS(3)-GMRES') 
 [sol,res,its] = fgmres(A, PRE,'armsprecC', rhs, sol,ARMSopt) ;
 ffact = memus(PRE)/nnz(A) ;
 fprintf('fill-factor = %f \n',ffact)

 disp(' ** done ** ') 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
