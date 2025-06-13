%% Hüseyin Berk Keskin

clc, clear, close all

%% Variables
fs=48000;   % Sampling frequency
ts=1/fs;    % Sampling period
T=(1:ts:4);  % message length in sec.
t=T;
f1=20; % Frequency of the first cosine
f2=60; % Frequency of the second cosine
a1=2; % Amplitude of the first cosine
a2=5; % Amplitude of the second cosine
B=6000; % Frequency shift for the scrambler
W=12000; % Carrier frequency for the scrambler
fc=9000; % Carrier frequency for SSB modulation
Ac=2; % Carrier amplitude for SSB modulation
Alo=2; % Local oscillator amplitude for SSB modulation
N=1024; % Number of points for FFT

%% Task4

m_t = audioread('speech.wav'); % Speech

[shiftedSpectrum_m_t ,M_f,freqAxis_m_t]=zero_padding_FFT(m_t,fs,N);

m_t = m_t(1:length(T));         % Same dimension with time

figure(1)
subplot(211)
plot(t, m_t)
title('Graph of input message signal m(t) and the frequency spectrum of the input message signal M(f)')
% Normalized message spectrum
subplot(212)
plot(0:1/(N/2-1):1, abs(M_f(1:N/2)));

%% Analog Scrambler
m_t2=m_t.*cos(2*pi*W*t);
[b,a]=butter(20,2*W/fs,"high");    % Low-Pass filter
high_t2 = filtfilt(b, a, m_t2);  % Low-Pass filter

highmtolow_t2 = high_t2.*(cos(2*pi*(W+B)*t));
[b,a]=butter(10,2*B/fs,"low");    % Low-Pass filter
lowm_t2 = filtfilt(b, a, highmtolow_t2);  % Low-Pass filter

%% SSB Modulator - HILBERT

y = hilbert(lowm_t2);

input1 = lowm_t2;
input2 = imag(y);

output1 = input2 .* (Ac*sin(2*pi*fc*t));
output2 = input1 .* (Ac*cos(2*pi*fc*t));
out = output2 - output1;

%% SSB Demodulator
demodulator_input = out.*(Alo * cos(2*pi*fc*t));

[b,a]=butter(10,2*B/fs,"low");    % Low-Pass filter
demodulator_output = filtfilt(b, a, demodulator_input);  % Low-Pass filter

%% Analog Descrambler
m_t2=demodulator_output.*cos(2*pi*W*t);
[b,a]=butter(10,2*W/fs,"high");    % Low-Pass filter
high_t2 = filtfilt(b, a, m_t2);  % Low-Pass filter

highmtolow_t2=high_t2.*(cos(2*pi*(W+B)*t));
[b,a]=butter(10,2*B/fs,"low");    % Low-Pass filter
lowm_t2 = 10*filtfilt(b, a, highmtolow_t2);  % Low-Pass filter

%%
figure(2)
subplot(211)
plot(t, lowm_t2)
title('Plot the received message signal m ̃(t) by a legitimated user.')

[shiftedSpectrum_m_low ,M_lowm,freqAxis_m_lowm]=zero_padding_FFT(lowm_t2,fs,N);
% Normalized message spectrum
subplot(212)
plot(0:1/(N/2-1):1, abs(M_lowm(1:N/2)));
title('Plot the frequency spectrum of the received message signal M ̃ (f ).')

%%
figure(3)
subplot(211)
plot(t, m_t)
title('Plot input message signal m(t)')
subplot(212)
plot(t, lowm_t2)
title('Plot the received message signal m ̃(t) by a legitimated user.')

%%
figure(4)
subplot(211)
plot(t,demodulator_output)
title('Plot the  output of the receiver in time-domain (me(t))')
[shiftedSpectrum_me_f ,Me_f,freqAxis_me_t]=zero_padding_FFT(demodulator_output,fs,N);
subplot(212)
plot(0:1/(N/2-1):1, abs(Me_f(1:N/2)));
title('Plot the frequency spectrum of the frequency spectrum Me(f)')

%%
figure(5)
[shiftedSpectrum_m_t ,M_f,freqAxis_m_t]=zero_padding_FFT(m_t,fs,N);
subplot(211)
plot(0:1/(N/2-1):1, abs(M_f(1:N/2)));
title('Plot the frequency spectrum of the M(f)')
[shiftedSpectrum_me_res_t ,Me_res_f,freqAxis_me_res_t]=zero_padding_FFT(demodulator_output,fs,N);
subplot(212)
plot(0:1/(N/2-1):1, abs(Me_res_f(1:N/2)));
title('Plot the frequency spectrum of the Me(f)')

sound(m_t,fs)
pause           %space basınca bir sonraki adıma atlıyor
sound(demodulator_output,fs)
pause       %space basınca bir sonraki adıma atlıyor
sound(lowm_t2,fs)
 