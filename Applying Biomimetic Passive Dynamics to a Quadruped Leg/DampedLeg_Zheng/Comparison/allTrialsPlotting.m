%% Trial plotting
% Plot all trials to be used
clear
% close all
% clc

% Add paths needed for loading data and using functions
addpath(genpath('C:\Github\Quadruped_Robot\Code\Matlab\Analysis\DampedLeg_Krnacik'))
addpath(genpath('C:\Github\Quadruped_Robot\Code\Matlab\Analysis\DampedLeg_Zheng'))
% addpath('C:\Github\Quadruped_Robot\Code\Matlab\Analysis\DampedLeg_Krnacik\Haonan\Parameter optimization\Optimizer functions and data')
% addpath('C:\Github\Quadruped_Robot\Code\Matlab\Analysis\DampedLeg_Krnacik\Haonan\Parameter optimization\IC_check')
% addpath('C:\Github\Quadruped_Robot\Code\Matlab\Analysis\DampedLeg_Krnacik\Haonan\Parameter optimization\Results')
% addpath('C:\Github\Quadruped_Robot\Code\Matlab\Analysis\DampedLeg_Krnacik\Haonan\Comparison\No Damping')
% addpath('C:\Github\Quadruped_Robot\Code\Matlab\Analysis\DampedLeg_Krnacik\Haonan\Comparison\Trial 2')
% points = [0 0.4];

% Load the data file for all joint data
load('-mat', 'jdata');
load('-mat', 'start_indices')
load('-mat', 'end_indices')
load QuadrupedAvg.mat
load QuadrupedNoDampingAvg.mat

muscles = 1:7;
trials = [5 1 1 1 1 1 1];
muscle_names = {'IP', 'GS', 'ST', 'ST2', 'VL', 'BFp', 'BFa'};

fig = figure('Color', 'w');
% sgtitle({'Comparison of Quadruped Hind Leg With and Without Integrated Passive Dynamics to Scaled Rat Leg Data',' '})

for n = 1:length(muscles)
    
    % Choose muscle and trial, and starting index value (check figure from
    % "plotjdat" in RawDataPlottingProcessing folder. All starting values
    % have been manually chosen and saved to "start_indices" data file.
    muscle = muscles(n);
    trial = trials(n);
    data1 = QuadrupedAvg{n};
    data2 = QuadrupedNoDampingAvg{n};

    start_index = start_indices(muscle, trial);
    end_index = end_indices(muscle, trial);

    % From chosen muscle and trial extract joint angles and time data. Note that
    % first cell of jdata corresponds to theta values, the second corresponds
    % to time values, and the third corresponds to "force" values.
    time = jdata{2}{muscle, trial}(start_index:end_index);                          % [s]
    time = 2*(time - time(1));
    thetas = jdata{1}{muscle, trial}(start_index:end_index, :) * (2 * pi)/360;      % [rad]
    thetas = rad2deg(thetas);                                                       % [deg]
    
    subplot(2, 4, n)
    
    % Create graph set-up
    title(strcat(muscle_names(n)))
    if n == 1 || n==5
        ylabel('Joint angles (deg)')
    end
    if n == 6
        xlabel('Time (s)'); 
    end
    xlim([0 1.4]); ylim([80 180])
    
    hold on
    
    % Plot all three joint angles
    plot(time, thetas(:,1), '-k', 'Linewidth', 2) %, 'MarkerSize', 3)
    plot(time, thetas(:,2), '-b', 'Linewidth', 2) %, 'MarkerSize', 3)
    plot(time, thetas(:,3), '-r', 'Linewidth', 2) %, 'MarkerSize', 3)
   
    plot(data1(:,4),data1(:,1),':k', 'Linewidth', 2);
    plot(data1(:,4),data1(:,2),':b', 'Linewidth', 2);
    plot(data1(:,4),data1(:,3),':r', 'Linewidth', 2);
        
    plot(data2(:,4),data2(:,1),'--k', 'Linewidth', 2);
    plot(data2(:,4),data2(:,2),'--b', 'Linewidth', 2);
    plot(data2(:,4),data2(:,3),'--r', 'Linewidth', 2);
    
%         plot(data1(:,4),data1(:,1),'ok','MarkerSize',1);
%         plot(data1(:,4),data1(:,2),'ob','MarkerSize',1);
%         plot(data1(:,4),data1(:,3),'or','MarkerSize',1);
%         
%         plot(data2(:,4),data2(:,1),'^k','MarkerSize',1);
%         plot(data2(:,4),data2(:,2),'^b','MarkerSize',1);
%         plot(data2(:,4),data2(:,3),'^r','MarkerSize',1);

end

x0=500;
y0=500;
width=900;
height=400;
set(gcf,'position',[x0,y0,width,height])

subplot(2, 4, 7)
legend('Hip (scaled rat)', 'Knee (scaled rat)', 'Ankle (scaled rat)','Hip with springs & dampers)','Knee with springs & dampers','Ankle with springs & dampers','Hip without springs or dampers','Knee without springs or dampers','Ankle without springs or dampers')
legend('Location','southeast')

% save figure
% addpath('C:\Users\krnac\OneDrive\Desktop\School\Dynamic leg\Krnacik\Parameter optimization\Trial plotting')
% saveas(fig, 'C:\Users\krnac\OneDrive\Desktop\School\Dynamic leg\Krnacik\Parameter optimization\Trial plotting\Plotted_trials.fig')