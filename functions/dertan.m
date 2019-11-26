function [xt,yt,t] = dertan(x, y, space = 5, next = 10, xstart = 1, xend = 0)
  lengthx = length(x);
  lengthy = length(y);
  if xend == 0
    xend = lengthx;
  endif
  xt = [];
  yt = [];
  t = [];
  i = 1;
  for a = xstart:next:xend
    aspace = a + space;
    if a <= lengthx && a <= lengthy && aspace <= lengthx && aspace <= lengthy
      x1 = x(a);
      x2 = x(aspace);
      if (x2 - x1) > 0
        xt(i) = x1;
        yt(i) = y(a);
        y2 = y(aspace);
        t(i) = (y2 - yt(i)) / (x2 - x1);
        i = i + 1;
      endif      
    endif
  endfor
endfunction
