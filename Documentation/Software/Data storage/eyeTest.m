
clc
clear

addpath(genpath('./subFunctions'))
addpath(genpath('./AlexData'))

% load eyes open/closed data from '.csv' files and assign to variables
close1 = 'C:\Users\cnzak\Dropbox\PolyCortex\software\EyeTest\AlexData\close1.csv';
% close1 = 'C:\Users\cnzak\Dropbox\PolyCortex\software\EyeTest\subFunctions\AlexData\close2.csv';
open1 = 'C:\Users\cnzak\Dropbox\PolyCortex\software\EyeTest\AlexData\open1.csv';
% open1 = 'C:\Users\cnzak\Dropbox\PolyCortex\software\EyeTest\subFunctions\AlexData\open2.csv';
% open1 = 'C:\Users\cnzak\Dropbox\PolyCortex\software\EyeTest\subFunctions\AlexData\open3.csv';
dataClose1 = xlsread(close1)';
% dataClose2 = xlsread(close2)';
dataOpen1 = xlsread(open1)';
% dataOpen2 = xlsread(open2)';
% dataOpen3 = xlsread(open3)';

% each of the first four columns of each variable corresponds to EEG 
% data
record1 = dataClose1(1,:)*4.5/24/(2^23-1)*1000*1000;
% record2 = dataClose2(1,:)*4.5/24/(2^23-1)*1000*1000;
record2 = dataOpen1(1,:)*4.5/24/(2^23-1)*1000*1000;
% record4 = dataOpen2(1,:)*4.5/24/(2^23-1)*1000*1000;
% record5 = dataOpen3(1,:)*4.5/24/(2^23-1)*1000*1000;
sampFreq = 250;
% Data from 'record' is sampled at 250 Hz which corresponds to a time 
% interval of 0.004 s. A vector array representing time and which is the 
% same length as 'record1' is created, each element corresponding 
% the a 0.01s time interval (by dividing each integer element 
% by the sampling frequency) 
N = length(record1);
x = (1:N)/sampFreq; 

range1 = 5000;
range2 = 15000;

N2 = length(record1(range1:range2));
x2 = (1:N2)/250; 
figure;
grid on
plot(x2, record1(range1:range2),'b')
hold on
plot(x2, record2(range1:range2),'r')
title('Brain electrical activity')
xlabel('time (s)') 
ylabel('amplitude (\muV)') 
legend('closed ', 'open')
xlim([0 round(max(x2))])

% BANDPASS FILTER 0.5-35Hz
record1_sub = record1(range1:range2);
record2_sub = record2(range1:range2);
% MATLAB uses the convention that unit frequency is the Nyquist frequency, 
% defined as half the sampling frequency. The cutoff frequency parameter 
% for all basic filter design functions is normalized by the Nyquist 
% frequency. For a system with a 250 Hz sampling frequency, 0.3 Hz is 
% 0.3/125
normalizedCutFreq = 0.3/(sampFreq/2);
hpFilter = fir1(400,normalizedCutFreq,'high');
hpFilteredSignal1 = filter(hpFilter,1,record1_sub);
hpFilteredSignal2 = filter(hpFilter,1,record2_sub);
% fftHpFiltered = fft(hpFilteredSignal);
% P2 = abs(fftHpFiltered/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
%figure, plot(f,P1);
normalizedLPcutFreq = 35/(sampFreq/2);
lpFilter = fir1(400,normalizedLPcutFreq,'low');
lpFilteredSignal1 = filter(lpFilter,1,hpFilteredSignal1);
lpFilteredSignal2 = filter(lpFilter,1,hpFilteredSignal2);
fftLpFiltered1 = fft(lpFilteredSignal1);
fftLpFiltered2 = fft(lpFilteredSignal2);

N = length(lpFilteredSignal1);
Fs = 250; % sampling frequency
P3 = (1/(Fs*N)) * abs(fftLpFiltered1).^2;
P3(2:end-1) = 2*P3(2:end-1);
P1 = P3(1:N/2+1); % uV

P4 = (1/(Fs*N)) * abs(fftLpFiltered2).^2;
P4(2:end-1) = 2*P4(2:end-1);
P2 = P4(1:N/2+1); % uV

freq = 0:Fs/length(lpFilteredSignal1):Fs/2;
smoothP1 = smoothdata(10*log10(P1), 'loess', 150);
smoothP2 = smoothdata(10*log10(P2), 'loess', 150);
% smoothP1 = smoothdata(P1, 'loess', 150);
% smoothP2 = smoothdata(P2, 'loess', 150);

figure; plot(freq,smoothP1,'b')
hold on;
plot(freq,smoothP2,'r')
grid on
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')
xlim([0 50])
legend('closed ', 'open')

% % BOUNDED LINE PLOT EXAMPLE
% smoothdB1 = smoothdata(10*log10(P1), 'loess', 150);
% smoothdB2 = smoothdata(10*log10(P2), 'loess', 150);
% ci1 = smoothdata(rand(size(smoothdB1))*8, 'loess', 150);
% ci2 = smoothdata(rand(size(smoothdB2))*8, 'loess', 150);
% figure; boundedline(freq,smoothdB1, ci1, 'b')
% hold on
% boundedline(freq,smoothdB2, ci2, 'r')
% title('Boundedline Periodogram')
% grid on
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')
% xlim([0 50])
% legend('closed ', 'open')

% % alpha band (8-12 Hz)
% [~, alphaLimL] = min(abs(freq-8));
% [~, alphaLimH] = min(abs(freq-12));
% alphaAvg = mean(P1(alphaLimL:alphaLimH));
% 
% % theta band (3-7 Hz)
% [~, thetaLimL] = min(abs(freq-3));
% [~, thetaLimH] = min(abs(freq-7));
% thetaAvg = mean(P1(thetaLimL:thetaLimH));
% 
% % delta band (0.5-2 Hz)
% [~, deltaLimL] = min(abs(freq-0.5));
% [~, deltaLimH] = min(abs(freq-2));
% deltaAvg = mean(P1(deltaLimL:deltaLimH));