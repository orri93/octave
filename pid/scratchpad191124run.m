
raw = csvread("C:/temp/pid/november/191124run.csv");

rawtime = calculatetime(raw);
time = rawtime; % downsample(rawtime, downsamplesize);
output = raw(:,3);
temperature = raw(:,4); % downsample(raw(:,4), downsamplesize);
setpoint = raw(:, 5);

close all;
figure(1, "position", screenposmargin(120, 120));
hold on;
%plot(time(:), temperature(:));
%plot(time(:), manual(:));
plot(time, output);
plot(time, temperature);
plot(time, setpoint);
%plot(time, yh);
%plot(showtime(:), showmanual(:));
%plot(time, temperature, 'x');
%plot(time, mrms);
%plot(inflxr, inflyr);
%vline(infl_x, "g", TextInflectionPoint);
%hline(infl_y, "g");
%hline(Kmy, "r", TextKm);
%hline(levely, "r");
%hline(X0Y, "r", TextX0);
%vline(TdeadStart, "b");
%vline(TdeadEnd, "b", TextTdead);
%vline(TmX, "b", TextTm);
xlim([0 max(time)]);
ylim([0 max(temperature)]);
hold off;
