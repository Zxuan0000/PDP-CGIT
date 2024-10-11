function plotParetoFronts()
    clc;
    clear;
    close all;

    con = configure();
    T_parameter = con.T_parameter;
    functions = con.TestFunctions;
    funcNum = size(functions, 2);
    groupNum = size(T_parameter, 1);

    % 确保目标文件夹存在，如果不存在，创建它
    folderPath = 'E:\drawall';
    if ~exist(folderPath, 'dir')
        mkdir(folderPath);
    end

    % 遍历所有测试函数和配置组合
    for testFuncNo = 5:funcNum
        testfunname = functions{testFuncNo};
        for group = 1
            for tempPosition = 1:20
                % 创建图形窗口
                f = figure('Visible','off');
                hold on;

                % 定义文件名
                dataReal = importdata(['./Benchmark/pof/' 'POF-nt' num2str(T_parameter(group,1)) '-taut' num2str(T_parameter(group,2)) '-' testfunname '-' num2str(tempPosition) '.txt']);
                dataObtained = importdata(['EASY' '-' testfunname '-nt' num2str(T_parameter(group,1)) '-taut' num2str(T_parameter(group,2)) 'environment' num2str(tempPosition) '-POF' '.txt']);

                % 绘图
                if size(dataReal, 2) == 2
                    plot(dataReal(:,1), dataReal(:,2), 'ro', 'DisplayName', 'Real Pareto Front');
                    hold on;
                    plot(dataObtained(:,1), dataObtained(:,2), 'bx', 'DisplayName', 'Obtained Pareto Front');
                    title([testfunname ' - Function ' num2str(testFuncNo)]);
                    xlabel('f(x_1)');
                    ylabel('f(x_2)');
                    legend('show');
                elseif size(dataReal, 2) == 3
                    plot3(dataReal(:,1), dataReal(:,2), dataReal(:,3), 'ro', 'DisplayName', 'Real Pareto Front');
                    hold on;
                    plot3(dataObtained(:,1), dataObtained(:,2), dataObtained(:,3), 'bx', 'DisplayName', 'Obtained Pareto Front');
                    title([testfunname ' - Function ' num2str(testFuncNo)]);
                    xlabel('Objective 1');
                    ylabel('Objective 2');
                    zlabel('Objective 3');
                    legend('show');
                    view(3);  % 设置三维视角
                end

                % 图片保存路径和命名
                saveFileName = sprintf('%s\\%s-group%d-nt%d-taut%d-position%d.png', folderPath, testfunname, group, T_parameter(group, 1), T_parameter(group, 2), tempPosition);
                saveas(gcf, saveFileName);
                hold off;
            end
        end
    end
end