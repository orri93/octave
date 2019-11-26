%
%
% See 
% https://www.mathworks.com/matlabcentral/answers/333484-curve-fitting-to-step-and-impulse-response

pidki = @(gain, ti)gain/ti;
pidkd = @(gain, td)gain*td;
pidti = @(kp, ki)kp/ki;
pidtd = @(kp, kd)kd/kp;

%
show = 9500;
count = 9450;
downsamplesize = 10;

% PID
levely = 20;
ky = 180;
lstart = 130;

% Inflection point
infl_i = 26;

% tangen
%infl_t = 0.2;

% Smooth
smooth_d = 2;
smooth_stdev = 2;

% Moving RMS
mrms_width = 0.05;
mrms_rc = 5e-3;

%pkg load data-smoothing;
pkg load signal;
pkg load data-smoothing;

raw = csvread("C:/temp/pid/november/191122.csv");
rawtime = calculatetime(raw);

showmanual = raw(1:show,3);
showtemperature = raw(1:show,4);
showtime = rawtime(1:show);

manual = downsample(raw(1:count,3), downsamplesize);
time = downsample(rawtime(1:count), downsamplesize);
temperature = downsample(raw(1:count,4), downsamplesize);

[yh, lambda] = regdatasmooth(time, temperature, "d", smooth_d, "stdev", smooth_stdev, "midpointrule");

[xt, yt, dt] = dertan(time, yh, 3, 6);

lxt = length(xt)
lyt = length(xt)
ldt = length(xt)

infl_x = xt(infl_i);
infl_y = yt(infl_i);
infl_t = dt(infl_i);

infl_line_b = linethrougth(infl_x, infl_y, infl_t);
[inflxr, inflyr] = createinflline(0, max(showtime), infl_t, infl_line_b, 0, max(temperature), 5);

tline = revinflline(ky, infl_t, infl_line_b);
lend = revinflline(levely, infl_t, infl_line_b);



close all;
figure(1,"position",get(0,"screensize"));
hold on;
%plot(time(:), temperature(:));
%plot(time(:), manual(:));
%plot(showtime(:), showtemperature(:));
plot(time, yh);
plot(showtime(:), showmanual(:));
plot(time, temperature, 'x');
%plot(time, mrms);
plot(inflxr, inflyr);
vline(lstart);
hline(levely);
hline(ky);
vline(infl_x);
hold off;
vline(lend);
vline(tline);
hline(infl_y);
xlim([0 max(time)]);
ylim([0 max(temperature)]);
hold off;

L = lend - lstart;
T = tline - lend;

L
T

[P, PI, PID] = zieglerichols(L,T);

P
PI
PID


return

count = 4000

linely = [];
line1x = linspace (min(time), max(time), 100);
for i = 1:length(line1x)
  linely(i) = 100
endfor



#hold on;
#plot(time(:), temperature(:));
#plot(time(:), manual(:));
#plot(time(:), yline1(:));
#plot(time(:), yline2(:));
#plot(linx(:), liny(:));
#plot(lx, ly);
#plot(pfx, pfy);
#title("Time vs temperature graph");
#ylabel("temperature (°C)");
#xlabel("time (s)");
#xlim([0 max(time)])
#legend("Temperature", "Manual");
#hold off;