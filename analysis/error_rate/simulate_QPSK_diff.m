function [SE, BE,SER,BER] = simulate_QPSK_diff(EbN0,N,p_offset,f_offset)
%% Docs
%alpha: parameter of the estimator
%N  number of bits

%Simulation is done symbol by symbol because otherwise too much time is
%taken
%Careful frequency offset with respect to symbol clock
%% Data derivations an definitions

N = N+4;
N_s = N/2;


N0 = 2;
Eb = N0 * EbN0;
Es = 2*Eb;

data_s = zeros(1,N_s);


sent_data_b = randi([0,1],1,N);

%% Encoding and modulation

sent_data_s = qpsk_encoder(qpsk_diff_precoder(sent_data_b));

sent_data_c = qpsk_modulator(sent_data_s);
sent_signal_c = sqrt(Es)* sent_data_c;

%% Channel
sent_signal_c = sent_signal_c .* exp(1j*(2*pi*f_offset*(1:N_s)+p_offset));
signal_c = sent_signal_c...
          + normrnd(0,sqrt(N0/2),[1,N_s])...
          + normrnd(0,sqrt(N0/2),[1,N_s])*1j;



for k=1:N_s
    %% Demodulation and detection
    %Demodulating
    %Pre demodulation
    data_c = signal_c(1,k);
    data_s(1,k) = qpsk_detector(data_c);
end

%data_c demodulated symbols
%data_s detected symbols from the continuous time values
%data_b decoded binary data from the symbols

%% Metrics

data_b = qpsk_diff_decoder(qpsk_decoder(data_s));
data_b = data_b(5:end);
data_s = data_s(3:end);
sent_data_s = sent_data_s(3:end);
sent_data_b = sent_data_b(5:end);
N = N-4;

N_s = N_s-2;
BE = find(data_b ~= sent_data_b);

SE = [];
for k=1:size(BE,2)
    SE = [SE, ceil(BE(k)/2)];    
end

SE = unique(SE);

N_be = size(BE,2);
N_se = size(SE,2);

SER = N_se/N_s;
BER = N_be/N;



end
