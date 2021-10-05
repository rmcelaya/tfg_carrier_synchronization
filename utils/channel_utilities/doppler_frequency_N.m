function [N] = doppler_frequency_N(fs)
    
    max_elevation = 90;
    i = 90;
    min_elevation = 10;
    r_e = 6366e3;
    h = 400e3;
    r = h+r_e;
    w_e = 7.292124e-5;
    w_s = sqrt(3.98601352e5/(r/1000)^3);
    w_f = w_s -w_e *cosd(i);


    cos_gamma_t0 = cosd(acosd((r_e/r)*cosd(max_elevation))-max_elevation);
    cos_gamma_min =cosd(acosd((r_e/r)*cosd(min_elevation))-min_elevation);

    visibility = (2/w_f)*acos(cos_gamma_min/cos_gamma_t0);
    N = visibility * fs;
end

