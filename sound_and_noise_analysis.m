% Load audio file
filename = 'piano.wav';
[y, Fs] = audioread(filename);

% Plot waveform
t = (0:length(y)-1)/Fs;
subplot(2,3,1);
plot(t,y);
title('Waveform');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot power spectral density (PSD)
N = length(y);
xdft = fft(y);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
freq = 0:Fs/N:Fs/2;
subplot(2,3,2);
plot(freq,10*log10(psdx));
title('Power Spectral Density (PSD)');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');

% Plot periodogram (logarithmic scale)
subplot(2,3,4);
periodogram(y,hamming(length(y)),length(y),Fs,'power','centered');
title('Periodogram (logarithmic scale)');
xlabel('Frequency (Hz)');
ylabel('Power (dB)');
set(gca, 'YScale', 'log');

% Plot periodogram (semilogarithmic scale)
subplot(2,3,5);
periodogram(y,hamming(length(y)),length(y),Fs,'power','centered');
title('Periodogram (semilogarithmic scale)');
xlabel('Frequency (Hz)');
ylabel('Power (dB)');
set(gca, 'XScale', 'log');

% Calculate and display noise level
noise_start_sec = 1; % Noise starts after 1 second
noise_end_sec = 2;   % Noise ends after 2 seconds
noise_start_index = floor(noise_start_sec*Fs)+1;
noise_end_index = floor(noise_end_sec*Fs);
noise = y(noise_start_index:noise_end_index);
noise_level = mean(abs(noise));
fprintf('Noise level = %.2f\n', noise_level);

% Calculate and display SNR
signal_start_sec = 3; % Signal starts after 3 seconds
signal_end_sec = 4;   % Signal ends after 4 seconds
signal_start_index = floor(signal_start_sec*Fs)+1;
signal_end_index = floor(signal_end_sec*Fs);
signal = y(signal_start_index:signal_end_index);
signal_level = mean(abs(signal));
SNR = 20*log10(signal_level/noise_level);
fprintf('SNR = %.2f dB\n', SNR);

% Plot histogram
subplot(2,3,6);
histogram(y,50);
title('Histogram');
xlabel('Amplitude');
ylabel('Count');

% Statistics information
fprintf('Statistics information:\n');
fprintf('-----------------------\n');
fprintf('Minimum amplitude = %.2f\n', min(y));
fprintf('Maximum amplitude = %.2f\n', max(y));
fprintf('Mean amplitude = %.2f\n', mean(y));
fprintf('RMS amplitude = %.2f\n', rms(y));

% Spectrogram
window = 1024;
noverlap = round(window/2);
nfft = window;
subplot(2,3,3);
spectrogram(y,window,noverlap,nfft,Fs,'yaxis');
title('Spectrogram');
