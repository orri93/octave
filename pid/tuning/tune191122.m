function [Kp, Ki, Kd, Ti, Td] = tune191122(di = 0, type = 0, publish = 0, utitle = '')

sp.Show = 9500;
sp.Count = 9450;
sp.DownSample = 10;

% Reading from S curve
sc.LevelY = 20;            % The level value
sc.LevelX0 = 0;            % The input at the level
sc.X0Y = 85;               % The step change in the input
sc.KmY = 180;              % The Km value (leveling after the step)
sc.TdeadStart = 150;       % The start of the step
sc.InflectionI = 23;       % Inflection point index
sc.InflectionMaxY = 200;   % The maximum level for the inflection slope line

maxval.Input = 255;        % The maximum input
maxval.Value = 250;        % The maximum of the working range

% Smooth factors
smoothing.d = 2;
smoothing.stdev = 2;

raw = csvread("C:/temp/pid/november/191122.csv");
tune(raw, sp, sc, maxval, smoothing, di, type, publish, utitle);

endfunction
