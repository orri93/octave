% report script

reparrlength = length(repglobalarr)

if reparrlength > 0
  for i = 1:reparrlength
%    printf("Report no. %d with di as %d and type as %d", ...
%      i, repglobalarr(i).di, repglobalarr(i).type);
    tune191123(repglobalarr(i).di, repglobalarr(i).type, ...
      repglobalarr(i).publish, repglobalarr(i).utitle);
  endfor
else
  tune191123(repglobal.di, repglobal.type);
endif