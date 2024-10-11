 function [ini_solution] = CGIT_prediction(curr_NDS, his_NDS, curr_POS1)
% Prediction via Denoising Autoencoding in AE-MOEA for solving DMOP.

% curr_NDS and his_NDS denote N_l number of non-dominated solutions obtained in the current and previous time windows, respectively. 
% Both in the form of N_l*d matrix. 相当于每一行是一个个体
% N_l is the number of individual, d is the variable dimension of the given DMOP, and NP denotes the population size of the evolutionary solver. 

% curr_POS is the POS solutions from current time window (the obtained non-dominated solution set). 

% output is the predicted initial solutions of the evolutionary search for new time window.
 %his_NDS = findClosestSolutions(curr_NDS, his_NDS);
    % 初始化zz为一个空数组，稍后会添加找到的解

% 
%  for ii = 1 :size(curr_POS1,1)
%      temp(ii,:) = curr_POS1(ii,:)+ sita';
%  end

% num1 = size(curr_NDS1,1);
% num2 = size(his_NDS1,1);
% minnum = min(num1,num2);
%     curr_NDS1 = curr_NDS1(1:minnum,:);
% 
%     his_NDS1 = his_NDS1(1:minnum,:);
% 
% LastPOS_center = mean(his_NDS1);
% CurrentPOS_center = mean(curr_NDS1);

% for ii = 1 : 10
%     curr_NDS = curr_NDS1(:,ii)';
%     his_NDS = his_NDS1(:,ii)';
%     curr_POS = curr_POS1(:,ii)';

%lamda1 = CurrentPOS_center - LastPOS_center;

[d, N_l] = size(curr_NDS');

Q = his_NDS*his_NDS';
P = curr_NDS*his_NDS';

lambda = 1e-5;
reg = lambda*eye(N_l);
reg(end,end) = 0;
M = P/(Q+reg);% the learned matrix M.

varM = M*his_NDS;
for i=1:N_l
    for j=1:d
        var(i,j) = (curr_NDS(i,j)-varM(i,j)).^2;
       % v(i,:) = mean2(var) ;
    end
end
v = mean2(var) ;

pre_solution = M* curr_POS1+v;
%pre_solution = M*temp+v;
%end
curr_len = size(pre_solution, 1);
% if curr_len > NP/2
%     ini_solution = pre_solution(:,1:NP/2);
% else 
    ini_solution = pre_solution;
% end
end