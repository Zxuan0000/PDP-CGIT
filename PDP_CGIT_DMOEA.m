function res=PDP_CGIT_DMOEA(Problem,popSize,MaxIt,T_parameter,group)
%PDP&CGIT This verson is implemented with MOEA/D
nt = T_parameter(group,1);
Tt = T_parameter(group,2);

   for T = 1:T_parameter(group,3)/T_parameter(group,2)
        t= 1/T_parameter(group,1)*(T-1);  
          fprintf(' %d',T);
    d = size(Problem.XLow,1);    %num of decision Variables
        if T <= 2
            if T==1 %Initial population is consisted of randomly generated solutions
                [PopX,Pareto,POF_iter]= moead(Problem,popSize,MaxIt,t);
                LastPOS_Arrow{T} = Pareto.X;
                LastPOF_Arrow{T} = Pareto.F;
            else %The POS of last environment is considered the inintial population in 2-th environment
                [PopX,Pareto,POF_iter]= moead(Problem,popSize,MaxIt,t,LastPOS_Arrow{T-1});
                LastPOS_Arrow{T} = Pareto.X;
                LastPOF_Arrow{T} = Pareto.F;
            end
        else
             %Construct the labeled target domain（为保证公平，所有对比算法也需要多进化一次）
            [PopX,Pareto,POF_iter]=moead(Problem,popSize,1,t,LastPOS_Arrow{T-1});
            CurrentPOS = Pareto.X;
            CurrentPOS = unique(CurrentPOS','rows','stable')';
           LastPOS = LastPOS_Arrow{T-1};
            RandomPopT = generateRandomPoints(size(CurrentPOS,2),Problem);
            Xt_label = [CurrentPOS RandomPopT]';
            num = size(Xt_label,1);
            Yt_label = [ones(size(CurrentPOS,2),1);zeros(size(CurrentPOS,2),1)];
            %Construct the source domain
            RandomPopS = generateRandomPoints(size(LastPOS,2),Problem);
            Xs = [LastPOS RandomPopS]';
            Ys = [ones(size(LastPOS,2),1);zeros(size(LastPOS,2),1)];
            %Construct the unlabeled target dimain (i.e., test samples),
            %matlab 存在bug, 需要打乱一点数据才会在迭代的时候生成随机，否则有可能生成一样的随机解
            testSize = randi([800 1000],1) + randi([1 100],1)*randi([1 5],1);
            Xt_unlabel = generateRandomPoints(testSize,Problem)';
            Yt_unlabel = zeros(size(Xt_unlabel,1),1); 
            Xt_unlabel = [Xt_label;Xt_unlabel];           
            Yt_unlabel = [Yt_label;Yt_unlabel]; 
            %%去除Nan行
       if any(isnan(Xs), 'all')
        error('Dct contains NaN');
      %  fprintf('Dct contains NaN');
      end
      %%
            %%
            [Acc1, y_pred] = PDP(num,Xs,Ys,Xt_unlabel,Yt_unlabel(1:size(Xt_unlabel,1),:));
            
           Xtest = Xt_unlabel;
            POPX_PDP = [];
            j=0;
            for i=1:size(y_pred,1)
                if y_pred(i)==2
                    j=j+1;
                    POPX_PDP(j,:)=Xtest(i,:);
                end
            end
            %%CGIT
            LastPOS = unique(LastPOS','rows','stable')';
            his_NDS = findClose22(LastPOS_Arrow{T-2}, LastPOS');
            POPX_CGIT = CGIT_prediction(LastPOS',his_NDS,LastPOS');

           
            %%High-quality initial population
            POPX_prediction = [POPX_CGIT;  POPX_PDP]; 
            if size(POPX_prediction,1)>popSize
                initPop = POPX_prediction(1:popSize,:);
             else
                 initPop = POPX_prediction;

            end
 % ^^^^^^^^^^^^^^^^^  check boundry^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
for i=1:size(initPop,1)
    for j=1:d
                 if initPop(i,j)<Problem.XLow(j,1)
               initPop(i,j)= min(Problem.XUpp(j,1),2*Problem.XLow(j,1)- initPop(i,j));
                end
                if  initPop(i,j)>Problem.XUpp(j,1)
               initPop(i,j) = max(Problem.XLow(j,1),2*Problem.XUpp(j,1)- initPop(i,j));
                end  
    end
end
            [PopX,Pareto,POF_iter]=moead(Problem,popSize,MaxIt,t,initPop'); 
            pos = Pareto.X;
            pof = Pareto.F;
            % 找到矩阵 中全为 NaN 的列
            nanColumns = all(isnan(pos), 1);
            % 从矩阵  中删除这些列
            pos(:, nanColumns) = [];            
            % 从矩阵 中删除相应的列
            pof(:, nanColumns) = [];
            LastPOS_Arrow{T} = pos;
            LastPOF_Arrow{T} = pof;

        end
        res{T}.POF_iter=POF_iter;
        res{T}.POS=PopX;
        res{T}.turePOF=getBenchmarkPOF(Problem.Name,group,T,T_parameter );     
   end
end
    
