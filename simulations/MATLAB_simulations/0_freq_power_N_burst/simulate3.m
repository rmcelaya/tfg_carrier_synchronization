function [variance] = simulate3(EbN0,fc,Rb,plot,save_data,N_burst,N_sim,relative_doppler)
%% Docs
%alpha: parameter of the estimator
%Rb is the bitrate
%N_burst  number of bits in the burst
%N number of repetitions

%Simulation is done symbol by symbol because otherwise too much time is
%taken
addpath('../../'); 
addpath('../../qpsk_utilities');
addpath('../../channel_utilities');
    
%% Data derivations an definitions
N = N_burst;
Rs = Rb/2;
N_s = N/2;

T = 1/Rs;
wc = 2*pi*fc;
N0 = 2;
Eb = N0 * EbN0;
Es = 2*Eb;

estimations = zeros(1,N_sim);
signal_dem_c = zeros(1,N_s-1);

    
sent_data_b = randi([0,1],1,N);

%% Encoding and modulation
sent_data_s = qpsk_encoder(sent_data_b);

sent_data_c = qpsk_modulator(sent_data_s);
sent_signal_c = sqrt(Es)* sent_data_c .* exp(1j*wc*(1:N_s)*T);

%% Channel
w_rel = 2*pi*relative_doppler;
signal_c = sent_signal_c...
          .* exp(1j*w_rel.*(1:N_s)*T)...
          + normrnd(0,sqrt(N0/2),[1,N_s])...
          + normrnd(0,sqrt(N0/2),[1,N_s])*1j;




%% Estimation
s = 0;
c = 0;
freq = zeros(1,N_s);
for k=2:N_s
    signal_dem_c(1,k) = signal_c(1,k) * exp(-1j*wc*k*T);
    s = s + (signal_dem_c(1,k)* signal_dem_c(1,k-1)')^4;
    c = c+1;
end


%% Metrics

average = mean(freq/Rs);
variance = var(freq/Rs,1);


%% Plotting and showing

if plot == true
    fprintf("\n ===== CONDITIONS ======");
    fprintf("\nNumber of transmitted bits per burst = %d\n",N_burst);
    fprintf("\nNumber of simulations (1 burst per simulation) = %d\n",N_sim);
    fprintf("\nCarrier frequency [MHz] = %.2f\n",fc/1e6);
    fprintf("\nDoppler (constant) [Hz] = %.2f\n",relative_doppler);
    fprintf("\nRb = %d\n",Rb);
    fprintf("Eb/N0: %.2f dB \n",10*log10(EbN0));
    fprintf("Es/N0: %.2f dB \n",10*log10(Es/N0));
    fprintf("\n ===== RESULTS ======");
    fprintf("\nMean of the estimation (normalized  to Rs): %f\n",average);
    fprintf("\nVariance of the estimation (normalized to Rs): %f\n",variance);
    
    figure;
    
    
end

%% Saving
if save_data == true
    filename = sprintf("scenario3-%s.mat",datestr(now));
    filename = strrep(filename,' ','_');
    filename = strrep(filename,':','_');
    save(filename,'estimations','variance','average','N_burst','N_sim','fc','Rb','EbN0','relative_doppler');
end

end

