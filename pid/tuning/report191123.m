function [Kp, Ki, Kd, Ti, Td] = report191123(di = 0, type = 0, outdir = '')

index = 1;
scrarr = [];
scrarr(index).di = 0;
scrarr(index).type = 0;
scrarr(index).publish = 1;
scrarr(index).utitle = "general";
index = index + 1;
scrarr(index).di = 0;
scrarr(index).type = 1;
scrarr(index).publish = -1;
scrarr(index).utitle = "slow";
index = index + 1;
scrarr(index).di = 0;
scrarr(index).type = 2;
scrarr(index).publish = -1;
scrarr(index).utitle = "normal";
index = index + 1;
scrarr(index).di = 0;
scrarr(index).type = 3;
scrarr(index).publish = -1;
scrarr(index).utitle = "fast";
index = index + 1;


repglobal.di = di;
repglobal.type = type;

options.format = "pdf";
if length(outdir) > 0
  options.outputDir = outdir;  
endif

repevcode = "repglobalarr = [];\n";
if(index > 1)
  for i = 1:index-1
    repevcode = strcat(repevcode, ...
      sprintf('repglobalarr(%d).di = %d;\nrepglobalarr(%d).type = %d;\nrepglobalarr(%d).publish = %d;\nrepglobalarr(%d).utitle="%s"\n', ...
        i, scrarr(i).di, i, scrarr(i).type, i, scrarr(i).publish, i, scrarr(i).utitle));
  endfor
else
  repevcode = sprintf("repglobal.di = %d;\nrepglobal.type = %d;\n", di, type);  
endif

options.codeToEvaluate = repevcode;

%printf(options.codeToEvaluate);

publish("report191123script.m", options); 

endfunction
