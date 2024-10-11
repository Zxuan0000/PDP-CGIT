
clc;
clear;
% 初始化一个20x56的矩阵，存储从每个文件读取的数据
dataMatrix = zeros(20, 56);

% 循环读取每个文件
for i = 1:20
    % 构造文件名
    filename = sprintf('MIGD-%d.txt', i);
    
    % 读取文件中的数据
    data = load(filename); % 假设文件中的数据是纯数值且格式正确
    
    % 将读取的数据存储到矩阵的对应行中
    dataMatrix(i, :) = data;
end

% 计算每个位置的平均值，按列计算
meanValues = mean(dataMatrix);

% 计算每个位置的标准差，按列计算
stdDeviations = std(dataMatrix);



meanFilePath = fullfile(getenv('USERPROFILE'), 'Desktop', 'results','MIGD','aeEASYmeanValues.txt');
stdDevFilePath = fullfile(getenv('USERPROFILE'), 'Desktop', 'results', 'MIGD','aeEASYstdDeviations.txt');
% 打开一个文件用于写入标准差
fileID = fopen(meanFilePath, 'w');
% 写入标准差，每个值保留四位小数
fprintf(fileID, '%.3d\n', meanValues);
% 关闭文件
fclose(fileID);
% 打开一个文件用于写入平均值
fileID = fopen(stdDevFilePath, 'w');
% 写入平均值，每个值保留四位小数
fprintf(fileID, '%.3d\n', stdDeviations);
% 关闭文件
fclose(fileID);

disp('平均值和标准差已保存到TXT文件中。');