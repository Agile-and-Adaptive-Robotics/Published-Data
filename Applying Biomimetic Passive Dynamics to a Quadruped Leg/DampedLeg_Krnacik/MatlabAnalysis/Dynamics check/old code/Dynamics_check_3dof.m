%% EOM dynamics check

% This is a script intended to verify the dynamics of a three link pendulum
% for the rat leg model, with the derived equations of motion. Parameters U
% can be varied and are not optimized to match the rat data.

clear, close('all'), clc

%% Define Mechanical Properties of Rat

% Define the mechanical properties of link 1.
M1 = 0.001 * 13.26;                 % [kg]                 
R1 = 0.01 * 1.305;                  % [m]
L1 = 0.01 * 2.9;                    % [m]

% Define the mechanical properties of link 2.
M2 = 0.001 * 9.06;                  % [kg]
R2 = 0.01 * 1.558;                  % [m]
L2 = 0.01 * 4.1;                    % [m]

% Define the mechanical properties of link 3.
M3 = 0.001 * 1.7;                   % [kg]
R3 = 0.01 * 1.6;                    % [m]
L3 = 0.01 * 3.3;                    % [m]

g = 9.81;                           % [m/s^2]

P = [M1,R1,L1,M2,R2,L2,M3,R3,L3,g];

 
%% Run simulation

% Create a time array to test with
 time = 0:0.001:2;
 
% Describe initial conditions
theta1_i = deg2rad(60);
theta2_i = deg2rad(180);
theta3_i = deg2rad(180);
dtheta1_i = 0;
dtheta2_i = 0;
dtheta3_i = 0;
x0=[theta1_i dtheta1_i theta2_i dtheta2_i theta3_i dtheta3_i]';

% Describe dynamic parameters
b1 = 0; 
b2 = 0;
b3 = 0;
K1 = 0;
K2 = 0;
K3 = 0;
u1 = 0;
u2 = 0;
u3 = 0;
U = [b1 b2 b3 K1 K2 K3 u1 u2 u3];

% Get the system of equations
syms u1 u2 u3 u4 u5 u6
[fx1, fx2, fx3] = Symb_3DOF_solver();

% Run the simulation
[t,x] = ode15s(@(t,x) Dynamic_code_Rat_complex_3dof(t,x,P,U, fx1, fx2, fx3),time,x0);


%% Animation

% Create a figure to store the animation.
fig_animation = figure('Color', 'w', 'Name', 'Robot Animation'); hold on, view(180, 90), xlabel('x'), ylabel('y')                                    
axis equal
xlim([-0.15 0.15])
ylim([-0.15 0.15])



% Define theta values
theta1 = x(:,1);
theta2 = x(:,3);
theta3 = x(:,5);

% Now define center of masses in x-y coordinates
m1(:,1) = R1 * cos(pi - theta1);
m1(:,2) = R1 * sin(pi - theta1);
m2(:,1) = L1 * cos(pi - theta1) + R2 * cos(-(theta1 + theta2));
m2(:,2) = L1 * sin(pi - theta1) + R2 * sin(-(theta1 + theta2));
m3(:,1) = L1 * cos(pi - theta1) + L2 * cos(-(theta1 + theta2)) + R3 * cos(theta3 - (theta1 + theta2) + pi);
m3(:,2) = L1 * sin(pi - theta1) + L2 * sin(-(theta1 + theta2)) + R3 * sin(theta3 - (theta1 + theta2) + pi);

% Define joint locations for plotting uses
knee = (m1/R1)*L1;
ankle(:,1) = L1 * cos(pi - theta1) + L2 * cos(-(theta1 + theta2));
ankle(:,2) = L1 * sin(pi - theta1) + L2 * sin(-(theta1 + theta2));
toe(:,1) = L1 * cos(pi - theta1) + L2 * cos(-(theta1 + theta2)) + L3 * cos(theta3 - (theta1 + theta2) + pi);
toe(:,2) = L1 * sin(pi - theta1) + L2 * sin(-(theta1 + theta2)) + L3 * sin(theta3 - (theta1 + theta2 + pi));



% Create a graphics object for the knee
hip = zeros(length(t), 2);
hip_plot = plot(0, 0, '.r', 'Markersize', 20, 'XDataSource', 'hip(k,1)', 'YDataSource', 'hip(k,2)');

% Create a graphics object for the knee
knee_plot = plot(0, 0, '.r', 'Markersize', 20, 'XDataSource', 'knee(k,1)', 'YDataSource', 'knee(k,2)');

% Create a graphics object for the ankle
ankle_plot = plot(0, 0, '.r', 'Markersize', 20, 'XDataSource', 'ankle(k,1)', 'YDataSource', 'ankle(k,2)');

% Create a graphics object for the toe
toe_plot = plot(0, 0, '.r', 'Markersize', 20, 'XDataSource', 'toe(k,1)', 'YDataSource', 'toe(k,2)');



% Set the number of animation playbacks.
num_playbacks = 1;

% Retrieve the number of time steps.
num_timesteps = length(t);

% % Initialize a video object.
myVideo = VideoWriter('RobotAnimation'); %open video file
myVideo.FrameRate = 10;  %can adjust this, 5 - 10 works well for me
open(myVideo)


% Animate the figure.
for j = 1:num_playbacks                     % Iterate through each play back    
    for k = 1:10:num_timesteps               % Iterate through each of the angles
        
        % Note: I've been defining num_timesteps such that the total time
        % to play is approximately equivalent to the time span designated.
        % This has been done manually.
        
        % Refresh the plot data.
        refreshdata([knee_plot; ankle_plot; toe_plot], 'caller')
        
        % Update the plot.
        drawnow
        
        % Write the current frame to the file.
         writeVideo(myVideo, getframe(gcf));


    end
end

% % Close the video object.
close(myVideo)


%% 1-link pendulum check
% Check to see if 3L pendulum with knee and ankle locked out has same
% period as expected for a 1L pendulum
m_tot = M1 + M2 + M3;
r_tot = (M1/m_tot)*R1 + (M2/m_tot)*(L1 + R2) + (M3/m_tot)*(L1 + L2 + R3);
I_tot = (1/3) * m_tot* (2*r_tot)^2;
T_expected = 2 * pi * sqrt(I_tot/(m_tot*g*r_tot));
fprintf('\nExpected period:\n')
disp(T_expected)

% Plot joint angle of first and second joint
figure
plot(t,x(:,1))
figure
plot(t,x(:,3))

% Display period of first joint
[pks, loc] = findpeaks(x(:,1),t);
loc
Calc_period = mean(diff(loc))





