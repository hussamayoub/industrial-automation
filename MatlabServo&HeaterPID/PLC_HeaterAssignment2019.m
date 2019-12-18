% ===================================
% PLC Assignments Tuning the Heater
% ===================================
% IA-CS4   O.E. Figaroa
clear vars
close all
%num = 20;          % numerator
%den = [0.5 1 0];   % denumerator
% 
 num = 5;             % numerator
 den = [256 100 5];   % denumerator

Ts= 0.01;            % sample time 10 ms
Gc=tf(num,den)       % Continuous transfer function of process
format long
% discretize the process with Ts 
Gd = c2d(Gc,Ts);      % Discrete Transfer function ZOH 
%
% Preparing a Discrete PID with trapezodial I and BackwardEuler D
C01 = pid(1,1,1,'Ts',Ts,'IFormula','Trapezoidal','DFormula','BackwardEuler'); 
% Preparing a Discrte PID with Backward Euler I and BackwardEuler D
C02 = pid(1,1,1,'Ts',Ts,'IFormula','BackwardEuler','DFormula','BackwardEuler');
% Preparing a Discrte PID with Forward Euler I and ForwardEuler D
C03 = pid(1,1,1,'Ts',Ts,'IFormula','ForwardEuler','DFormula','ForwardEuler'); % ZOH ; 

%
figure(),clf;
step(Gc)       %
title('Step response Heater.  s-domain');
legend('Open loop response');
ylabel ('Temperature [Celsius]');
grid on
figure(), clf;
step(Gd)       %
title('Step response Heater. z-domain');
ylabel ('Temperature [Celsius]');
grid on
% Following values can be plugged in in simulink or 
% in TwinCAT 3 functionblock:  FB_CTRL_TRANSFERFUNCTION_1
[numz1,denz1] = tfdata(Gd,'v'); 
hold on

%tf(numz1,denz1)
Contr1 = pidtune(Gd,C01);
Contr2 = pidtune(Gd,C02);
Contr3 = pidtune(Gd,C03);

% Responses of the obtained PID;
step(feedback(Contr1*Gd,1),0.5);
step(feedback(Contr2*Gd,1),0.5);
step(feedback(Contr3*Gd,1),0.5);

legend('Open -loop ','Trapez:I and BW-Euler: D PID.','BW-Euler: I and D PID.',' FW-Euler: I and D PID.');
ylabel ('Temperature [Celsius]');
% Display the PID controllers
Contr1
ContrStd1 = pidstd(Contr1)
display('---------------------- ');
Contr2
ContrStd2 = pidstd(Contr2)  
display('----------------------- ');
Contr3
ContrStd3 = pidstd(Contr3)  


