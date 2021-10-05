
clc;
%select the simulation file
simulink_file = "proposed_solution.slx";
EbNo = 0:0.5:10;

for k=1:size(EbNo,2)
    EbNo_i = EbNo(k);
    fprintf("Simulating the system @Eb/No=%.2f ...\n",EbNo_i);
    r = sim(simulink_file);
    r.EbNo = EbNo_i;
    results(1,k) = r;
end

save('results.mat','results','-v7.3');