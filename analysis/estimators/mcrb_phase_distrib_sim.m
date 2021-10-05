function [p_mean,p_std] = mcrb_phase_distrib_sim(EbN0,L0,L,mu_v,N)
    EsN0 = 2*EbN0;
    mcrb_v = (3/(8* pi^2 * L0^3)) * (1/EsN0);
    mcrb_phi = (1/(2*L0)) * (1/EsN0);

    v = normrnd(mu_v,sqrt(mcrb_v),[1,N]);
    ro = sin(pi*L0*v)./(L0*sin(pi*v));
    distrib = normrnd(2*pi*L*v,sqrt(mcrb_phi./ ro.^2),[1,N]);
    p_mean = mean(distrib);
    p_std = sqrt(var(distrib));
    
end

