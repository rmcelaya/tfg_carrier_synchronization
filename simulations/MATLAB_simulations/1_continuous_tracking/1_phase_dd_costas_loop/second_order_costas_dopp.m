function [SER,BER] = second_order_costas_dopp(EbN0,fc,Rb,plotear,save_data,N,doppler,offset_phase,variation,initial_phase,gamma,ro)
%% Docs
%alpha: parameter of the estimator
%Rb is the bitrate
%N  number of bits

%Simulation is done symbol by symbol because otherwise too much time is
%taken
addpath('../../'); 
addpath('../../qpsk_utilities');
addpath('../../channel_utilities');
    
%% Data derivations an definitions

Rs = Rb/2;
N = N+4;
N_s = N/2;

t = linspace(0,N/Rb,N_s);
relative_doppler = doppler+variation.*t;

T = 1/Rs;
wc = 2*pi*fc;
N0 = 2;
Eb = N0 * EbN0;
Es = 2*Eb;

data_s = zeros(1,N_s);




sent_data_b = randi([0,1],1,N);
    
%% Encoding and modulation

sent_data_s = qpsk_encoder(qpsk_diff_precoder(sent_data_b));

sent_data_c = qpsk_modulator(sent_data_s);
sent_signal_c = sqrt(Es)* sent_data_c .* exp(1j*wc*(1:N_s)*T);

%% Channel

w_rel = 2*pi*relative_doppler;
signal_c = sent_signal_c...
          .* exp(1j*(w_rel.*(1:N_s)*T+offset_phase))...
          + normrnd(0,sqrt(N0/2),[1,N_s])...
          + normrnd(0,sqrt(N0/2),[1,N_s])*1j;

current_phase= initial_phase;
phase_o = zeros(1,N_s);
%data_c = signal_c(1,1)*exp(-wc*1*T*1j);

err = 0;
psi = 0;
for k=1:N_s
    %% Demodulation and detection
    %Demodulating
    %Pre demodulation
    data_c = signal_c(1,k)*exp(-wc*k*T*1j);

    phase_o(1,k) = current_phase; 
    %Detector
    q = data_c .* exp(-1j* current_phase);
    
    data_s(1,k) = qpsk_detector(q);
    
    est = sqrt(Es)*qpsk_modulator(data_s(1,k));
    
    %%Error generator
    err_prev = err;
    err = imag(q * est');
    
    %Error filtering
    
    psi_prev = psi;
    psi = psi_prev + gamma* (1+ro) * err - gamma* err_prev;

    %Updating oscillator
    current_phase = current_phase+psi;
    

end

%data_c demodulated symbols
%data_s detected symbols from the continuous time values
%data_b decoded binary data from the symbols

%% Metrics

data_b = qpsk_diff_decoder(qpsk_decoder(data_s));
data_b = data_b(5:end);
sent_data_b = sent_data_b(5:end);
N = N-4;
sent_data_s = sent_data_s(3:end);
data_s = data_s(3:end);
N_s = N_s-2;
BE = find(data_b ~= sent_data_b);
SE = find(data_s ~= sent_data_s);

N_be = size(BE,2);
N_se = size(SE,2);

SER = N_se/N_s;
BER = N_be/N;



%% Plotting and showing

if plotear == true
    fprintf("\n\n ===== RESULTS ======");
    fprintf("\nNumber of transmitted bits = %d\n",N);
    fprintf("\nCarrier frequency [MHz] = %.2f\n",fc/1e6);
    fprintf("\nDoppler (at t = 0) [Hz] = %.2f\n",doppler);
    fprintf("\nLinear Doppler variation");
    fprintf("\nDoppler variation rate [Hz] = %.2f\n",variation);
    fprintf("\nRb = %d\n",Rb);
    fprintf("Eb/N0: %.2f dB \n",10*log10(EbN0));
    fprintf("Es/N0: %.2f dB \n",10*log10(Es/N0));
    fprintf("SER = %d\n",SER);
    fprintf("BER = %d\n",BER);
    figure;
    plot((phase_o));
    title("Frequency estimate over time");
    xlabel("# of sent symbols");
    ylabel("Phase");
    hold on;
    grid on;
    plot((2*pi*relative_doppler.*(1:(N_s+2))*T)+offset_phase);
    legend("Estimate of the frequency","True doppler shift");
end

%% Saving
if save_data == true
    filename = sprintf("scenario2-%s.mat",datestr(now));
    filename = strrep(filename,' ','_');
    filename = strrep(filename,':','_');
    save(filename,'BE','SE','BER','SER','N','fc','Rb','EbN0','doppler','variation');
end

end

