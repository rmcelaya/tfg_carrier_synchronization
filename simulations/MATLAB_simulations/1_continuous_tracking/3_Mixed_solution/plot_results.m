%% Phase error analysis, plotting and showing
close all;


true_total_phase = wrapTo2Pi(2*pi*frequency_offset.*(1:N_s)*T + phase_offset*ones(1,N_s));
estimated_total_phase = wrapTo2Pi(2*pi*estimated_frequency.*(1:N_s)*T + estimated_phase);


% Be careful, SER is not real (does not take into account the effect of
% differential precoding). We will take it into account.
SE = [];
for k=1:size(BE,2)
    SE = [SE, ceil(BE(k)/2)];    
end

%Asumimos que está enganchado 
for k=1:size(estimated_total_phase,2)
    e = true_total_phase(1,k)-estimated_total_phase(1,k);
    if abs(e) > (pi/4)
        d = fix(e/(pi/4));
        true_total_phase(1,k) = true_total_phase(1,k) - d*(pi/4);
        assert(abs(true_total_phase(1,k)-estimated_total_phase(1,k)) < (pi/4));
    end
             
end



error_distrib = (wrapToPi(true_total_phase-estimated_total_phase)*360)/(2*pi);
figure;
histogram(error_distrib);

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


figure;
plot(estimated_frequency);
title("Frequency tracking");
xlabel("# of sent symbols");
ylabel("Frequency");
hold on;
grid on;
plot(frequency_offset);
legend("Estimate of the frequency","Real frequency");


figure;
plot(estimated_total_phase);
title("Total phase tracking (including frequency)");
xlabel("# of sent symbols");
ylabel("Phase [rad]");
hold on;
grid on;
plot(true_total_phase);
legend("Estimate of the phase","Real phase");
