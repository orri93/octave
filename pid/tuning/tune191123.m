%
% Ziegler-Nichols’ Open-Loop Method
%

%
show = 7000;
count = 4300;
downsamplesize = 10;

% Reading from S curve
LevelY = 24;        % The level value
LevelX0 = 0;        % The input at the level
X0Y = 39;           % The step change in the input
KmY = 130;          % The Km value (leveling after the step)
TdeadStart = 2.15;  % The start of the step
InflectionI = 14;   % Inflection point index

MaximumInput = 255; % The maximum input
MaximumValue = 250; % The maximum of the working range

CalculateRatioKm = @(kmy, maximum) kmy / maximum;
CalculateTdeadMin = @(tdeadstart, tdeadend) tdeadend - tdeadstart;
CalculateTdeadSec = @(tdeadstart, tdeadend) 60 * CalculateTdeadMin(tdeadstart, tdeadend);
CalculateTmMin = @(tdeadend, tmend) tmend - tdeadend;
CalculateTmSec = @(tdeadend, tmend) 60 * CalculateTmMin(tdeadend, tmend);

% Smooth factors
smooth_d = 2;
smooth_stdev = 1;

% Packages used
pkg load signal;
pkg load data-smoothing;

raw = csvread("C:/temp/pid/november/191123.csv");
rawtime = calculatetime(raw);

% Show  more of the data than is used in the analizes
showmanual = downsample(raw(1:show,3), downsamplesize);
showtemperature = downsample(raw(1:show,4), downsamplesize);
showtime = downsample(rawtime(1:show), downsamplesize);

% Downsample to reduce calculation time
manual = downsample(raw(1:count,3), downsamplesize);
time = downsample(rawtime(1:count), downsamplesize);
temperature = downsample(raw(1:count,4), downsamplesize);

% Smooth out the S curve
[yh, lambda] = regdatasmooth(time, temperature, "d", smooth_d, "stdev", smooth_stdev, "midpointrule");

% Aproximate the tangens of the S curve
[xt, yt, dt] = dertan(time, yh, 3, 6);

% Get the x, y and tangen of the inflection point
infl_x = xt(InflectionI);
infl_y = yt(InflectionI);
infl_t = dt(InflectionI);

% Find the b factor for the line through the inflection point
infl_line_b = linethrougth(infl_x, infl_y, infl_t);

% Create the slope line through the inflection point
[inflxr, inflyr] = createinflline(... 
  0, ...                        % x1 first X value
  max(showtime), ...            % x2 last X value
  infl_t, ...                   % The m value
  infl_line_b, ...              % The b value
  0, ...                        % The minium y
  2 * max(showtemperature), ... % The maximum y
  5);                           % The x step or space

TmX = revinflline(KmY, infl_t, infl_line_b);
TdeadEnd = revinflline(levely, infl_t, infl_line_b);

X0 = CalculateRatioX0(X0Y, LevelX0, MaximumInput);
Km = CalculateRatioKm(KmY, MaximumValue);
TdeadMin = CalculateTdeadMin(TdeadStart, TdeadEnd);
TdeadSec = CalculateTdeadSec(TdeadStart, TdeadEnd);
TmMin = CalculateTmMin(TdeadEnd, TmX);
TmSec = CalculateTmSec(TdeadEnd, TmX);

[KpMin, KiMin, KdMin, TiMin, TdMin] = zieglericholst(X0, TmMin, Km, TdeadMin, 2, 0);
[KpSec, KiSec, KdSec, TiSec, TdSec] = zieglericholst(X0, TmSec, Km, TdeadSec, 2, 0);


printf("X0 value: %f\n", X0);
printf("Km: %f\n", Km);
printf("Tdead: %f min or %f sec\n", TdeadMin, TdeadSec);
printf("Tm: %f min or %f sec\n", TmMin, TmSec);

printf("Kp: %.2f, Ki: %.2f, Kd: %.2f, Ti: %0.2f min, Td: %0.2f min\n", KpMin, KiMin, KdMin, TiMin, TdMin);
printf("Kp: %.2f, Ki: %.2f, Kd: %.2f, Ti: %0.2f sec, Td: %0.2f sec\n", KpSec, KiSec, KdSec, TiSec, TdSec);

TextX0 = sprintf("X0 value %.0f and ratio %.3f of maximum %.0f", X0Y, X0, MaximumInput);
TextInflectionPoint = sprintf("Inflection point (%.2f, %.2f)", infl_x, infl_y);
TextKm = sprintf("Km value %.0f and ratio %.3f of maximum %.0f", KmY, Km, MaximumValue);
TextTdead = sprintf("Tdead %.2f min and %.2f sec", TdeadMin, TdeadSec);
TextTm = sprintf("Tm %.2f min", TmMin);

close all;
figure(1, "position", screenposmargin(120, 120));
hold on;
%plot(time(:), temperature(:));
%plot(time(:), manual(:));
plot(showtime(:), showtemperature(:), 'x');
plot(time, yh);
plot(showtime(:), showmanual(:));
%plot(time, temperature, 'x');
%plot(time, mrms);
plot(inflxr, inflyr);
vline(infl_x, "g", TextInflectionPoint);
hline(infl_y, "g");
hline(Kmy, "r", TextKm);
hline(levely, "r");
hline(X0Y, "r", TextX0);
vline(TdeadStart, "b");
vline(TdeadEnd, "b", TextTdead);
vline(TmX, "b", TextTm);
xlim([0 max(showtime)]);
ylim([0 max(temperature)]);
hold off;
