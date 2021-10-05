%Use this script to generate the doppler shift 
%for the simulink model. Modify fc, fs and T as you please.

addpath('../../utils/channel_utilities/');
addpath('../../utils/qpsk_utilities/');
clear all;

fc = 450e6; %carrier frequency
fs = 1e6/2; %Sampling frequency
T = 10; % in seconds

[t, d] = reduced_time_doppler(fs,fc,T*fs);
t = t + abs(min(t));
doppler = [t', d'];
