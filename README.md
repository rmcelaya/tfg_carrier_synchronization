# tfg_carrier_synchronization
This repository contains the code I used to simulate the carrier synchronization algorithms of my Bachelor's Degree Final Project (TFG)

MATLAB version: R2020b

Simulink version: R2020b Update 5

### Repository structure

The directory structure is:

    ├── analysis                    # MATLAB scripts I used for analyzing different needed aspects of the problem.
    │   ├── channel                 # Doppler shift in LEO satellites analysis
    │   ├── error_rate              # QPSK error rate analysis and simulations
    │   └── estimators              # QPSK carrier recovery analysis
    ├── utils                       # Auxiliary functions and scripts
    ├── simulations                 # MATLAB and simulink scripts I used for simulating the algorithms
    │    ├── Algorithm_simulations  # Simulink models for the proposed and improved proposed algorithms
    │    ├── MATLAB_simulations     # MATLAB models for different estimators
    │    └── old_simulations        # Old stuff. Not interesting at all.
    └── 

The .mat files with the simulation results are not included because they are too big (~10 GB).

### Instructions to simulate the algorithms

Instructions to simulate the proposed and improved proposed algorithms (Simulink) of the simulations/Algorithm_simulations directory.

Simulink models:

	├── proposed_solution.slx             # Proposed algorithm
	└── improved_proposed_solution.slx    # Improved proposed algorithm
	
For the simulation at a single Eb/N0:
1. Open the generate_doppler.m file, edit the needed parameters (execution time window, sampling freq, etc.) and execute it.
2. Open the desired Simulink model, modify the desired parameters (execution time window, filter parameters etc.) and run it.
3. The BER, phase and other results are shown in the model. The BER is also exported to the workspace

For the simulation at several Eb/N0:
1. Open the generate_doppler.m file, edit the needed parameters (execution time, sampling freq, etc.) and execute it
2. Open the desired Simulink model and modify the desired parameters (execution time windows, filter parameters etc.).
3. Open the simulation_workbech.m script, edit the "simulink_file" variable with the desired model and run it.
4. Wait (it can take several hours, but depends on the execution time windows). The results will be saved into a results.mat file (expect a big file)
5. To analyze the results, load the file into memory and execute the results/analyze_results.m script
*6. If a second results file is loaded into memory and the results' variable name is changed into "results2", the analyze_results_both.m file can be used to compare them.
 

Shield: [![CC BY-NC 4.0][cc-by-nc-shield]][cc-by-nc]

This work is licensed under a
[Creative Commons Attribution-NonCommercial 4.0 International License][cc-by-nc].

[![CC BY-NC 4.0][cc-by-nc-image]][cc-by-nc]

[cc-by-nc]: http://creativecommons.org/licenses/by-nc/4.0/
[cc-by-nc-image]: https://licensebuttons.net/l/by-nc/4.0/88x31.png
[cc-by-nc-shield]: https://img.shields.io/badge/License-CC%20BY--NC%204.0-lightgrey.svg
