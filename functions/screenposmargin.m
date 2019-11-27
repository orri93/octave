function [position] = screenposmargin(marginx, marginy, marginr = 0, marginb = 0)
  if (marginr == 0)
      marginr = marginx;
  endif
  if (marginb == 0)
      marginb = marginy;
  endif
  position = [];
  position(1) = marginx;
  position(2) = marginb;
  screensize = get(0,"screensize");
  position(3) = screensize(3) - marginx - marginr;
  position(4) = screensize(4) - marginy - marginb;
endfunction
