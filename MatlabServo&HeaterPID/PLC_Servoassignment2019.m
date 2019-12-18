% ===================================
% PLC Assignments Tuning the Servo
% ===================================
% IA-CS4   O.E. Figaroa
clear vars
close all
num = 20;            % numerator
den = [0.5 1 0];     % denumerator
% 
Ts= 0.01;            % sample time
Gc=tf(num,den)       % Continuous transfer function of process
format long
% discretize the process with Ts as sampling time
%
Gd = c2d(Gc,Ts)      % Discrete Transfer function ZOH 
% Gd = c2d(Gc,Ts,'tustin')  %
% Gd = c2d(Gc,Ts,'least-squares') %
% Preparing a Discrete PID with trapezodial I and BackwardEuler D
C01 = pid(1,1,1,'Ts',Ts,'IFormula','Trapezoidal','DFormula','BackwardEuler'); 
% Preparing a Discrete PID with Backward Euler I and BackwardEuler D
C02 = pid(1,1,1,'Ts',Ts,'IFormula','BackwardEuler','DFormula','BackwardEuler'); 
C03 = pid(1,1,1,'Ts',Ts,'IFormula','ForwardEuler','DFormula','ForwardEuler'); % ZOH ; 
%
figure(),clf;
step(Gc,1)       % Open loop response
title('Step response Servo. s-domain');
legend('Open loop response');
grid on
ylabel ('Position \theta [rad]')
figure(), clf;
step(Gd,1)       %
title('Step response Servo. z-domain');
grid on
ylabel ('Position \theta [rad]')
% Following values numz1 and denz1 can be plugged-in in simulink or 
% in TwinCAT 3 functionblock:  FB_CTRL_TRANSFERFUNCTION_1
[numz1,denz1] = tfdata(Gd,'v')  
figure(), clf;
%tf(numz1,denz1)
Contr1 = pidtune(Gd,C01);
Contr2 = pidtune(Gd,C02);
Contr3 = pidtune(Gd,C03);
%figure(), clf;
step(feedback(Gd*Contr1.Kp,1));     % P- Control K=0.5
hold on
step(feedback(Contr1*Gd,1));  %
step(feedback(Contr2*Gd,1));  %
step(feedback(Contr3*Gd,1));  %
grid on
%legend('P-Control Kp = 0.5','PID Control'); %Trapez-I and BWEuler-D PID.','BWEuler-I and D PID.',' ZOH PID');

legend(['P-Control Kp = ',num2str(Contr1.Kp)],'Trapez-I and BW-Euler-D PID.','BW-Euler-I and D PID.',' FW-Euler-I and D PID.');
title(' Servo Position Control response.');
ylabel ('Position \theta [rad]');
display('------------------------------------------------------- ');
% Contr1.IFormula
% Contr1.DFormula
Contr1
ContrStd1 = pidstd(Contr1)
display('--------------------------------------------------------- ');
% Contr2.IFormula
% Contr2.DFormula
Contr2
ContrStd2 = pidstd(Contr2)  
display('--------------------------------------------------------- ');
% Contr3.IFormula
% Contr3.DFormula
Contr3
ContrStd3 = pidstd(Contr3)  


