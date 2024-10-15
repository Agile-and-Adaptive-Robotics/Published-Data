clear;close all;
%% Define Mechanical Properties 
% Define the mechanical properties of link 1.
M1 = .716;  %[lb] Mass of femur with encoder                   
R1 = 4.75; % [in]
I1 = 496.26; %[in^4]
L1 = 9.25; %[in]

% Define the mechanical properties of link 2.
M2 = .4299; %[lb]
R2 = 4.75; %[in]
I2 = 496.26; %[in^4]
L2 = 9.25; %[in
% Define the mechanical properties of link 3.

M3 = 0.010992; %[lb]
R3 = 3.5; %[in]
I3 = 122.09; %[in^4]
L3 = 7.875;
g = 9.81;

M4 = M2+M3;
R4 = (M2*R2 + M3*R3)/(M4);
L4 = L3 + L2;
I4 = I2 + I3;

P = [M1,R1,I1,L1,M4,R4,I4,L4,g];

%Stores Joint Parameters in a vector
%U = [b1,b2,b3,K1,K2,K3,theta1bias,theta2bias,theta3bias];
U = [-4.277196376451152e+02,2.927567999697626e+02,-3.340120808690405e+03,-3.644839905916694,1.596381503496003,2.133055049954218];
%% Model
dwrite = 0.00046;
dt = dwrite*4;
init_t=0;
N = 4000;
final_t= N*dt;
t_span=linspace(init_t,final_t,N);
x0=[0 0 0 0]';

[t,x] = ode45(@(t,x) Dynamic_code2(t,x,P,U),t_span,x0);%simulated leg motion wiht input
[a] = ProcessMuscleMutt();%Loads processed MuscleMutt Data

figure
plot(t,x(:,1),'r-',t,a(:,1),'b-');
title('Hip rotation');
xlabel('time (s)');
ylabel('radians');
legend('Optimized Model', 'Muscle Mutt Data');

figure
plot(t,x(:,3),'r-',t,a(:,2),'b-');
title('Knee rotation');
xlabel('time (s)');
ylabel('radians');
legend('Optimized Model', 'Muscle Mutt Data');


