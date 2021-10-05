function [ber] = qpsk_theoretical_ber_rp(EbN0,p_mean,p_std)

    %P(e/phi)
    p_e_cond_phi = @(EsN0,phi) qfunc(sqrt(2*EsN0).*cos(phi+pi/4))+...
                           qfunc(sqrt(2*EsN0).*sin(phi+pi/4))-...
                           qfunc(sqrt(2*EsN0).*cos(phi+pi/4)).*qfunc(sqrt(2*EsN0).*sin(phi+pi/4));



    %P(phi) NO DEPENDE DEL EBN0
    p_phi = @(phi,mean,std) (1/(std*sqrt(2*pi))) .* exp(-(phi-mean).^2 ./(2* std^2));

    p_e_phi = @(EsN0,phi,mean,std) p_e_cond_phi(EsN0,phi) .* p_phi(phi,mean,std);

    p_e = @(EsN0,mean,std) arrayfun(@(EsN0_t) integral(@(phi) p_e_phi(EsN0_t,phi,mean,std),-Inf,Inf),EsN0);
    
    EsN0 = EbN0*2;
    ser = p_e(EsN0,p_mean,p_std);
    ber = ser/2;
end

