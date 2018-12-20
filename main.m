clear, clc, close all

gui = CalciumGUI('Calcium GUI');

[pinit,pname,punit,pvalue] = makePstruc();

initstate(gui,pinit,pname,punit,pvalue);

initgui(gui)







