for k=1:size(results,2)

    EbNo(1,k) = results(1,k).EbNo;
    freq_mse(1,k) = mean( (results(1,k).doppler_real - results(1,k).doppler_estimado).^2);
    freq_mae(1,k) = mean( abs(results(1,k).doppler_real - results(1,k).doppler_estimado));
    overall_ber(1,k) = results(1,k).ber(end,1);
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
xlabel("Eb/N0 [dB]");
ylabel("BER");
legend("QPSK theoretical","QPSK differential theoretical","Solution");
grid on;
figure;

semilogy(EbNo,freq_mse,'*-');
title("MSE of the frequency estimation");
xlabel("Eb/N0 [dB]");
ylabel("MSE");
grid on;

figure;
semilogy(EbNo,freq_mae,'*-');
xlabel("Eb/N0 [dB]");
ylabel("MAE");
grid on;
title("MAE of the frequency estimation");


BE = zeros(1,size(results(end),1));

ber_tmp = results(end).ber(1,2);

for k=2:size(results(end),1)
    if results(end).ber(k,2) > ber_tmp
        ber_tmp =results(end).ber(k,2);
        BE(1,k) = 1;
    end
end


