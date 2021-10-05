function [out] = bi2de_custom(input)
    N = size(input,2)/2;
    out = zeros(1,N);
    for k=1:N
       i = input(1,2*k-1);
       i2 = input(1,2*k);
       if [i, i2] == [0 0]
           out(1,k) = 0;
       elseif [i i2] == [0 1]
           out(1,k) = 1;
       elseif [i i2] == [1 0]
           out(1,k) = 2;
       elseif [i i2] == [1 1]
           out(1,k) = 3;
       end
    end
end

