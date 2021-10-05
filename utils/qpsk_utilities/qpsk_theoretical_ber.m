function [ber] = qpsk_theoretical_ber(EbN0,p_offset)
    %P(e/phi)
    p_e_cond_phi = @(EsN0,phi) qfunc(sqrt(2*EsN0).*cos(phi+pi/4))+...
                           qfunc(sqrt(2*EsN0).*sin(phi+pi/4))-...
                           qfunc(sqrt(2*EsN0).*cos(phi+pi/4)).*qfunc(sqrt(2*EsN0).*sin(phi+pi/4));
    
    EsN0 = EbN0*2;
    ser = zeros(1,size(EsN0,2));
    for k=1:size(EsN0,2)
        ser(1,k) = p_e_cond_phi(EsN0(1,k),p_offset);
    end
    ber = ser/2;
end

