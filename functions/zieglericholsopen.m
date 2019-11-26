function [P, PI, PID] = zieglericholsopen(L, R, U)
  pidki = @(gain, ti)gain/ti;
  pidkd = @(gain, td)gain*td;
  pidti = @(kp, ki)kp/ki;
  pidtd = @(kp, kd)kd/kp;

  P.Kp = 1/(L*R/U);
  
  PI.Kp = 0.9 / (L * R / U);
  PI.Ti = 3.3 * L;
  PI.Ki = pidki(PI.Kp, PI.Ti);
  
  PID.Kp = 1.2 * (L * R / U);
  PID.Ti = 2 * L;
  PID.Td = 0.5 * L;
  PID.Ki = pidki(PID.Kp, PID.Ti);
  PID.Kd = pidkd(PID.Kp, PID.Td);
endfunction
