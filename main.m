clear, clc, close all

%% Create the GUI object with a panel for the sliders
gui = CalciumGUI('Calcium GUI');
createpanel(gui);

%% Setup Sliders 
% Example: defineslider(gui,'Param Name', min, max, initial)
% Warning: 'Param Name' must be the same as in setparameterlist.

defineslider(gui,'ip3 [uM]'      ,0,1,0.47);
defineslider(gui,'Jin [uM/s]'    ,0,2,0.08);
defineslider(gui,'bt_c [uM]'       ,0,300,220);
defineslider(gui,'K_c [uM]'        ,0,30,10);
defineslider(gui,'bt_e [uM]'       ,0,300,220);
defineslider(gui,'K_e [uM]'        ,0,30,10);
defineslider(gui,'bt_m [uM]'       ,0,300,220);
defineslider(gui,'K_m [uM]'        ,0,30,10);
defineslider(gui,'bt_u [uM]'       ,0,300,220);
defineslider(gui,'K_u [uM]'        ,0,30,10);
defineslider(gui,'Vpmca [uM/s]'  ,0,2,0.32);
defineslider(gui,'Vip3r [1/s]'   ,0,3,0.41);
defineslider(gui,'Vserca [uM/s]' ,0,200,40);
defineslider(gui,'Vmcu [uM/s]'   ,0,4,0.65);
defineslider(gui,'Vncx [uM/s]'   ,0,100,80);
defineslider(gui,'volCt [pL]'    ,0,5,0.75);
defineslider(gui,'volER [pL]'    ,0,5,0.1);
defineslider(gui,'volMt [pL]'    ,0,5,0.05);
defineslider(gui,'volMd [pL]'    ,0,5,0.3);
defineslider(gui,'kpmca',0,3,1);
defineslider(gui,'kserca',0,1,0.2);
defineslider(gui,'kmcu',0,3,1.5);
defineslider(gui,'kncx',0,70,35);
defineslider(gui,'leak_e_u [1/s]' ,0,1,0.01);
defineslider(gui,'leak_e_c [1/s]' ,0,1,0.01);
defineslider(gui,'leak_u_c [1/s]' ,0,1,0.02);
defineslider(gui,'leak_u_m [1/s]' ,0,1,0);
defineslider(gui,'cI'            ,0,1,0.23);
defineslider(gui,'cS'            ,0,1,0.1);
defineslider(gui,'cM'            ,0,1,0.02);
defineslider(gui,'cN'            ,0,1,0.31);
defineslider(gui,'a2 [uM^-1*s^-1]',0,1,0.02);
defineslider(gui,'d1 [uM]',0,1,0.018);
defineslider(gui,'d2 [uM]',0,3,1.5);
defineslider(gui,'d3 [uM]',0,1,0.18);
defineslider(gui,'d5 [uM]',0,1,0.2);

setsliderposition(gui);

formatparamlist(gui);

addresetbutton(gui);
addexportparambutton(gui);
addimportparambutton(gui);
addfluxbutton(gui);

createplot(gui);

initstate(gui);







