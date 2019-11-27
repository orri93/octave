%
% options.outputDir = "C:\temp\octave-output"
% options.format = "pdf";
% publish("testpublish.m", options); 
%


printf("PID tuning\n");


x = 0:0.1:pi;
y = sin(x)
figure(1)
plot(x,y);
figure(2)
plot(x,y.^2);

printf("x at 0 is %f\n", x(1));
