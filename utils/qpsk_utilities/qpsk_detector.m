function [outputSymbols] = qpsk_detector(signal)
    
    if real(signal) >= 0 && imag(signal) >=0
        outputSymbols = 0;
    elseif real(signal) <= 0 && imag(signal) >=0
        outputSymbols = 2;
    elseif real(signal) <= 0 && imag(signal) <=0
        outputSymbols = 3;
    elseif real(signal) >= 0 && imag(signal) <=0
        outputSymbols = 1;
    else
        outputSymbols = 0;
    end
    
end

