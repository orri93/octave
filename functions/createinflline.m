function [infllinex, inflliney] = createinflline(x1, x2, m, b, miny, maxy, space = 1)
  infllinex = [];
  inflliney = [];
  i = 1;
  for x = x1:space:x2
    y = inflline(x, m, b);
    if(y >= miny && y <= maxy)
      infllinex(i) = x;
      inflliney(i) = y;
      i = i + 1;
    endif  
  endfor
endfunction
