%NO_PFILE
function [funs, student_id] = student_sols()
%STUDENT_SOLS Contains all student solutions to problems.

% ----------------------------------------
%               STEP 1
% ----------------------------------------
% Set to your birthdate / the birthdate of one member in the group.
% Should a numeric value of format YYYYMMDD, e.g.
% student_id = 19900101;
% This value must be correct in order to generate a valid secret key.
student_id = 19940803;


% ----------------------------------------
%               STEP 2
% ----------------------------------------
% Your task is to implement the following skeleton functions.
% You are free to use any of the utility functions located in the same
% directory as this file as well as any of the standard matlab functions.
dt = 1;
fs = 1/dt;
  function h = gen_filter()
       f = [0 0.05 0.1 fs/2]/(fs/2) %freq vec
       a = [0 1 0 0] .*f*2*pi*(fs/2)%amplitude vec
       n = 60; %order 60 because 61 coefficients(order N if there are N+1 coefficients)
       h = firpm(n, f, a, 'differentiator');
   end

funs.gen_filter = @gen_filter;


% This file will return a structure with handles to the functions you have
% implemented. You can call them if you wish, for example:
% funs = student_sols();
% some_output = funs.some_function(some_input);

end

