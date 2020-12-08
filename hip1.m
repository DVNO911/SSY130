f0 =8000; fs = 30000;
k = -3
dt = 1/fs;
w1 = (1/2j)*exp(-j*pi*((f0+fs*k)/(fs)))*(sin(pi*((f0+fs*k)/(fs)))/(pi*((f0+fs*k)/(fs))))
abs(w1)*2