function [p_mean,p_std] = mcrb_phase_distrib_analytical(EbN0,L0,L,mu_v,N)
    EsN0 = 2*EbN0;
    mcrb_v = (3/(8* pi^2 * L0^3)) * (1/EsN0);
    mcrb_phi = (1/(2*L0)) * (1/EsN0);

    p_mean = 2*pi*L*mu_v;
    p_std = sqrt(mcrb_phi+4*pi^2 * L^2 *mcrb_v);
    
end

