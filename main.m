clear, clc, close all

gui = GuiInterface([200,200,500,400],'Calcium GUI');

gui = addslider(gui,'IP3 [uM]',0,1,0.47);
gui = addslider(gui,'Jin [uM/s]',0,2,0.02*4);
gui = addslider(gui,'Bt [uM]',0,300,220);
gui = addslider(gui,'K [uM]',0,30,10);
gui = addslider(gui,'Vpmca [uM/s]',0,2,0.37);
gui = addslider(gui,'Vip3 [1/s]',0,2,0.5);
gui = addslider(gui,'Vserca [uM/s]',0,200,40);
gui = addslider(gui,'Vmcu [uM/s]',0,4,1.45);
gui = addslider(gui,'Vncx [uM/s]',0,100,60);
gui = addslider(gui,'cI',0,1,0.23);
gui = addslider(gui,'cS',0,1,0.1);
gui = addslider(gui,'cM',0,1,0.02);
gui = addslider(gui,'cN',0,1,0.21);

gui = addresetbutton(gui);
gui = createplot(gui);
gui = initstate(gui);
