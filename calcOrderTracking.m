%%
% Class III - GE Confidential 
% This computer code is proprietary and confidential to the General 
% Electric Company and/or its affiliate(s). It may not be used, disclosed, 
% modified, transferred, or reproduced without GE’s prior written consent, 
% and must be returned on demand. 
%
% Unpublished Work © General Electric Company and/or its affiliate(s).
%
% Helper function to calculate the order tracked waveform from an 
% asynchronous waveform. The basic idea is to bandpass the asynchronous
% signal around a given frequency. The signal returned by this filter is
% treated as a synthetic Keyphasor and the data is re-sample synchronously
% to this signal.
%
% function [dataOrdTrack, h] = calcOrderTracking(dataIn, dHalfWidth, dCenter_Hz,...
%     datalength, samplerate, samplesperrev, bPlot)
%
% INPUT
%
% OUTPUT
%
% Brian Howard
% 14 August 2017

function [dataOrdTrack, h] = calcOrderTracking(dataIn, dHalfWidth, dCenter_Hz,...
    datalength, samplerate, samplesperrev, bPlot)

% check inputs, handle optional arguments
assert(max(size(dataIn))>10, 'data must be a vector')
assert(isscalar(dHalfWidth), 'shaft speed (dShaftHz) must be a scalar')
if(nargin < 7)
    bPlot = false;
end

W1 = (dCenter_Hz - (1*dHalfWidth))/(samplerate/2);
W2 = (dCenter_Hz + (1*dHalfWidth))/(samplerate/2);
Np = 3;
[b,a] = butter(Np, [W1 W2], 'bandpass');
kphi = filtfilt(b, a, dataIn);

% Grab the filter response and plot it
h=[];
if bPlot

    [H,~] = freqz(b,a,datalength/2);

    Y = fft(dataIn)./datalength;
    ws = specscale(datalength, samplerate);
    h = figure;
    plot(ws, abs(fftshift(Y)))
    hold on
    plot(ws, abs(fftshift(Y)).*abs([H; H]))
    xlim([0 1000])
    
end

% process the order tracked timebase as a Keyphasor signal
N = length(kphi);
t = (0:(N-1))./samplerate;
method = 'up';
thresh = 0.0;
[~, ~, eventcount] = findkphieventi(kphi,t,method,thresh);
% disp(['eventcount: (calcSERTrendAsync) ' num2str(eventcount)])

% synchronously re-sample the data
synclen = samplesperrev*(eventcount-5);
kphratio = 1;
dataOrdTrack = syncsampleaa(dataIn, kphi, samplerate,...
                                     samplesperrev, synclen,...
                                     kphratio, thresh);
return