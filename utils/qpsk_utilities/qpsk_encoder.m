function [symbols] = qpsk_encoder(inputBits)
% This functions encodes an input sequence into QPSK symbols 
    
    if size(inputBits,1) ~= 1
        ME = MException('Data vectors must be row vectors');
        throw(ME)
    end
    N = size(inputBits, 2);
    if ~ (mod(N,2) == 0)
        ME = MException('N must be a multiple of 2');
        throw(ME)
    end
    symbols = bi2de_custom(inputBits);
   
end

