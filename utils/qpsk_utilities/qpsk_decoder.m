function [binaryOut] = qpsk_decoder(inputSym)
    
    tmp = de2bi(inputSym,2,'left-msb');
    tmp = tmp';
    binaryOut = tmp(:);
    binaryOut = binaryOut';
end

