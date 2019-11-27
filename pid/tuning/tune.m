function [Kp, Ki, Kd, Ti, Td] = tune(data, spec, scurve, maximum, ...
  smoothfactors, di = 0, type = 0, publish = 0, utitle = '')
%
% Ziegler-Nichols’ Open-Loop Method
%

% di       : delta i
% type     : 0 is general, 1 is LabVIEW slow, 2 is LabVIEW normal and 3 is LabVIEW fast

%clc;

addpath("C:/home/orri/src/octave/functions/");

%
show = spec.Show;
count = spec.Count;
downsamplesize = spec.DownSample;

% Smooth factors
smooth_d = smoothfactors.d;
smooth_stdev = smoothfactors.stdev;

% Reading from S curve
LevelY = scurve.LevelY;                 % The level value
LevelX0 = scurve.LevelX0;               % The input at the level
X0Y = scurve.X0Y;                       % The step change in the input
KmY = scurve.KmY;                       % The Km value (leveling after the step)
TdeadStart = scurve.TdeadStart;         % The start of the step
InflectionI = scurve.InflectionI;       % Inflection point index
InflectionMaxY = scurve.InflectionMaxY; % The maximum level for the inflection slope line

MaximumInput = maximum.Input;           % The maximum input
MaximumValue = maximum.Value;           % The maximum of the working range

% Packages used
pkg load signal;
pkg load data-smoothing;

% Adjusted inflection point index
AdjustInflectionI = InflectionI + di;

%raw = csvread("C:/temp/pid/november/191123.csv");
rawtime = calculatetime(data, 0);  %Convert time to seconds

% Show  more of the data than is used in the analizes
showmanual = downsample(data(1:show,3), downsamplesize);
showtemperature = downsample(data(1:show,4), downsamplesize);
showtime = downsample(rawtime(1:show), downsamplesize);

% Downsample to reduce calculation time
manual = downsample(data(1:count,3), downsamplesize);
time = downsample(rawtime(1:count), downsamplesize);
temperature = downsample(data(1:count,4), downsamplesize);

% Smooth out the S curve
[yh, lambda] = regdatasmooth(...
  time, temperature, ...
  "d", smooth_d, ...
  "stdev", smooth_stdev, ...
  "midpointrule");

% Aproximate the tangens of the S curve
[xt, yt, dt] = dertan(time, yh, 3, 6);

% Get the x, y and tangen of the inflection point
infl_x = xt(AdjustInflectionI);
infl_y = yt(AdjustInflectionI);
infl_t = dt(AdjustInflectionI);

% Find the b factor for the line through the inflection point
infl_line_b = linethrougth(infl_x, infl_y, infl_t);

% Create the slope line through the inflection point
[inflxr, inflyr] = createinflline(... 
  0, ...                        % x1 first X value
  max(showtime), ...            % x2 last X value
  infl_t, ...                   % The m value
  infl_line_b, ...              % The b value
  infl_line_b, ...              % The minium y
  InflectionMaxY, ...           % The maximum y
  5);                           % The x step or space

TmX = revinflline(KmY, infl_t, infl_line_b);
TdeadEnd = revinflline(LevelY, infl_t, infl_line_b);

X0 = ratiox0(X0Y, LevelX0, MaximumInput);
Km = ratiokm(KmY, MaximumValue);
Tdead = TdeadEnd - TdeadStart;
Tm = TmX - TdeadEnd;

if length(utitle) > 0
  TextTitle = "Tune PID - ";
  TextTitle = strcat(TextTitle, utitle);
TextTitle
  TitleText = "Tune PID";
endif

TitleText = strcat(TextTitle, "\n");

printf("\n\n===============================================================\n");
printf(TitleText);
printf("===============================================================\m");

printf("X0 ratio value is %.4f\n", X0);
printf("X0 ratio is calculated as the ratio of the distance %.0f betweenn\n", ...
  X0Y - LevelY);
printf("the ground level of %.0f and X0 level %.0f against the distance %.0f between\n", ...
  LevelY, X0Y, MaximumInput - LevelY);
printf("the ground level of %.0f and the maximum level %.0f\n\n", ...
  LevelY, MaximumInput);

printf("Km ratio value is %.4f\n", Km);
printf("Km ratio is calculated as the ratio betweenn the Km %.3f level value\n", KmY);
printf("against the maximum value %.3f\n\n", MaximumValue);

printf("Tdead %f sec is the difference between the intersection of the \n", Tdead);
printf("slope line and the ground level at %f and the begining of \n", TdeadEnd);
printf("the step at %f\n\n", TdeadStart);

printf("Tm %f sec is the difference between the intersection of the \n", Tm);
printf("slope line and the Km level at %f and the begining of the step at %f\n\n", ...
  TmX, TdeadEnd);
  
[Kp, Ki, Kd, Ti, Td] = zieglericholst(X0, Tm, Km, Tdead, 2, type);

printf("\nKp: %.2f, Ki: %.4f, Kd: %.4f, Ti: %0.4f sec, Td: %0.4f sec\n", ...
  Kp, Ki, Kd, Ti, Td);

TextX0 = sprintf("X0 %.3f", X0);
%TextX0 = sprintf("X0 value %.0f and ratio %.3f of maximum %.0f", X0Y, X0, MaximumInput);

%TextKm = sprintf("Km value %.0f and ratio %.3f of maximum %.0f", KmY, Km, MaximumValue);
TextKm = sprintf("Km %.3f", Km);

TextTdeadStart = sprintf("Tstart %.0f sec", TdeadStart);
TextTdead = sprintf("Tdead %.0f sec", Tdead);
TextTm = sprintf("Tm %.0f sec", Tm);

TextInflectionPoint = sprintf("ip (%.1f, %.1f)", infl_x, infl_y);
TextPid = sprintf("Kp: %f, Ki: %f and Kd: %f", Kp, Ki, Ki);

textpm.w =  max(showtime) / 50;
textpm.h = (max(temperature) - infl_line_b) / 50;

infltextpos.x = infl_x + textpm.w;
infltextpos.y = infl_y + textpm.h;

range.xaxis = [0, max(showtime)];
range.yaxis = [infl_line_b, max(temperature)];

srange = @(x)[x x];

if publish >= 0
  
if publish > 0
  figure(publish);
else
  close all;
  figure(1, "position", screenposmargin(240, 120));
endif

plot(time, yh);
hold on;
plot(showtime(:), showmanual(:));
plot(showtime(:), showtemperature(:), 'x');
plot(inflxr, inflyr);

xlim(range.xaxis);
ylim(range.yaxis);
  
xlabel("time (seconds)");
ylabel("temperature (°C) / process value");

% Inflection point cross lines
plot([0, max(showtime)], [infl_y, infl_y], "-.b");
inflline = plot(srange(infl_x), range.yaxis, "-.b");
inflcolor = get(inflline, "color");

% Level, X0 and Km lines
levelline = plot([0, max(showtime)], [KmY, KmY], ":r");
plot([0, max(showtime)], [X0Y, X0Y], ":r");
plot([0, max(showtime)], [LevelY, LevelY], "-r");
levelcolor = get(levelline, "color");

% Time lines
tline = plot(srange(TdeadStart), range.yaxis, "--g");
plot(srange(TdeadEnd), range.yaxis, "--g");
plot(srange(TmX), range.yaxis, "--g");
tcolor = get(tline, "color");

title(TextTitle);

% Inflection point Text
text(infltextpos.x, infltextpos.y, TextInflectionPoint, "color", inflcolor, "backgroundcolor", "white");

% Level, X0 and Km Text
text(TmX + textpm.w, KmY + textpm.h, TextKm, "color", levelcolor, "backgroundcolor", "white");
%text(TdeadStart + textpm.w, X0Y + textpm.h, TextX0, "color", levelcolor, "backgroundcolor", "white");
text(textpm.w, X0Y + textpm.h, TextX0, "color", levelcolor, "backgroundcolor", "white");

% Time Text
timespace.x = 2;
timespace.y = 10;
text(TdeadStart + timespace.x, 0, TextTdeadStart, "color", tcolor, "backgroundcolor", "white");
text(TdeadEnd + 4 * timespace.x, timespace.y, TextTdead, "color", tcolor, "backgroundcolor", "white");
text(TmX + timespace.x, 0, TextTm, "color", tcolor, "backgroundcolor", "white");
  
hold off;

endif
  

endfunction
