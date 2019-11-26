data = csvread("C:/temp/pid/november/latest.csv");

data_end = 7000;
sample_start = 35;
sample_size = 60;

prefix_sample_first_time = data(sample_start,1);
prefix_sample_back_in_time = prefix_sample_first_time;

prefix_sample_temperature = [];
prefix_sample_next_time_interval = [];

index = 1;
for i = sample_start:sample_start+sample_size
  prefix_sample_temperature(index) = data(i,4);
  prefix_sample_next_time_interval(index) = data(i+1,1) - data(i,1);
  prefix_sample_back_in_time = prefix_sample_back_in_time ...
    - prefix_sample_next_time_interval(index);
  index = index + 1;
endfor

prefix_sample_back_in_time_step = prefix_sample_first_time ...
  - prefix_sample_back_in_time;

prefix_count = 5;

prefix_sample_time = prefix_sample_first_time ...
  - prefix_count * prefix_sample_back_in_time_step;

raw_time = [];
manual = [];
temperature = [];

index = 1;
for i = 1:prefix_count
  for j = 1:sample_size
    raw_time(index) = prefix_sample_time;
    manual(index) = 0;
    temperature(index) = prefix_sample_temperature(i);
    prefix_sample_time = prefix_sample_time ...
      + prefix_sample_next_time_interval(i);
    index = index + 1;
  endfor
endfor

sourceindex = sample_start;
for i = 1:data_end  
  raw_time(index) = data(sourceindex,1);
  manual(index) = data(sourceindex,3);
  temperature(index) = data(sourceindex,4);
  sourceindex = sourceindex + 1;
  index = index + 1;
endfor

count = index - 1;

first_raw_time = raw_time(1);
time = [];

for i = 1:count
  time(i) = (raw_time(i) - first_raw_time) / 1000;
endfor

hold on;
plot(time(:), temperature(:));
plot(time(:), manual(:));
title("Time vs temperature graph");
ylabel("temperature (°C)");
xlabel("time (s)");
legend("Temperature", "Manual");
hold off;