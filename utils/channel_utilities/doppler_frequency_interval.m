function [t,relative_doppler] = doppler_frequency_interval(fs,fc,N)
    
    max_elevation = 90;
    i = 90;
    min_elevation = 10;
    c = 3e8;
    r_e = 6366e3;
    h = 400e3;
    r = h+r_e;
    w_e = 7.292124e-5;
    w_s = sqrt(3.98601352e5/(r/1000)^3);
    w_f = w_s -w_e *cosd(i);


    cos_gamma_t0 = cosd(acosd((r_e/r)*cosd(max_elevation))-max_elevation);
    cos_gamma_min =cosd(acosd((r_e/r)*cosd(min_elevation))-min_elevation);

    visibility = (2/w_f)*acos(cos_gamma_min/cos_gamma_t0);
    
    
    relative_tv = (visibility/2);
    t = fs*(1:N)-relative_tv;
    psi_delta = w_f*t;

    A = cos_gamma_t0;
    K = r_e * r;
    B = r_e^2 +r^2;

    relative_doppler = (-1/c) * ((K*sin(psi_delta)*A*w_f)./...
                        sqrt(B -2* K*cos(psi_delta)* A));
                    
    relative_doppler = relative_doppler * fc;

end

