%NO_PFILE
% HIP2

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
% --------------3.5-----------------------------------------------------------
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
clf
clear variables
clear all
format short eng

%euler convolution
figure(1)
dt = 1;
h_euler = [1/dt -1/dt];
load('hip2.mat')
true_euler_fir = conv(true_position, h_euler)*3.6;
noisy_euler_fir = conv(noisy_position, h_euler)*3.6;

%true_euler_fir = [true_euler_fir(60:end)]
%noisy_euler_fir = [noisy_euler_fir(60:end)]
plot(true_euler_fir)
axis([0 500 -300 1000])
hold on
plot(noisy_euler_fir)

ylabel('Km/h')
xlabel('t')
%plot(noisy_eule1r_fir)
%%
% Perform all self-tests of functions in student_sol.m
apply_tests();

% Load student-written functions
funs = student_sols();

% Call your function to get the generated filter coefficients
h = funs.gen_filter();

% Load the reference signals
load hip2.mat

% Here are some sample plots to illustrate the behavior of your filter.
% Feel free to modify, re-use, or completely remove the following lines.

% Plot the filter coefficiencts and magnitude/phase response
figure(1);
stem(h);
axis([0 62 -0.04 0.04])
title('Filter coefficients');

figure(2);
N_fft = 1e3;    %Zero-pad FFT for increased frequency resolution
plot(abs(fft(h, N_fft)));
amp = 0.1*2*pi*100
x1 = [0 0.35]; x2 = [0.35 0]; x3 = [0 0];
y1 = [0 amp]; y2 = [amp 100]; y3 = [100 500];
hold on
%line(y1,x1,'color','red'); line(y2,x2,'color','red'); line(y3,x3,'color','red');
%axis([0 100 0 0.1])

axis([0 500 0 0.4])
title('Filter magnitude response');
xlabel('x*2*pi*100 [Hz]');
ylabel('|H|');
%%
clf
figure(3)
dt = 1;
load('hip2.mat')
true_fir = conv(true_position, h) * 3.6;
noisy_fir = conv(noisy_position, h) * 3.6;
true_fir = [true_fir(30:end)]
noisy_fir = [noisy_fir(30:end)]
plot(true_fir)
hold on
plot(noisy_fir)
ylabel('Km/h')
xlabel('t')
axis([0 550 -50 150])
hold on
%%
figure(3);
plot(unwrap(angle(fft(h, N_fft))));
title('Filter phase response');
xlabel('A frequency unit (which?)');
ylabel('arg(H)');

% Plot the reference signals
figure(4);
plot(noisy_position);
hold on;
plot(true_position);
title('Reference signals');
ylabel('Some unit?');
xlabel('Some unit?');
legend('Noisy position', 'True position');

% Generate a plot of the noise frequency distribution
% We can "cheat" and get the noise by subtracting the true signal from the
%  measured position
n = noisy_position - true_position;
figure(5);
plot(abs(fft(n)).^2);
xlabel('Some frequency unit?');
ylabel('Periodogram of noise');
title('Frequency distribution of noise in measured position');