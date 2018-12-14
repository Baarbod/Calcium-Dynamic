clear, clc, close all

%% Create the GUI object with a panel for the sliders
gui = CalciumGUI('Calcium GUI');
createpanel(gui)

%% Setup Sliders 
% Example: defineslider(gui,'Param Name', min, max, initial)
     
defineslider(gui,'IP3 [uM]'      ,0,1,0.47);
defineslider(gui,'Jin [uM/s]'    ,0,2,0.02*4);
defineslider(gui,'Bt [uM]'       ,0,300,220);
defineslider(gui,'K [uM]'        ,0,30,10);
defineslider(gui,'Vpmca [uM/s]'  ,0,2,0.37);
defineslider(gui,'Vip3 [1/s]'    ,0,2,0.5);
defineslider(gui,'Vserca [uM/s]' ,0,200,40);
defineslider(gui,'Vmcu [uM/s]'   ,0,4,1.45);
defineslider(gui,'Vncx [uM/s]'   ,0,100,60);
defineslider(gui,'cI'            ,0,1,0.23);
defineslider(gui,'cS'            ,0,1,0.1);
defineslider(gui,'cM'            ,0,1,0.02);
defineslider(gui,'cN'            ,0,1,0.21);
defineslider(gui,'volCt [pL]'    ,0,5,0.75);
defineslider(gui,'volER [pL]'    ,0,5,0.1);
defineslider(gui,'volMt [pL]'    ,0,5,0.05);
defineslider(gui,'volMd [pL]'    ,0,5,0.3);
defineslider(gui,'leak_eu [1/s]' ,0,1,0.02);
defineslider(gui,'leak_ec [1/s]' ,0,1,0.02);
defineslider(gui,'leak_uc [1/s]' ,0,1,0.02);
defineslider(gui,'leak_um [1/s]' ,0,1,0.02);

setsliderposition(gui)

%% Show initial simulations
addresetbutton(gui);
createplot(gui);
initstate(gui);
