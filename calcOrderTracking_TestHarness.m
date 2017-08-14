%%
% Class III - GE Confidential 
% This computer code is proprietary and confidential to the General 
% Electric Company and/or its affiliate(s). It may not be used, disclosed, 
% modified, transferred, or reproduced without GE’s prior written consent, 
% and must be returned on demand. 
%

clear all
close all
clc
home

%% Define signal parameters
%
K = 3;
N = K*65535;
fs = 12800;

% Test case 1 - Sinusoidal frequency modulation
% Test parameters
% 
iTest = 1;

% Signal parameters
dDrift = 1.1;
f = 2500;
t = ((0:(N-1))./fs)';
tn = ((0:(N-1))./N)';
fl = f .* ( 1 + ( (dDrift-1).*tn ) );
a = 1;

% Timebase, no noise
s = chirp(t, f, t(end), dDrift*f);
Y = fft(s)./N;
ws = specscale(N, fs);
plot(ws, abs(fftshift(Y)))

% Call the order tracking function

% Test case 2 - Chirp goodness
% Test parameters
% 
iTest = 1;

% Signal parameters
dDrift = 1.1;
f = 2500;
t = ((0:(N-1))./fs)';
tn = ((0:(N-1))./N)';
fl = f .* ( 1 + ( (dDrift-1).*tn ) );
a = 1;

% Timebase, no noise
s = chirp(t, f, t(end), dDrift*f);
Y = fft(s)./N;
ws = specscale(N, fs);
plot(ws, abs(fftshift(Y)))

% Call the order tracking function

