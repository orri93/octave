function [Kp, Ki, Kd, Ti, Td] = zieglericholst(x0, tm, km, td, t = 2, n = 0, p = 1)
  % t = 0 : P
  % t = 1 : PI
  % t = 2 : PID
  % n = 0 : normal
  % n = 1 : LabVIEW slow
  % n = 3 : LabVIEW normal
  % n = 4 : LabVIEW fast
  
  switch (n)
    case 0
      % General
      fpkp = 1.0;
      fpikp = 0.9;
      fpiti = 3.3;
      fpidkp = 1.2;
      fpidti = 2.0;
      fpidtd = 0.5;
  case 1
      % LabVIEW slow
      fpkp = 0.26;
      fpikp = 0.24;
      fpiti = 5.33;
      fpidkp = 0.32;
      fpidti = 4.00;
      fpidtd = 0.80;
  case 2
      % LabVIEW normal
      fpkp = 0.44;
      fpikp = 0.40;
      fpiti = 5.33;
      fpidkp = 0.53;
      fpidti = 4.00;
      fpidtd = 0.80;
  case 3
      % LabVIEW fast
      fpkp = 1.0;
      fpikp = 0.90;
      fpiti = 3.33;
      fpidkp = 1.10;
      fpidti = 2.00;
      fpidtd = 0.50;      
  endswitch
    
  pidki = @(gain, ti)gain/ti;
  pidkd = @(gain, td)gain*td;
  pidti = @(kp, ki)kp/ki;
  pidtd = @(kp, kd)kd/kp;
  
  switch(t)
    case 0
      Kp = fpkp * (x0 * tm) / (km * td);
      if p == 1
        printf("Kp = %f * (X0*Tm)/(Km*Tdead) = %f\n", fpkp, Kp);
      endif
  case 1
      Kp = fpikp * (x0 * tm) / (km * td);
      Ti = fpiti * td;
      Ki = pidki(Kp, Ti);
      if p == 1
        printf("Kp = %f * (X0*Tm)/(Km*Tdead) = %f\n", fpikp, Kp);
        printf("Ti = %f * Tdead = %f\n", fpiti, Ti);
        printf("Ki = Kp / Ti) = %f\n", Ki);
      endif
    case 2
      Kp = fpidkp * (x0 * tm) / (km * td);
      Ti = fpidti * td;
      Td = fpidtd * td;
      Ki = pidki(Kp, Ti);
      Kd = pidkd(Kp, Td);     
      if p == 1
        printf("Kp = %f * (X0*Tm)/(Km*Tdead) = %f * (%f) / (%f) = %f\n", ...
          fpidkp, fpidkp, x0 * tm, km * td, Kp);
        printf("Ti = %f * Tdead = %f * %f = %f\n", ...
          fpidti, fpidti, td, Ti);
        printf("Td = %f * Tdead = %f * %f = %f\n", ...
          fpidtd, fpidtd, td, Td);
        printf("Ki = Kp / Ti = %f\n", Ki);
        printf("Kd = Kp * Td = %f\n", Kd);
      endif
  endswitch
endfunction
