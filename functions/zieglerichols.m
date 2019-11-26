function [P, PI, PID] = zieglerichols(L, T)
  pidki = @(gain, ti)gain/ti;
  pidkd = @(gain, td)gain*td;
  pidti = @(kp, ki)kp/ki;
  pidtd = @(kp, kd)kd/kp;

  P.Kp = T/L;
  PI.Kp = 0.9 * T / L;
  PI.Ti = L / 0.3;
  PI.Ki = pidki(PI.Kp, PI.Ti);
  
  PID.Kp = 1.2 * T / L;
  PID.Ti = 2 * L;
  PID.Td = 0.5 * L;
  PID.Ki = pidki(PID.Kp, PID.Ti);
  PID.Kd = pidkd(PID.Kp, PID.Td);
endfunction
