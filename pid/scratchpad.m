raw = csvread("C:/temp/pid/november/latest.csv");

data_end = 10000;
sample_start = 35;
sample_size = 64;
prefix_count = 10;

flatdata = prefixflat(raw, sample_start, sample_size, prefix_count, data_end);
rowcount = rows(flatdata);
csvwrite("C:/temp/pid/november/preflat.csv", flatdata, ",")

y1 = 180;
y2 = y1 / 2;

time = [];
temperature = [];
manual = [];
yline1 = [];
yline2 = [];
for i = 1:rowcount
  time(i) = flatdata(i,1);
  temperature(i) = flatdata(i,2);
  manual(i) = flatdata(i,3);
  yline1(i) = y1;
  yline2(i) = y2;
endfor

#[linx, liny] = fit(time, temperature);

order = 6;
pf = polyfit(time, temperature, order);
pfx = linspace (min(time), max(time), 101);
pfy = polyval (pf, pfx);

lc = 100;
lxa = 200;
lxe = 700;

m = 0.35;
maxy = 200;
imppx = 500;
imppy = y2;
implb = linethrougth(imppx, imppy, m);

lx = [];
ly = [];
lindex = 1;
for i = 1:lc
  lya = line(lxa, m, implb);
  if (lya > 0 & lya < maxy)
    lx(lindex) = lxa;
    ly(lindex) = line(lxa, m, implb);
    lindex = lindex + 1;
  endif
  lxa = lxa + (lxe - lxa) / lc;
endfor

hold on;
plot(time(:), temperature(:));
plot(time(:), manual(:));
plot(time(:), yline1(:));
plot(time(:), yline2(:));
#plot(linx(:), liny(:));
plot(lx, ly);
plot(pfx, pfy);
title("Time vs temperature graph");
ylabel("temperature (°C)");
xlabel("time (s)");
xlim([0 max(time)])
#legend("Temperature", "Manual");
hold off;