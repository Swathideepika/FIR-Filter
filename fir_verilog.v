module fir_filter_system;
    // Define memory arrays for coefficients and signals
    reg signed [15:0] filter_coeffs [0:122];   // 123 filter coefficients (Q2.14)
    reg signed [15:0] sine1 [0:2400];          // 2401 samples for sine waves
    reg signed [15:0] sine2 [0:120];
    reg signed [15:0] sine3 [0:40];
    reg signed [15:0] sine4 [0:21];

    reg signed [15:0] filtered_sine1 [0:2400]; // Filtered outputs
    reg signed [15:0] filtered_sine2 [0:120];
    reg signed [15:0] filtered_sine3 [0:40];
    reg signed [15:0] filtered_sine4 [0:21];
integer i, k;
reg signed [31:0] sum;  // 32-bit accumulator to prevent overflow

// File handling variables
integer file1, file2, file3, file4;

initial begin
    // Read filter coefficients & sine wave files
    $display("Reading filter coefficients...");
    $readmemb("fp_bin.txt", filter_coeffs);

    $display("Reading sine wave inputs...");
    $readmemb("sine1_bin.txt", sine1);
    $readmemb("sine2_bin.txt", sine2);
    $readmemb("sine3_bin.txt", sine3);
    $readmemb("sine4_bin.txt", sine4);

    // Apply FIR filter to each signal
    for (i = 0; i <= 2400; i = i + 1) begin
        sum = 32'd0;
        for (k = 0; k < 123; k = k + 1) begin
            if (i >= k) begin
                sum = sum + sine1[i - k] * filter_coeffs[k];
            end
        end
        filtered_sine1[i] = sum >>> 14;
    end

    for (i = 0; i <= 120; i = i + 1) begin
        sum = 32'd0;
        for (k = 0; k < 123; k = k + 1) begin
            if (i >= k) begin
                sum = sum + sine2[i - k] * filter_coeffs[k];
            end
        end
        filtered_sine2[i] = sum >>> 14;
    end

    for (i = 0; i <= 40; i = i + 1) begin
        sum = 32'd0;
        for (k = 0; k < 123; k = k + 1) begin
            if (i >= k) begin
                sum = sum + sine3[i - k] * filter_coeffs[k];
            end
        end
        filtered_sine3[i] = sum >>> 14;
    end

    for (i = 0; i <= 21; i = i + 1) begin
        sum = 32'd0;
        for (k = 0; k < 123; k = k + 1) begin
            if (i >= k) begin
                sum = sum + sine4[i - k] * filter_coeffs[k];
            end
        end
        filtered_sine4[i] = sum >>> 14;
    end
// Open files to write filtered outputs
file1 = $fopen("filtered_sine1_bin.txt", "w");
file2 = $fopen("filtered_sine2_bin.txt", "w");
file3 = $fopen("filtered_sine3_bin.txt", "w");
file4 = $fopen("filtered_sine4_bin.txt", "w");

if (file1 == 0 || file2 == 0 || file3 == 0 || file4 == 0) begin
    $display("ERROR: Unable to create filtered output files");
    $finish;
end else begin
    $display("Writing filtered outputs to files...");
end

// Write filtered output to respective files
for (i = 0; i <= 2400; i = i + 1) begin
    $fwrite(file1, "%b\n", filtered_sine1[i]);
end
for (i = 0; i <= 120; i = i + 1) begin
    $fwrite(file2, "%b\n", filtered_sine2[i]);
end
for (i = 0; i <= 40; i = i + 1) begin
    $fwrite(file3, "%b\n", filtered_sine3[i]);
end
for (i = 0; i <= 21; i = i + 1) begin
    $fwrite(file4, "%b\n", filtered_sine4[i]);
end

// Close the files
$fclose(file1);
$fclose(file2);
$fclose(file3);
$fclose(file4);

$display("Filtering completed successfully! Filtered data saved.");

$finish; // Stop simulation
end
endmodule

