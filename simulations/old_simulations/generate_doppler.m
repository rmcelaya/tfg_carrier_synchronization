
clear all;
fc = 450e6;
fs = 1e6/2;
T = 10; % in seconds

[t, d] = reduced_time_doppler(fs,fc,T*fs);
t = t + abs(min(t));
doppler = [t', d'];
