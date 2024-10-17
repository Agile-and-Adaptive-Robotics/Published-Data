%% Trial plotting
% Plot all trials to be used
clear
% close all
% clc

% Add paths needed for loading data and using functions

addpath(genpath('C:\GitHub\Published-Data\Applying Biomimetic Passive Dynamics to a Quadruped Leg\DampedLeg_Krnacik'))
addpath(genpath('C:\GitHub\Published-Data\Applying Biomimetic Passive Dynamics to a Quadruped Leg\DampedLeg_Zheng'))
% addpath('C:\Github\Quadruped_Robot\Code\Matlab\Analysis\DampedLeg_Krnacik\Haonan\Parameter optimization\Optimizer functions and data')
% addpath('C:\Github\Quadruped_Robot\Code\Matlab\Analysis\DampedLeg_Krnacik\Haonan\Parameter optimization\IC_check')
% addpath('C:\Github\Quadruped_Robot\Code\Matlab\Analysis\DampedLeg_Krnacik\Haonan\Parameter optimization\Results')
% addpath('C:\Github\Quadruped_Robot\Code\Matlab\Analysis\DampedLeg_Krnacik\Haonan\Comparison\No Damping')
% addpath('C:\Github\Quadruped_Robot\Code\Matlab\Analysis\DampedLeg_Krnacik\Haonan\Comparison\Trial 2')
points = [0 0.4];

% Load the data file for all joint data
load('-mat', 'jdata');
load('-mat', 'start_indices')
load('-mat', 'end_indices')
load QuadrupedAvg.mat
load QuadrupedNoDampingAvg.mat

muscles = 1:7;
trials = [5 1 1 1 1 1 1];
muscle_names = {'IP', 'GS', 'ST', 'ST2', 'VL', 'BFp', 'BFa'};

% fig = figure('Color', 'w');
% sgtitle({'Comparison of Quadruped Hind Leg With and Without Integrated Passive Dynamics to Scaled Rat Leg Data',' '})

n = 2; % Plotting GS muscle stimulation only
    
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
    
    
    % Create graph set-up
    figure
    subplot(1,3,1)
        hold on
        % title(strcat({'Muscle stimulated: '}, muscle_names(n), {', Trial chosen: '}, num2str(trial)))
        % title('Comparison of Quadruped Hind Leg With and Without Integrated Passive Dynamics to Scaled Rat Leg Data','FontSize',15)
        % xlabel('Time (s)','FontSize',15)
        ylabel('Joint angles (deg)','FontSize',12)
        xlim([0 1.4]);% ylim([80 180])
    
        % Plot all three joint angles
        plot(time, thetas(:,1), '-k','LineWidth', 2)
        plot(data1(:,4),data1(:,1),':k','LineWidth',3);
        plot(data2(:,4),data2(:,1),'--k','LineWidth',2);
        title('Hip','FontSize',12)

    
    subplot2 = subplot(1,3,2);
        hold on
        xlabel('Time (s)','FontSize',12)
        % ylabel('Joint angles (deg)','FontSize',15)
        xlim([0 1.4]); ylim([100 180])
    
        % Plot all three joint angles
        plot(time, thetas(:,2), '-k','LineWidth', 2)
        plot(data1(:,4),data1(:,2),':k','LineWidth',3);
        plot(data2(:,4),data2(:,2),'--k','LineWidth',2);
        title('Knee','FontSize',12)
    
    legend('Location','north')
    legend('Scaled rat','With Spring and Damper','Without Spring and Damper')
    set(subplot2,'YTickLabel',{'100','110','120','130','140','150','160','',''});


    subplot(1,3,3)
        hold on
        % xlabel('Time (s)','FontSize',15)
        % ylabel('Joint angles (deg)','FontSize',15)
        xlim([0 1.4]);% ylim([80 180])
    
        % Plot all three joint angles
        plot(time, thetas(:,3), '-k','LineWidth', 2)
        plot(data1(:,4),data1(:,3),':k','LineWidth',3);
        plot(data2(:,4),data2(:,3),'--k','LineWidth',2);
        title('Ankle','FontSize',12)
