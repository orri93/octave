function [Kp, Ki, Kd, Ti, Td] = tune191123(di = 0, type = 0, publish = 0, utitle = '')
%
% Ziegler-Nichols’ Open-Loop Method
%

% di       : delta i
% type     : 0 is general, 1 is LabVIEW slow, 2 is LabVIEW normal and 3 is LabVIEW fast

%clc;

addpath("C:/home/orri/src/octave/functions/");
addpath("C:/home/orri/src/octave/pid/tuning/");

%
sp.Show = 7000;
sp.Count = 4300;
sp.DownSample = 10;

% Reading from S curve
sc.LevelY = 24;            % The level value
sc.LevelX0 = 0;            % The input at the level
sc.X0Y = 39;               % The step change in the input
sc.KmY = 130;              % The Km value (leveling after the step)
sc.TdeadStart = 129;       % The start of the step
sc.InflectionI = 13;       % Inflection point index
sc.InflectionMaxY = 150;   % The maximum level for the inflection slope line

maxval.Input = 255;        % The maximum input
maxval.Value = 250;        % The maximum of the working range

% Smooth factors
smoothing.d = 2;
smoothing.stdev = 1;

raw = csvread("C:/temp/pid/november/191123.csv");
tune(raw, sp, sc, maxval, smoothing, di, type, publish, utitle);

endfunction
