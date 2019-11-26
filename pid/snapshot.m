raw = csvread("C:/temp/pid/november/snapshot.csv");
rawtime = calculatetime(raw);

output = raw(1:end,3);
time = rawtime(1:end);
temperature = raw(1:end,4);
setpoint = raw(1:end,5);

close all;
figure(1,"position", screenposmargin(120, 120));
hold on;
plot(time(:), temperature(:));
plot(time(:), output(:));
plot(time(:), setpoint(:));
%plot(time, yh);
%plot(showtime(:), showmanual(:));
%plot(time, temperature, 'x');
%plot(time, mrms);
%plot(inflxr, inflyr);
%vline(lstart);
%hline(levely);
%hline(ky);
%vline(infl_x);
xlim([0 max(time)]);
ylim([0 max(temperature)]);
%vline(lend);
%vline(tline);
%hline(infl_y);
hold off;

