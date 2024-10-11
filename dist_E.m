
% function [minValue,row]=dis(B)
% 
% A=[];
% B=rand_BinaryMatrix(100,20);
% A=zeros(size(B,2),1);
% [N,M]=size(B);
% dist=zeros(N,1);
% for i=1:N
%     for j=1:M
%          dist(i,j)=norm(B(i,:)-A(j,:));
%     end
% end
% [minValue,row]=min(dist)    
% end

function x_row = dist_E(a)
B=sqrt(sum(a.*a,2));% 计算各行向量之间的欧式距离
       [x,y]=find(B==min(min(B)));
       x_row=x(1,1); 
end






