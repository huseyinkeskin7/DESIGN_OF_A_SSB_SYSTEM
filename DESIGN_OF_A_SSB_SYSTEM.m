%% Hüseyin Berk Keskin

clc, clear, close all

%% Variables
fs=1000; % Sampling frequency
ts=1/fs; % Sampling period
t=(-2:ts:2); % Time vector
f1=20; % Frequency of the first cosine
f2=60; % Frequency of the second cosine
a1=2; % Amplitude of the first cosine
a2=5; % Amplitude of the second cosine
B=150; % Frequency shift for the scrambler
W=250; % Carrier frequency for the scrambler
fc=200; % Carrier frequency for SSB modulation
Ac=2; % Carrier amplitude for SSB modulation
Alo=2; % Local oscillator amplitude for SSB modulation
N=1024; % Number of points for FFT

%% Task2-i

m_t=a1*cos(2*pi*f1*t)+a2*cos(2*pi*f2*t); % Message signal
[shiftedSpectrum_m_t ,M_f,freqAxis_m_t]=zero_padding_FFT(m_t,fs,N);

figure(1)
subplot(211)
plot(t, m_t)
title('Graph of input message signal m(t) and the frequency spectrum of the input message signal M(f)')
xlim([0 .5])
subplot(212)
plot(0:1/(N/2-1):1, abs(M_f(1:N/2)));

%% Analog Scrambler
m_t2=m_t.*cos(2*pi*W*t);
[b,a]=butter(10,0.5,"high");    % Low-Pass filter
highm_t2 = filtfilt(b, a, m_t2);  % Low-Pass filter

highmtolow_t2=highm_t2.*(cos(2*pi*(W+B)*t));
[b,a]=butter(10,0.3,"low");    % Low-Pass filter
H=freqz(b,a,floor(N/2));    % Filter frequency response
lowm_t2 = filtfilt(b, a, highmtolow_t2);  % Low-Pass filter

%% SSB Modulator - HILBERT

y = hilbert(lowm_t2);

input1 = lowm_t2;
input2 = imag(y);

output1 = input1 .* (Ac*cos(2*pi*fc*t));
output2 = input2 .* (Ac*sin(2*pi*fc*t));
output = output1 - output2;

%% SSB Demodulator
demodulator_input = output.*(Alo * cos(2*pi*fc*t));

[b,a]=butter(10,0.3,"low");    % Low-Pass filter
demodulator_output = filtfilt(b, a, demodulator_input);  % Low-Pass filter

%% Analog Descrambler
m_t2=demodulator_output.*cos(2*pi*W*t);
[b,a]=butter(10,0.5,"high");  
highm_t2 = filtfilt(b, a, m_t2);  

highmtolow_t2=highm_t2.*(cos(2*pi*(W+B)*t));
[b,a]=butter(10,0.3,"low");   
lowm_t2 = 10*filtfilt(b, a, highmtolow_t2);

%% Task2-ii

[shiftedSpectrum_low ,M_low_f,freqAxis_low]=zero_padding_FFT(lowm_t2,fs,N);
figure(2)
subplot(311)
plot(0:1/(N/2-1):1, abs(H),'r')
subplot(312)
plot(t, lowm_t2)
title('Plot the received message signal m ̃(t) by a legitimated user.')
xlim([0 .5])
% Normalized message spectrum
subplot(313)
plot(0:1/(N/2-1):1, abs(M_low_f(1:N/2)));
title('Plot the frequency spectrum of the received message signal M ̃ (f ).')

%% Task2-iii
figure(3)
subplot(211)
plot(t, m_t)
title('Plot input message signal m(t)')
xlim([0 .5])
subplot(212)
plot(t, lowm_t2)
title('Plot the received message signal m ̃(t) by a legitimated user.')
xlim([0 .5])

%% Task3-i
figure(4)
subplot(211)
plot(t,demodulator_output)
title('Plot the  output of the receiver in time-domain (me(t))')
xlim([0 0.5])
[shiftedSpectrum_me_t ,Me_f,freqAxis_me_t]=zero_padding_FFT(demodulator_output,fs,N);
subplot(212)
plot(0:1/(N/2-1):1, abs(Me_f(1:N/2)));
title('Plot the frequency spectrum of the frequency spectrum Me(f)')

%% Task3-ii
figure(5)
[shiftedSpectrum_m_t ,M_f,freqAxis_m_t]=zero_padding_FFT(m_t,fs,N);
subplot(211)
plot(0:1/(N/2-1):1, abs(M_f(1:N/2)));
title('Plot the frequency spectrum of the frequency spectrum M(f)')

[shiftedSpectrum_me_res_t ,Me_res_f,freqAxis_me_res_t]=zero_padding_FFT(demodulator_output,fs,N);
subplot(212)
plot(0:1/(N/2-1):1, abs(Me_res_f(1:N/2)));
title('Plot the frequency spectrum of the frequency spectrum Me(f)')
