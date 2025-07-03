% Storing Filter Coefficients
data = load('Num.mat');
coeffs = data.Num;
a = coeffs;

q_214 = round(a * 2^14) / 2^14;
fileID = fopen('fp.txt', 'w');
fprintf(fileID, '%.6f\n', q_214);
fclose(fileID);

% Sine wave generation
Fs = 48000;
f1 = 100; f2 = 2000; f3 = 6000; f4 = 11000;
t1 = 0:1/Fs:(5 * 1/f1);
t2 = 0:1/Fs:(5 * 1/f2);
t3 = 0:1/Fs:(5 * 1/f3);
t4 = 0:1/Fs:(5 * 1/f4);

% Generate sine waves
sine1 = sin(2 * pi * f1 * t1);
sine2 = sin(2 * pi * f2 * t2);
sine3 = sin(2 * pi * f3 * t3);
sine4 = sin(2 * pi * f4 * t4);

% Convert to fixed-point Q(2,14) format
sine1_q214 = round(sine1 * 2^14) / 2^14;
sine2_q214 = round(sine2 * 2^14) / 2^14;
sine3_q214 = round(sine3 * 2^14) / 2^14;
sine4_q214 = round(sine4 * 2^14) / 2^14;

fileID1 = fopen('sine1_fp.txt', 'w');
fprintf(fileID1, '%.6f\n', sine1_q214);
fclose(fileID1);

fileID2 = fopen('sine2_fp.txt', 'w');
fprintf(fileID2, '%.6f\n', sine2_q214);
fclose(fileID2);

fileID3 = fopen('sine3_fp.txt', 'w');
fprintf(fileID3, '%.6f\n', sine3_q214);
fclose(fileID3);

fileID4 = fopen('sine4_fp.txt', 'w');
fprintf(fileID4, '%.6f\n', sine4_q214);
fclose(fileID4);

% Step 3: Apply the filter using 'filter' function
filtered_sine1 = filter(a, 1, sine1_q214);
filtered_sine2 = filter(a, 1, sine2_q214);
filtered_sine3 = filter(a, 1, sine3_q214);
filtered_sine4 = filter(a, 1, sine4_q214);

% Function to save floating-point data line by line
function save_fp_file(filename, data)
    fileID = fopen(filename, 'w');
    for i = 1:length(data)
        fprintf(fileID, '%.6f\n', data(i));  % Write each value on a new line
    end
    fclose(fileID);
end

% Save the floating-point values back to text files
save_fp_file('filtered_sine1_mat.txt', filtered_sine1);
save_fp_file('filtered_sine2_mat.txt', filtered_sine2);
save_fp_file('filtered_sine3_mat.txt', filtered_sine3);
save_fp_file('filtered_sine4_mat.txt', filtered_sine4);

% Step 4: Compute FFT of original and filtered signals
N = 1024;
f_axis = (0:N/2-1) * (Fs/N);  % Frequency axis (half spectrum)

fft_filtered1 = fft(filtered_sine1, N);
fft_filtered2 = fft(filtered_sine2, N);
fft_filtered3 = fft(filtered_sine3, N);
fft_filtered4 = fft(filtered_sine4, N);

% Take only first half of FFT (positive frequencies)
fft_filtered1 = abs(fft_filtered1(1:N/2));
fft_filtered2 = abs(fft_filtered2(1:N/2));
fft_filtered3 = abs(fft_filtered3(1:N/2));
fft_filtered4 = abs(fft_filtered4(1:N/2));

% Step 5: Plot Frequency-Domain Representation
figure;
subplot(4,1,1);
plot(f_axis, fft_filtered1);
title('Filtered Signal 1');
xlabel('Frequency (Hz)'); ylabel('Magnitude');

subplot(4,1,2);
plot(f_axis, fft_filtered2);
title('Filtered Signal 2');
xlabel('Frequency (Hz)'); ylabel('Magnitude');

subplot(4,1,3);
plot(f_axis, fft_filtered3);
title('Filtered Signal 3');
xlabel('Frequency (Hz)'); ylabel('Magnitude');

subplot(4,1,4);
plot(f_axis, fft_filtered4);
title('Filtered Signal 4');
xlabel('Frequency (Hz)'); ylabel('Magnitude');

