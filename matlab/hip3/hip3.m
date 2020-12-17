%NO_PFILE
% HIP3

% Perform the following steps:
%   1) In student_sols.m, update the student_id variable as described
%   there.
%
%   2) In student_sols.m, complete all the partially-complete functions.
%   (Indicated by a '%TODO: ...' comment). Note that all the functions you
%   need to complete are located in student_sols.m (and only in
%   student_sols.m). You can test these functions by running this file,
%   which will apply a self-test to your functions. When all functions pass
%   the self-test, a unique password will be printed in the terminal. Be
%   sure to include this password in your submission.
%
%   3) Now that the functions in student_sols.m are completed, continue
%   working with this file. Notably, your finished functions will be used
%   to evaluate the behavior of the assignment.
%
% -------------------------------------------------------------------------
%                    Note on function handles
% -------------------------------------------------------------------------
% In this file, we will make use of function handles. A function handle is
% a variable that refers to a function. For example:
%
% x = @plot
%
% assigns a handle to the plot function to the variable x. This allows to
% for example do something like
%
% x(sin(linspace(0,2*pi)))
%
% to call the plot function. Usefully for you, there exist function handles
% to all the functions you've written in student_sols.m. See below for
% exactly how to call them in this assignment.
%
% -------------------------------------------------------------------------
%                    Final notes
% -------------------------------------------------------------------------
%
% The apply_tests() function will set the random-number generator to a
% fixed seed (based on the student_id parameter). This means that repeated
% calls to functions that use randomness will return identical values. This
% is in fact a "good thing" as it means your code is repeatable. If you
% want to perform multiple tests you will need to call your functions
% several times after the apply_tests() function rather than re-running
% this entire file.
%
% Note on debugging: if you wish to debug your solution (e.g. using a
% breakpoint in student_sols.m), comment out the line where the apply_tests
% function is called in the hand-in/project script. If you do not do this
% then you'll end up debugging your function when it is called during the
% self-test routine, which is probably not what you want. (Among other
% things, you won't be able to control the input to your functions).
%
% Files with a .p extension are intentionally obfusticated (they cannot
% easily be read). These files contain the solutions to the tasks you are
% to solve (and are used in order to self-test your code). Though it is
% theoretically possible to break into them and extract the solutions,
% doing this will take you *much* longer than just solving the posed tasks
% =)

% Do some cleanup
clc
clear variables
format short eng

% Perform all self-tests of functions in student_sol.m
apply_tests();

% Load student-written functions
funs = student_sols();

% Set up ground-truth motion
x = 0:0.01:9.99;
y = sin(0.5*x);
Y = [x;y];
Z = Y + 0.1*randn(size(Y));

% Plot input motion
figure(1);
plot(Y(1,:), Y(2,:));
xlabel('x');
ylabel('y');
title('Noise-free position');

figure(2);
scatter(Z(1,:), Z(2,:));
xlabel('x');
ylabel('y');
title('Measured position');

%% Task 1
T = 0.01;       % Sampling time

x_dot = zeros(size(x));
y_dot = zeros(size(y));
x_dot(1) = 0;
y_dot(1) = 0;

for k  =2:length(x)-1
    x_dot(k) = (x(k+1)-x(k))/T;
    y_dot(k) = (y(k+1)-y(k))/T; 
end

s = [x; x_dot; y; y_dot];

s_dot = [s(2); 0; s(4); 0];

% Matrices
A = [0 1 0 0;
        0 0 0 0;
        0 0 0 1;
        0 0 0 0];
C_pos = [1 0 0 0;
                0 0 1 0];

Ad = expm(A*T);

%% Task 2, set up coordinates and plot
% Saw later that this was already done

% x = 0:0.01:9.99; 
% y = sin(0.5*x);
% Y = [x;y]; 
% Z = Y + 0.1*randn(size(Y));
% 
% figure(1)
% plot(Y(1,:),Y(2,:),'x'); 
% figure(2)
% plot(Z(1,:),Z(2,:),'x')

%% Task 3, see student_sols.m

%% Task 4
% Set up A, C, Q, R, x0, P0 here
A = Ad;
C = C_pos;
Y_dot = [x_dot; y_dot];
Z_dot = Y_dot + 0.1*randn(size(Y_dot));

error = eye(2)*(Z-Y);
error_dot = eye(2)*(Z_dot-Y_dot);

probDistX = fitdist(error(1,:)', 'Normal');
probDistY = fitdist(error(2,:)', 'Normal');

probDistXdot = fitdist(error_dot(1,:)', 'Normal');
probDistYdot = fitdist(error_dot(2,:)', 'Normal');

% Q-matrix. Covariances for velocities.
q = 1*10^-4;
Q = [0 0 0 0;
        0 probDistXdot.sigma 0 0;
        0 0 0 0
        0 0 0 probDistXdot.sigma] * q;
    
% R-matrix. Covariances for positions.
r = 1;%10^4;%10^2;
R = [probDistX.sigma, 0; 0, probDistY.sigma]*r;

% Initialized x0 and P0 as described in task.
x0 = zeros(length(A),1);
P0 = 10^6*eye(length(A));

% Call your fancy kalman filter using the syntax
[Xfilt, Pp] = funs.kalm_filt(Z,A,C,Q,R,x0,P0);

% Plots
close all
figure(1)
plot(Xfilt(1,:),Xfilt(3,:), 'LineWidth', 2)
hold on
plot(x,y, 'LineWidth', 2)
xlabel('x')
ylabel('y')
legend('Kalman estimation of trajectory', 'True trajectory')
title('Estimated object trajectory vs. true trajectory')

% Velocity plots
k = (0:length(Z)-1)/T;      % Defining the time steps of sampling freq. T.

figure(2)
plot(k, Xfilt(2,:), 'LineWidth', 2)
hold on
plot(k, x_dot, 'LineWidth', 2)
xlabel('Time [s]')
ylabel('Velocity')
legend('Kalman est.', 'True velocity')
title('Kalman estimation velocity in x-direction')
axis([0 10*10^4 -0.5 1.5])

figure(3)
plot(k ,Xfilt(4,:), 'LineWidth', 2)
hold on
plot(k ,y_dot, 'LineWidth', 2)
xlabel('Time [s]')
ylabel('Velocity')
legend('Kalman est.', 'True velocity')
title('Kalman estimation velocity in y-direction')
axis([0 10*10^4 -2 2])
