function [time] = calculatetime(data, time = 0)
  % time = 0 : seconds
  % time = 1 : minutes
  first = data(1,1);
  time = [];
  count = rows(data);
  divider = 1000;
  if time == 1
    divider = 60 * divider;
  endif
  for i = 1:count
    time(i) = (data(i,1) - first) / divider;
  endfor
endfunction
