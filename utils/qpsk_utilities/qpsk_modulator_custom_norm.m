

function [outputSymbols] = qpsk_modulator_custom(symbol)
    
    if symbol == 0
        outputSymbols = (1/sqrt(2)) +(1/sqrt(2))* 1j;
    elseif symbol == 1
        outputSymbols = (1/sqrt(2)) -(1/sqrt(2))* 1j;
    elseif symbol == 2
        outputSymbols = -(1/sqrt(2)) +(1/sqrt(2))* 1j;
    else 
        outputSymbols = -(1/sqrt(2)) -(1/sqrt(2))* 1j;
    end
    
end