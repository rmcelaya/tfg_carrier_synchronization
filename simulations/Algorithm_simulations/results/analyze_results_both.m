for k=1:size(results,2)

    EbNo(1,k) = results(1,k).EbNo;
    freq_mse(1,k) = mean( (results(1,k).doppler_real - results(1,k).doppler_estimado).^2);
    freq_mae(1,k) = mean( abs(results(1,k).doppler_real - results(1,k).doppler_estimado));
    overall_ber(1,k) = results(1,k).ber(end,1);
end

for k=1:size(results,2)
    freq_mse_2(1,k) = mean( (results_2(1,k).doppler_real - results_2(1,k).doppler_estimado).^2);
    freq_mae_2(1,k) = mean( abs(results_2(1,k).doppler_real - results_2(1,k).doppler_estimado));
    overall_ber_2(1,k) = results_2(1,k).ber(end,1);
end


% Theoretical ber
N= 10000;
EbN0_dB = linspace(min(EbNo),max(EbNo),N);
EbN0 = 10.^(EbN0_dB/10);
ber_theo = zeros(1,N);

%We assume BER is SER/2
for k=1:N
    a = qfunc(sqrt(2*EbN0(1,k)));
    ber_theo(1,k)=(2*a-a^2)/2;
end
ber_theo_diff = ber_theo*2;

figure;
semilogy(EbN0_dB,ber_theo);
hold on;
semilogy(EbN0_dB,ber_theo_diff);
semilogy(EbNo,overall_ber,'*-');
semilogy(EbNo,overall_ber_2,'*-');
xlabel("Eb/N0 [dB]");
ylabel("BER");
legend("QPSK theoretical","QPSK differential theoretical","Solution","Improved solution");
grid on;
figure;

EbNo_alt = EbNo;
EbNo_alt(1) = [];
freq_mse_2(1) = [];
semilogy(EbNo,freq_mse,'*-');
hold on;
semilogy(EbNo_alt,freq_mse_2,'*-');
title("MSE of the frequency estimation");
xlabel("Eb/N0 [dB]");
ylabel("MSE");
legend("Solution","Improved solution");
grid on;

freq_mae_2(1) = [];
figure;
semilogy(EbNo,freq_mae,'*-');
hold on;
semilogy(EbNo_alt,freq_mae_2,'*-');
xlabel("Eb/N0 [dB]");
ylabel("MAE");
grid on;
legend("Solution","Improved solution");
title("MAE of the frequency estimation");