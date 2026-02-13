function [] = Plot_results()
close all;
clear all;
clc;

Parameters_vs_config();
Convergence();
Parameters();

end


function [] = Convergence()
% convergence
% VM = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
Configuration = [1, 2, 3, 4, 5];
load Fitness;
for n = 1 : size(Fit,2)
    for j = 1 : size(Fit{1, 1},1) % For all algorithms
        valu(j,:) = stats(Fit{1, n}(j,:));
    end
    disp('Statistical Analysis :')
    fprintf('Configuration : %d\n ', Configuration(n));
    ln = {'BEST','WORST','MEAN','MEDIAN','STANDARD DEVIATION'};
    T = table(valu(1, :)', valu(2, :)', valu(3, :)',valu(4, :)', valu(5, :)','Rownames',ln);
    T.Properties.VariableNames = {'GRO','GJO','EHO','RPO','HEH-RPO'};
    disp(T)
    
    figure,
    plot(Fit{1, n}(1,:),'Color','r', 'LineWidth', 2)
    hold on;
    plot(Fit{1, n}(2,:),'Color','g', 'LineWidth', 2)
    plot(Fit{1, n}(3,:),'Color','#EDB120', 'LineWidth', 2)
    plot(Fit{1, n}(4,:),'Color','[0.3010 0.7450 0.9330]', 'LineWidth', 2)
    plot(Fit{1, n}(5,:),'Color','k', 'LineWidth', 2)
    set(gca,'fontsize',20);
    xlim([0 250]);
    xlabel('No. of Iterations','fontsize',16);
    ylabel('Cost Function','fontsize',16);
    h = legend('GRO','GJO','EHO','RPO','HEH-RPO');
    set(h,'fontsize',12,'Location','Best')
%     print('-dtiff','-r300',['.\Results\', 'Convergence '])
    print('-dtiff','-r300',['.\Results\', 'Configuration ',num2str(Configuration(n))])
end

end


function[a] = stats(val)
a(1) = min(val);
a(2) = max(val);
a(3) = mean(val);
a(4) = median(val);
a(5) = std(val);
end


function [] = Parameters()
load RES;
X = (1:1:10);

 %% plot Number of VM vs Energy Consumption
    figure,
    bar(X, RES.EC_VM')
    set(gca, 'FontSize', 14);
    xlabel('No of VM', 'FontSize', 14);
    ylabel('Energy Consumption (kWh)', 'FontSize', 14);
    h = legend('GRO','GJO','EHO','RPO','HEH-RPO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'No of VM vs Energy Consumption'])

 %% plot Number of VM vs Redution of time span
    figure,
    bar(X, RES.TS_VM')
    set(gca, 'FontSize', 14);
    xlabel('No of VM', 'FontSize', 14);
    ylabel('Redution of time span (S)', 'FontSize', 14);
    h = legend('GRO','GJO','EHO','RPO','HEH-RPO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'No of VM vs Redution of time span'])
    
    
 %% plot Number of VM vs Reliability
    figure,
    bar(X, RES.R_VM')
    set(gca, 'FontSize', 14);
    xlabel('No of VM', 'FontSize', 14);
    ylabel('Reliability (%)', 'FontSize', 14);
    h = legend('GRO','GJO','EHO','RPO','HEH-RPO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'No of VM vs Reliability'])
    
 %% plot Number of VM vs Execution Time
    figure,
    bar(X, RES.ET_VM')
    set(gca, 'FontSize', 14);
    xlabel('No of VM', 'FontSize', 14);
    ylabel('Execution Time (S)', 'FontSize', 14);
    h = legend('GRO','GJO','EHO','RPO','HEH-RPO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'No of VM vs Execution Time'])
    
 %% plot CPU utilization vs Running time
    figure,
    X1 =(1:1:7);
    bar(X1, RES.CU_RT')
    set(gca, 'FontSize', 14);
%     xticks([0 1 2])
    xticklabels({'1','4','8','12','16','20','24'})
    xlabel('Running Time (H)', 'FontSize', 14);
    ylabel('CPU utilization (%)', 'FontSize', 14);
    h = legend('GRO','GJO','EHO','RPO','HEH-RPO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Running Time vs CPU utilization'])

end


function [] = Parameters_vs_config()
load RESULT;
X = (1:1:5);

 %% plot Configuration vs Energy Consumption
    figure,
    bar(X, RESULT.EC_C')
    set(gca, 'FontSize', 14);
    xlabel('Configuration', 'FontSize', 14);
    ylabel('Energy Consumption (kWh)', 'FontSize', 14);
    h = legend('GRO','GJO','EHO','RPO','HEH-RPO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Configuration vs Energy Consumption'])

 %% plot Configuration vs time span
    figure,
    bar(X, RESULT.TS_C')
    set(gca, 'FontSize', 14);
    xlabel('Configuration', 'FontSize', 14);
    ylabel('Time span (S)', 'FontSize', 14);
    h = legend('GRO','GJO','EHO','RPO','HEH-RPO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Configuration vs Redution of time span'])
    
    
 %% plot Configuration vs Cost
    figure,
    bar(X, RESULT.C_C')
    set(gca, 'FontSize', 14);
    xlabel('Configuration', 'FontSize', 14);
    ylabel('Cost', 'FontSize', 14);
    h = legend('GRO','GJO','EHO','RPO','HEH-RPO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Configuration vs Cost'])
    
 %% plot Configuration vs Throughput
    figure,
    bar(X, RESULT.T_C')
    set(gca, 'FontSize', 14);
    xlabel('Configuration', 'FontSize', 14);
    ylabel('Throughput', 'FontSize', 14);
    h = legend('GRO','GJO','EHO','RPO','HEH-RPO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Configuration vs Throughput'])
     
 %% plot Configuration vs Delay
    figure,
    bar(X, RESULT.Delay_C')
    set(gca, 'FontSize', 14);
    xlabel('Configuration', 'FontSize', 14);
    ylabel('Delay', 'FontSize', 14);
    h = legend('GRO','GJO','EHO','RPO','HEH-RPO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Configuration vs Delay'])
     
 %% plot Configuration vs Time
    figure,
    bar(X, RESULT.Time_C')
    set(gca, 'FontSize', 14);
    xlabel('Configuration', 'FontSize', 14);
    ylabel('Time (S)', 'FontSize', 14);
    h = legend('GRO','GJO','EHO','RPO','HEH-RPO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Configuration vs Time'])
     
 %% plot Configuration vs Load
    figure,
    bar(X, RESULT.Load_C')
    set(gca, 'FontSize', 14);
    xlabel('Configuration', 'FontSize', 14);
    ylabel('Load', 'FontSize', 14);
    h = legend('GRO','GJO','EHO','RPO','HEH-RPO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Configuration vs Load'])
     
 %% plot Configuration vs Makespan
    figure,
    bar(X, RESULT.Makespan_C')
    set(gca, 'FontSize', 14);
    xlabel('Configuration', 'FontSize', 14);
    ylabel('Makespan', 'FontSize', 14);
    h = legend('GRO','GJO','EHO','RPO','HEH-RPO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Configuration vs Makespan'])
      
 %% plot Configuration vs Res Energy
    figure,
    bar(X, RESULT.R_Energy_C')
    set(gca, 'FontSize', 14);
    xlabel('Configuration', 'FontSize', 14);
    ylabel('Residual Energy', 'FontSize', 14);
    h = legend('GRO','GJO','EHO','RPO','HEH-RPO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Configuration vs Residual Energy'])
 
end