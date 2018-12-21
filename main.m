clear, clc, close all

%% Initial Parameter Set
% P = initparamlist;
load([pwd '\parameter_sets\pset__1'])

%% Instantiate from GUI Class
gui = CalciumGUI('Calcium GUI');

initparam(gui,P);

initgui(gui);







