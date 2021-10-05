function [signal] = qpsk_modulator(symbols)
    qpskmod = comm.QPSKModulator;
    qpskmod.PhaseOffset = -pi/4;
    qpskmod.SymbolMapping = 'Gray';
    qpskmod.OutputDataType = 'double';
    signal = qpskmod(symbols');
    signal = signal';
end

