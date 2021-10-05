function [outputBits] = qpsk_diff_decoder(inputBits)
% Differential precoding Q-DNRZ as said in 
% EXSS-E-ST-50-05c_Rev2 section 6.2.3.2

    if size(inputBits,1) ~= 1
        ME = MException('Data vectors must be row vectors');
        throw(ME)
    end
    N = size(inputBits, 2);
    if ~ (mod(N,2) == 0)
        ME = MException('N must be a multiple of 2');
        throw(ME)
    end
    a = inputBits(1,1:2:N);
    b = inputBits(1,2:2:N);
    e1 = zeros(1,N/2);
    e2 = zeros(1,N/2);
    outputBits = zeros(1,N);
    for k=1:(N/2) 
        if k == 1
            a_prev = 0;
            b_prev = 0;
        end
        e1(1,k) = not(a_prev) & a(1,k) & not(b(1,k)) |...
                  not(b_prev) & a(1,k) & b(1,k) |...
                  b_prev & not(a(1,k)) & not(b(1,k))|...
                  a_prev & not(a(1,k)) & b(1,k);
        e2(1,k) = not(b_prev) & not(a(1,k)) & b(1,k) |...
                  not(a_prev) & a(1,k) & b(1,k) |...
                  b_prev & a(1,k) & not(b(1,k)) |...
                  a_prev & not(a(1,k)) & not(b(1,k));
        
        a_prev = a(1,k);
        b_prev = b(1,k);
    end
    outputBits(1,1:2:N) = e1;
    outputBits(1,2:2:N) = e2;
    
end

