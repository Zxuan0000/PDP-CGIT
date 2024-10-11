clc
clear
close all
warning('off')
con=configure();
functions=con.TestFunctions;
T_parameter=con.T_parameter;
popSize=con.popSize;

for rep=1:20
    filename1 = ['MIGD-', num2str(rep), '.txt'];fid1 = fopen(filename1,'w');
    filename2 = ['MHV-', num2str(rep), '.txt'];fid2 = fopen(filename2,'w');
    for testFuncNo=1:size(functions,2)
        Problem=TestFunctions(functions{testFuncNo});
        if Problem.NObj==3
            popSize=150;
        end 
        for group=1:size(T_parameter,1) 
         MaxIt=T_parameter(group,2);
         fprintf('\n PDP_CGIT_DMOEA-DMOEA dec:%d runing on: %s, configure: %d, environment:',con.dec,Problem.Name,group);
         reskt=PDP_CGIT_DMOEA(Problem,popSize,MaxIt,T_parameter,group);        
         [resIGD,resHV]=computeMetrics(reskt,group,rep,testFuncNo,T_parameter);
         fprintf('\n %.3d',resIGD);
         fprintf(fid1,'%f \n',resIGD);
         fprintf(fid2,'%f \n',resHV);
        end %configure
    end%testF
    fclose all;
end%rep

function [resIGD,resHV]=computeMetrics(resStruct,group,rep,testFuncNo,T_parameter)
     for T=1:size(resStruct,2)
        POFIter=resStruct{T}.POF_iter;
        POFbenchmark=resStruct{T}.turePOF;
        for it=1:size(POFIter,2)
            pof=POFIter{it};
            pof(imag(pof)~=0) = abs(pof(imag(pof)~=0));
            igd(it)=IGD(pof',POFbenchmark);
            hv(it)=HV(pof',POFbenchmark);
        end
        IGD_T(T)=igd(end); 
        HV_T(T)=hv(end);
     end
     resIGD=mean(IGD_T);
     resHV=mean(HV_T);
     %%chuangjian
     if ~exist('res', 'dir')
        mkdir('res');
    end
    if rep ==3
     dirName = ['res/SELF-DF',num2str(testFuncNo),'-nt',num2str(T_parameter(group,1)),'-taut',num2str(T_parameter(group,2)), '.txt'];
     if ~exist(dirName, 'dir')
         mkdir(dirName);
     end
     % 在创建的文件夹中保存结果文件
     filename1 = [dirName, '/IGD.txt'];
     filename3 = [dirName, '/HV.txt'];
    % if group == 1 && rep == 3
         fid1 = fopen(filename1,'w');
         fid3 = fopen(filename3,'w');
         for i=1:size(IGD_T,2)
              fprintf(fid1,'%f \n',IGD_T(i)); 
         end        
         for i=1:size(HV_T,2)
              fprintf(fid3,'%f \n',HV_T(i)); 
         end
         fclose(fid1);
         fclose(fid3);
  %   end
     
%     if group == 1 && rep == 3
         for T=1:size(resStruct,2)
             % filename = ['AAE-DF',num2str(testFuncNo),'-nt',num2str(T_parameter(group,1)),'-taut',num2str(T_parameter(group,2)),'environment',num2str(T), '-POF', '.txt'];
              filename = [dirName, '/', 'environment', num2str(T), '-POF.txt'];
             fid = fopen(filename,'w');
              POFIter=resStruct{T}.POF_iter;
              pof = POFIter{size(POFIter,2)};
              pof(imag(pof)~=0) = abs(pof(imag(pof)~=0));
              for j=1:size(pof,2)
                  if size(pof,1) == 2
                       fprintf(fid,'%f \t %f \n',pof(1,j),pof(2,j)); 
                  else
                      fprintf(fid,'%f \t %f \t %f \n',pof(1,j),pof(2,j),pof(3,j)); 
                  end
              end
              fprintf(fid,'\n'); 
         end
         fclose(fid);  
    end
end
