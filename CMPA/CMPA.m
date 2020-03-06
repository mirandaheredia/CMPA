% Miranda Heredia
% PA #9
% Compact Models
% March 6th, 2020
clear 
clc
close all
%Question 1 - Generating some data

% Known variables for extraction

Is = 0.01e-12;      % Forward Bias Saturation Current
Ib = 0.1e-12;       % Breakdown Saturation Current
Vb = 1.3;           % Breakdown Voltage
Gp = 0.1;           % Parastic Parallel Conductance

% Vectors

VolVec = linspace(-1.95, 0.7, 200);
IVec = (Is*(exp(1.2*VolVec/0.025)-1)) + (Gp*VolVec) - (Ib*(exp(-1.2*(VolVec+Vb)/0.025)-1));

noise  = 0.8 + (0.4).*rand(size(IVec));

I_noise = IVec.*noise;

figure(1)
subplot(2,1,1)
plot(VolVec, IVec, VolVec, I_noise);
title('Current with and Without Noise');
legend('Actual', 'Noise');
xlabel('Voltage (V)')
ylabel('Current (A)')
subplot(2,1,2)
semilogy(VolVec, abs(IVec), VolVec, abs(I_noise));
legend('Actual', 'Noise');
xlabel('Voltage (V)')
ylabel('Current (A)')
title('Current with and Without Noise');

%Question 2 - Polynomial Fitting

%4th and 8th order polynomial fit for ideal Current

P_4 = polyfit(VolVec, IVec, 4);
P_8 = polyfit(VolVec, IVec, 8);

P4Val = polyval(P_4, VolVec);
P8Val = polyval(P_8, VolVec);

% 4th and 8th order polynomial fit for noisy current

P_4N = polyfit(VolVec, I_noise, 4);
P_8N = polyfit(VolVec, I_noise, 8);

P4NVal = polyval(P_4N, VolVec);
P8NVal = polyval(P_8N, VolVec);

%Adding to plot

figure(2)
subplot(2,2,1)
%4th order no noise
plot(VolVec, IVec,'r', VolVec, P4Val,'b');
title('Current and 4th order polynomoal - no noise');
legend('Actual', ' 4th Polyfit');
xlabel('Voltage (V)')
ylabel('Current (A)')

% 8th order no noise
subplot(2,2,2)
plot(VolVec, IVec,'r', VolVec, P8Val,'b');
title('Current and 8th order polynomoal - no noise');
legend('Actual', ' 8th Polyfit');
xlabel('Voltage (V)')
ylabel('Current (A)')

%4th order with noise
subplot(2,2,3)
plot(VolVec, IVec,'r', VolVec, P4NVal,'b');
title('Current and 4th order polynomoal - with noise');
legend('Actual', ' 4th Polyfit');
legend('Actual', 'Noise');
xlabel('Voltage (V)')
ylabel('Current (A)')

% 8th order no noise
subplot(2,2,4)
plot(VolVec, IVec,'r', VolVec, P8NVal,'b');
title('Current and 8th order polynomoal - with noise');
legend('Actual', ' 8th Polyfit');
xlabel('Voltage (V)')
ylabel('Current (A)')

% Question 3 - Nonlinear Curve Fitting to Physical Model

%Part 3A
B = Gp;
D = Vb;
fo = fittype(@(A,B,C,D,x) (A.*exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1));
%no noise
ff1 = fit(VolVec', IVec', fo);
I_f1 = ff1(VolVec);
%with noise
ff1N = fit(VolVec', I_noise',fo);
I_f1N = ff1N(VolVec);

figure(3)
subplot(2,3,1)
plot(VolVec, I_f1)
title('Fitted Current (B, D)');
xlabel('Voltage (V)'); 
ylabel('Current (A)');

% subplot(2,3,2)
% plot(VolVec, I_f1N)
% title('Fitted Noisy Current (B, D)');
% xlabel('Voltage (V)');
% ylabel('Current (A)');

% Part 3B

A = Is;
C = Ib;
fo = fittype(@(A,B,C,D,x) (A.*exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1));
ff12 = fit(VolVec', IVec', fo);
If12 = ff12(VolVec);
ff22 = fit(VolVec', IVec', fo);
If22 = ff22(VolVec);

subplot(2,3,3)
plot(VolVec, If12)
title('Fitted Current (A, C)');
xlabel('Voltage (V)'); 
ylabel('Current (A)');

% subplot(2,3,4)
% plot(VolVec, If22)
% title('Fitted Noisy Current (A, C)');
% xlabel('Voltage (V)'); 
% ylabel('Current (A)');

%Part 3c - fitting all
fo = fittype(@(A,B,C,D,x) (A.*exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1));
ff13 = fit(VolVec', IVec', fo);
If13 = ff13(VolVec);
ff23 = fit(VolVec', I_noise', fo);
If23 = ff23(VolVec);

subplot(2,3,5)
plot(VolVec, If13);
title('Fitted Current');
xlabel('Voltage (V)'); ylabel('Current (mA)');
grid on;

% subplot(2,3,6)
% plot(VolVec, If23);
% title('Fitted Noisy Current');
% xlabel('Voltage (V)'); ylabel('Current (mA)');
% grid on;

%Question 4

inputs = VolVec.';
targets = IVec.';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs)
view(net)
Inn = outputs;
figure(4)
semilogy(VolVec, I_noise, VolVec, outputs');
legend('Current', 'Net');














    