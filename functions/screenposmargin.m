function [position] = screenposmargin(mw, mh)
  position = [];
  position(1) = mw;
  position(2) = mh;
  screensize = get(0,"screensize");
  position(3) = screensize(3) - 2 * mw;
  position(4) = screensize(4) - 2 * mh;
endfunction
