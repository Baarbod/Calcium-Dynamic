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
defineslider(gui,'bt_e [uM]'       ,0,300,0);
defineslider(gui,'K_e [uM]'        ,0,30,1);
defineslider(gui,'bt_m [uM]'       ,0,300,0);
defineslider(gui,'K_m [uM]'        ,0,30,1);
defineslider(gui,'bt_u [uM]'       ,0,300,0);
defineslider(gui,'K_u [uM]'        ,0,30,1);
defineslider(gui,'Vpmca [uM/s]'  ,0,2,0.37);
defineslider(gui,'Vip3r [1/s]'   ,0,2,0.5);
defineslider(gui,'Vserca [uM/s]' ,0,200,40);
defineslider(gui,'Vmcu [uM/s]'   ,0,4,1.45);
defineslider(gui,'Vncx [uM/s]'   ,0,100,60);
defineslider(gui,'cI'            ,0,1,0.23*0);
defineslider(gui,'cS'            ,0,1,0.1*0);
defineslider(gui,'cM'            ,0,1,0.02*0);
defineslider(gui,'cN'            ,0,1,0.21*0);
defineslider(gui,'volCt [pL]'    ,0,5,0.75);
defineslider(gui,'volER [pL]'    ,0,5,0.1);
defineslider(gui,'volMt [pL]'    ,0,5,0.05);
defineslider(gui,'volMd [pL]'    ,0,5,0.3);
defineslider(gui,'leak_e_u [1/s]' ,0,1,0.02*0);
defineslider(gui,'leak_e_c [1/s]' ,0,1,0.02);
defineslider(gui,'leak_u_c [1/s]' ,0,1,0.02*0);
defineslider(gui,'leak_u_m [1/s]' ,0,1,0.02*0);

setsliderposition(gui);

formatparamlist(gui);

addresetbutton(gui);
addexportparambutton(gui);
addimportparambutton(gui);

createplot(gui);

initstate(gui);







