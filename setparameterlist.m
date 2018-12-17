function P = setparameterlist(sliderparamname,sliderparamvalue)

AllParamNameList = {'volCt','volMd','volER','volMt','Jin','Vpmca','kpmca',...
    'Vip3r','Vserca','kserca','ip3','a2','d1','d2','d3','d5','Vmcu',...
    'kmcu','Vncx','kncx','kna','N','N_u','leak_e_u','leak_e_c','leak_u_c',...
    'leak_u_m','cI','cS','cM','cN','bt_c','K_c','bt_e','K_e',...
    'bt_m','K_m','bt_u','K_u'}';

% AllParamNameList = {'volCt','volMd','volER','volMt','Vpmca','kpmca',...
%     'Vip3r','Vserca','kserca','ip3','a2','d1','d2','d3','d5','Vmcu',...
%     'kmcu','Vncx','kncx','kna','N','N_u','leak_e_u','leak_e_c','leak_u_c',...
%     'leak_u_m','cI','cS','cM','cN','bt_c','K_c','bt_e','K_e',...
%     'bt_m','K_m','bt_u','K_u'}';

nAllParam = numel(AllParamNameList);

%% Base Values
PBase.volCt.Value = 0.75;
PBase.volMd.Value = 0.1; 
PBase.volER.Value = 0.1; 
PBase.volMt.Value = 0.09; 
PBase.Jin.Value = 0.08; 
PBase.Vpmca.Value = 0.37;
PBase.kpmca.Value = 1; 
PBase.Vip3r.Value = 0.5; 
PBase.Vserca.Value = 40; 
PBase.kserca.Value = 0.2; 
PBase.ip3.Value = 0.47; 
PBase.a2.Value = 0.02;
PBase.d1.Value = 0.018; 
PBase.d2.Value = 1.5; 
PBase.d3.Value = 0.18; 
PBase.d5.Value = 0.2; 
PBase.Vmcu.Value = 1.45; 
PBase.kmcu.Value = 1.5;
PBase.Vncx.Value = 60; 
PBase.kncx.Value = 35; 
PBase.kna.Value = 9.4; 
PBase.N.Value = 10; 
PBase.N_u.Value = 10;
PBase.leak_e_u.Value = 0.02; 
PBase.leak_e_c.Value = 0.02; 
PBase.leak_u_c.Value = 0.02; 
PBase.leak_u_m.Value = 0.02; 
PBase.cI.Value = 0.8;
PBase.cS.Value = 0.1; 
PBase.cM.Value = 0.8; 
PBase.cN.Value = 0.1;
PBase.bt_c.Value = 220;
PBase.K_c.Value = 10; 
PBase.bt_e.Value = 220;
PBase.K_e.Value = 10; 
PBase.bt_m.Value = 220;
PBase.K_m.Value = 10; 
PBase.bt_u.Value = 220;
PBase.K_u.Value = 10; 


%% Make sure param values are in correct position
a = fieldnames(PBase);

if ~isequal(a,AllParamNameList)
    error("Warning: parameter values and name position mismatch")
end

%% Check and set parameters controlled by GUI sliders

for i = 1:nAllParam
    paramName = AllParamNameList{i};
    [bool,ind] = ismember(paramName,sliderparamname);
    if ~bool
        P.(paramName).ControlledBySlider = 'no';
        P.(paramName).Value = PBase.(paramName).Value;
    elseif bool 
        P.(paramName).ControlledBySlider = 'yes';
        P.(paramName).Value = sliderparamvalue(ind);
    end
end
    
