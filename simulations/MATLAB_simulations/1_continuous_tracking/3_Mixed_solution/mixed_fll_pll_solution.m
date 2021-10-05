
%% Mixed FLL/PLL synchronization
%{
Mixed FLL/PLL carrier synchronization
Characteristics of the simulation
Continuous synchronization simulation (loop synchronization, recursive estimator)
Tracking simulation. We assume an initial lock state
Mixed FLL/PLL solution: FLL for doppler tracking and PLL for residual doppler error and phase tracking
Second order PLL
Second order FLL
Channel effects: AWGN, doppler shift, and phase shift with phase noise

%}

%% Data

clear all;
close all;
clc;

EbN0 = 8; %Eb/N0 in natural units
Rb =  1e6; %Bit rate (twice the sampling/symbol rate)
fc = 450e6; %Carrier frequency
N = 5e5; %Number of sent bits in the simulation


% Channel conditions
phase_offset = 0;

% PLL parameters
gamma_pll = 0.01;
ro_pll = 0.01;

% FLL parameters
gamma_fll = 0.01;
ro_fll = 0.01;
alpha_fll = pi/8;


%% Simulation

tic 

    
% Data derivations an definitions

%Two extra symbols are transparently added and removed to avoid having an
%error on the first symbol (we assume pre vious acquisition)


Rs = Rb/2;
N = N+4;
N_s = N/2;

%[~,frequency_offset] = reduced_time_doppler(Rs,fc,N_s);
%t = linspace(0,N/Rb,N_s);


[t, frequency_offset] = reduced_time_doppler(Rs,fc,N_s);


T = 1/Rs;
wc = 2*pi*fc;
N0 = 2;
Eb = N0 * EbN0;
Es = 2*Eb;
EsN0 = Es/N0;

data_s = zeros(1,N_s);

sent_data_b = randi([0,1],1,N);
    
% Encoding and modulation

sent_data_s = qpsk_encoder(qpsk_diff_precoder(sent_data_b));

sent_data_c = qpsk_modulator(sent_data_s);
sent_signal_c = sqrt(Es)* sent_data_c .* exp(1j*wc*(1:N_s)*T);

% Channel

%AWGN and doppler
w_rel = 2*pi*frequency_offset;
signal_c = sent_signal_c...
          .* exp(1j*((w_rel.*(1:N_s)*T)+phase_offset))...
          + normrnd(0,sqrt(N0/2),[1,N_s])...
          + normrnd(0,sqrt(N0/2),[1,N_s])*1j;


% Receiver

%Initial conditions of the algorithms
current_frequency = frequency_offset(1,1); %Initial frequency of the FLL is the true doppler shift
psi_fll = 0;
err_fll = 0;

current_phase = phase_offset;
psi_pll = 0;
err_pll = 0;

estimated_frequency = zeros(1,N_s);
estimated_phase = zeros(1,N_s);


for k=1:N_s
    
    estimated_frequency(1,k) = current_frequency;
    estimated_phase(1,k) = current_phase;
    
    data_c = signal_c(1,k)*exp(-wc*k*T*1j);
  
    %FLL Detector
    q = data_c .* exp(-1j*(2*pi*k*T*current_frequency));
 
    est = sqrt(Es)*qpsk_modulator(qpsk_detector(q));
    
    
    %FLL error generator
    z_fll = angle(q*est');
    err_prev_fll = err_fll;
    if abs(z_fll) < alpha_fll
        err_fll = z_fll;
    end
    
    %FLL error filtering
    psi_prev_fll = psi_fll;
    psi_fll = psi_prev_fll + gamma_fll* (1+ro_fll) * err_fll - gamma_fll* err_prev_fll;
    
    
    % PLL Detector

    q = q .* exp(-1j*current_phase);
    
    data_s(1,k) = qpsk_detector(q);
    
    est = sqrt(Es)*qpsk_modulator(data_s(1,k));
    
    % PLL detector
    err_prev_pll = err_pll;
    err_pll = imag(q*est');
    
    % PLL error filtering
    psi_prev_pll = psi_pll;
    psi_pll = psi_prev_pll + gamma_pll* (1+ro_pll) * err_pll - gamma_pll* err_prev_pll;
    

    %Updating the oscillator values
    current_frequency = current_frequency+psi_fll;
    current_phase = current_phase+psi_pll;
    
end


%data_c demodulated symbols
%data_s detected symbols from the continuous time values
%data_b decoded binary data from the symbols
toc


% Calculating BER/SER metrics

data_b = qpsk_diff_decoder(qpsk_decoder(data_s));
data_b = data_b(5:end);
sent_data_b = sent_data_b(5:end);
N = N-4;

sent_data_s = sent_data_s(3:end);
data_s = data_s(3:end);

estimated_frequency = estimated_frequency(3:end);
estimated_phase = estimated_phase(3:end);
frequency_offset = frequency_offset(3:end);
N_s = N_s-2;

BE = find(data_b ~= sent_data_b);
SE = find(data_s ~= sent_data_s);

N_be = size(BE,2);
N_se = size(SE,2);

SER = N_se/N_s;
BER = N_be/N;

% Saving the results

filename = sprintf("simulation-%s.mat",datestr(now));
filename = strrep(filename,' ','_');
filename = strrep(filename,':','_');
save(filename,'N','fc','Rb','EbN0','EsN0','Rs','N_s','T','gamma_pll','ro_pll','gamma_fll','ro_fll','alpha_fll',...
    'estimated_frequency','estimated_phase','BE','SE','BER','SER','phase_offset','frequency_offset');



%% Phase error analysis, plotting and showing


true_total_phase = wrapToPi(2*pi*frequency_offset.*(1:N_s)*T + phase_offset*ones(1,N_s));
estimated_total_phase = wrapToPi(2*pi*estimated_frequency.*(1:N_s)*T + estimated_phase);

total_phase_mse = mean((true_total_phase-estimated_total_phase).^2);
total_phase_abs = mean(abs(true_total_phase-estimated_total_phase));


fprintf("\n\n ===== CONDITIONS ======");
fprintf("\nEb/N0: %.2f dB",10*log10(EbN0));
fprintf("\nEs/N0: %.2f dB",10*log10(EsN0));
fprintf("\nNumber of transmitted bits = %d",N);
fprintf("\nNumber of transmitted symbols = %d",N_s);
fprintf("\nCarrier frequency [MHz] = %.2f",fc/1e6);
fprintf("\nRb = %d",Rb);
fprintf("\nRs = %d",Rs);

fprintf("\n\n ===== RESULTS ======");
fprintf("\nSER = %d",SER);
fprintf("\nBER = %d\n\n",BER);


figure(1);
plot(estimated_frequency);
title("Frequency tracking");
xlabel("# of sent symbols");
ylabel("Frequency");
hold on;
grid on;
plot(frequency_offset);
legend("Estimate of the frequency","Real frequency");


figure(2);
plot(estimated_total_phase);
title("Total phase tracking (including frequency)");
xlabel("# of sent symbols");
ylabel("Phase [rad]");
hold on;
grid on;
plot(true_total_phase);
legend("Estimate of the phase","Real phase");
