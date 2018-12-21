function [oscFeature,freqFeature,maxFeature] = SA_getfeatures(param)

dbstop if error

%% Solve model given a parameter set
P = SA_formatparam(param);
[t, StateVar, ~] = calcium_model(P,'-showplot');
c = StateVar.c;
e = StateVar.e;
m = StateVar.m;
u = StateVar.u;

tend = t(end);

%% choose a variable to analyze
compartmentList = {c, e, m, u};

oscFeature = zeros(1,4);
freqFeature = zeros(1,4);
maxFeature = zeros(1,4);

for i = 1:numel(compartmentList)
    
    iCompartment = compartmentList{i};
    
    %% choose a time window at the end where the profile is steady
    timeWindow = 0.05*tend; 
    tplot = t(t>(t(end) - timeWindow));
    Varplot = iCompartment(t>(t(end) - timeWindow));
        
    %% find peaks for the time window
    Minpkprom = 0.1;    %[uM] min peak prominence (not to count for very small fluctuations)
    [pks, locs] = findpeaks(Varplot,'MinPeakProminence',Minpkprom);
    
    %% check if the parameter set is oscillatory
    if numel(pks)>=2
        osc = 1;
        disp('OSCILLATION FOUND')
%         figure
%         plot(t,u)
    else
        osc = 0;
    end
    
    %% if oscillatory, find frequency
    if osc
        T = tplot(locs(2)) - tplot(locs(1));    %[s] period of oscillation
        freq = 1/T; %[1/s]  frequency of oscillation
    else
        freq = 0;
    end
    
    oscFeature(i) = osc;
    freqFeature(i) = freq;
    maxFeature(i) = max(Varplot);
        
end
