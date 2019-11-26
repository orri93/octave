function [flatprefix] = prefixflat(data, samplesstart, samplesize, prefixcount, dataend)

prefixflat_sample_first_time = data(samplesstart,1);
prefixflat_sample_back_in_time = prefixflat_sample_first_time;

prefixflat_sample_temperature = [];
prefixflat_sample_next_time_interval = [];

prefixflat_index = 1;
prefixflat_index_data = samplesstart;
for i = 1:samplesize
  prefixflat_sample_temperature(prefixflat_index) = ...
    data(prefixflat_index_data,4);
  prefixflat_sample_next_time_interval(prefixflat_index) = ...
    data(prefixflat_index_data+1,1) - data(prefixflat_index_data,1);
  prefixflat_sample_back_in_time = prefixflat_sample_back_in_time ...
    - prefixflat_sample_next_time_interval(prefixflat_index);
  prefixflat_index_data = prefixflat_index_data + 1;
  prefixflat_index = prefixflat_index + 1;
endfor

prefixflat_sample_back_in_time_step = prefixflat_sample_first_time ...
  - prefixflat_sample_back_in_time;

prefixflat_sample_time = prefixflat_sample_first_time ...
  - prefixcount * prefixflat_sample_back_in_time_step;
  
prefixflat_raw_time = [];
prefixflat_manual = [];
prefixflat_temperature = [];

prefixflat_index = 1;
for i = 1:prefixcount
  for j = 1:samplesize
    prefixflat_raw_time(prefixflat_index) = prefixflat_sample_time;
    prefixflat_manual(prefixflat_index) = 0;
    prefixflat_temperature(prefixflat_index) = prefixflat_sample_temperature(i);
    prefixflat_sample_time = prefixflat_sample_time ...
      + prefixflat_sample_next_time_interval(i);
    prefixflat_index = prefixflat_index + 1;
  endfor
endfor

prefixflat_source = samplesstart;
for i = 1:dataend
  prefixflat_raw_time(prefixflat_index) = data(prefixflat_source,1);
  prefixflat_manual(prefixflat_index) = data(prefixflat_source,3);
  prefixflat_temperature(prefixflat_index) = data(prefixflat_source,4);
  prefixflat_source = prefixflat_source + 1;
  prefixflat_index = prefixflat_index + 1;
endfor

prefixflat_count = prefixflat_index - 1;

prefixflat_first_raw_time = prefixflat_raw_time(1);
prefixflat_time = [];

flatprefix = zeros(prefixflat_count,3);

for i = 1:prefixflat_count
  flatprefix(i,1) = (prefixflat_raw_time(i) - prefixflat_first_raw_time) / 1000;
  flatprefix(i,2) = prefixflat_temperature(i);
  flatprefix(i,3) = prefixflat_manual(i);
endfor

endfunction
