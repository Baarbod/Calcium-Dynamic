function [t, StateVar, NonStateVar] = calcium_model(param)

ip3 = param(1);
B = param(2);
bt = param(3);
K = param(4);
Vpmca = param(5);
Vip3r = param(6);
Vserca = param(7);
Vmcu = param(8);
Vncx = param(9);
cI = param(10);
cS = param(11);
cM = param(12);
cN = param(13);
volCt = param(14);
volER = param(15);
volMt = param(16);
volMd = param(17);
leak_e_u = param(18);
leak_e_c = param(19);
leak_u_c = param(20);
leak_u_m = param(21);

%% Time
tstart = 0; % [s]
tend = 1500; % [s]
tstep = 0.1; % [s]

%% Cytosol Parameters
% volCt = 1.5/2; % [pL] volume cytosol
% B = 0.02*4*0; % [uM/s] flux into cytosol
% Vpmca = 0.37; % [uM/s] max membrane efflux of PMCA
kpmca = 1; % [uM] efflux half max constant for PMCA

%% ER Parameters
% volER = 0.3/3; % [pL] volume ER
% Vip3r = 0.5; % [1/s] max flux of IP3R
% Vserca = 40; % [uM/s] max flus of SERCA pump
kserca = 0.2; % [uM] activation constant for SERCA pump
% ip3 = 0.56; % [uM] IP3 in the cytosol
a2 = 0.02; % [uM^-1*s^-1 IP3R binding rate constant for ca inhibition sites
d1 = 0.018; % [uM] IP3R dissociation constant for IP3 sites
d2 = 1.5; % [uM] IP3R dissociation constant for ca inhibition sites
d3 = 0.18; % [uM] IP3R dissociation constant for IP3 sites
d5 = 0.2; % [uM] IP3R dissociation constant for ca activation sites

%% Mitocondria Parameters
% volMt = 0.45/5; % [pL] volume mitocondria
% Vmcu = 1.45; % [uM/s] max rate of ca uptake by MCU
kmcu = 1.5; % [uM] half-max rate of ca pumping from cytosol to mitocondria
% Vncx = 60; % [uM/s] max rate of ca release through NCX
kncx = 35; % [uM] activation constant for NCX
kna = 9.4; % [mM] Na activation constant for MCU
N = 10; % [mM] Na in cytosol

%% Leak Parameters
% leak_e_u = 0.02; % [1/s] leak constant from ER to microdomain
% leak_e_c = 0.02; % [1/s] leak constant from ER to microdomain
% leak_u_c = 0.02; % [1/s] leak constant from ER to microdomain
% leak_u_m = 0.02; % [1/s] leak constant from ER to microdomain

%% Microdomain Parameters
% cI = 0.8; % fraction of IP3R facing microdomain
% cS = 0.1; % fraction of SERCA facing microdomain
% cM = 0.8; % fraction of MCU facing microdomain
% cN = 0.1; % fraction of mNCX facing microdomain
% volMd = 0.3/3; % [pL]

%% Buffer Parameters
% bt = 220; % [uM] total buffer concentration in cytosol
% K = 10; % buffer rate constant ratio (Qi 2015)

%% Microdomain parameters
N_u = 10; % [mM] Na in microdomain

%% Initial Conditions
% cInit = 0.1; % [uM]
% eInit = 400; % [uM]
% mInit = 0.2; % [uM]
% uInit = 0.1; % [uM]
% hInit = 0.9;
% h_uInit = 0.9;
% X0 = [cInit;eInit;mInit;uInit;hInit;h_uInit];
% X0 = fsolve(@(X) equations(0,X), X0);

initStateVar = [0.3;180;0.07;180;0.7;0.7];
initNonStatVar = zeros(14,1);
X0 = [initStateVar;initNonStatVar];

%% Solve
tspan = tstart:tstep:tend;
[t,X] = ode45(@equations,tspan,X0);

%% Assign solutions to output variables

% State Variables
c = X(:,1);
e = X(:,2);
m = X(:,3);
u = X(:,4);
h = X(:,5);
h_u = X(:,6);

% Non-State Variables
Jip3r = X(:,7);
Jip3r_u = X(:,8);
Jserca = X(:,9);
Jserca_u = X(:,10);
Jncx = X(:,11);
Jncx_u = X(:,12);
Jmcu = X(:,13);
Jmcu_u = X(:,14);
Jleak_u_c = X(:,15);
Jleak_u_m = X(:,16);
Jleak_e_u = X(:,17);
Jleak_e_c = X(:,18);
Jin = X(:,19);
Jpmca = X(:,20);

% State Variables
StateVar.c = c;
StateVar.e = e;
StateVar.m = m;
StateVar.u = u;

% Non-State Variables
NonStateVar.Jip3r = Jip3r;
NonStateVar.Jip3r_u = Jip3r_u;
NonStateVar.Jserca = Jserca;
NonStateVar.Jserca_u = Jserca_u;
NonStateVar.Jncx = Jncx;
NonStateVar.Jncx_u = Jncx_u;
NonStateVar.Jmcu = Jmcu;
NonStateVar.Jmcu_u = Jmcu_u;
NonStateVar.Jleak_u_c = Jleak_u_c;
NonStateVar.Jleak_u_m = Jleak_u_m;
NonStateVar.Jleak_e_u = Jleak_e_u;
NonStateVar.Jleak_e_c = Jleak_e_c;
NonStateVar.Jin = Jin;
NonStateVar.Jpmca = Jpmca;


%% Setup differential equations to be solved using ODE solver

    function dXdt = equations(t,X)
        
        %% Assign State Variables
        c = X(1);
        e = X(2);
        m = X(3);
        u = X(4);
        h = X(5);
        h_u = X(6);
        
        %% Assign Non-State Variables
        Jip3r = X(7);
        Jip3r_u = X(8);
        Jserca = X(9);
        Jserca_u = X(10);
        Jncx = X(11);
        Jncx_u = X(12);
        Jmcu = X(13);
        Jmcu_u = X(14);
        Jleak_u_c = X(15);
        Jleak_u_m = X(16);
        Jleak_e_u = X(17);
        Jleak_e_c = X(18);
        Jin = X(19);
        Jpmca = X(20);
        
        %% Compute Non-State Variables
        % IP3R
        sact = h*((ip3/(ip3 + d1)) * c/(c + d5));
        Poip3r = sact^4 + 4*sact^3*(1 - sact);
        Jip3r = (1 - cI)*(Vip3r*Poip3r)*(e - c);
        
        % IP3R_u
        sact_u = h*((ip3/(ip3 + d1)) * u/(u + d5));
        Poip3r_u = sact_u^4 + 4*sact_u^3*(1 - sact_u);
        Jip3r_u = cI*(Vip3r*Poip3r_u)*(e - u);
        
        % SERCA
        Jserca = (1 - cS)*Vserca*c^2/(kserca^2 + c^2);
        
        % SERCA_u
        Jserca_u = cS*Vserca*u^2/(kserca^2 + u^2);
        
        % mNCX
        Jncx = (1 - cN)*Vncx*(N^3/(kna^3 + N^3))*(m/(kncx + m));
        
        % mNCX_u
        Jncx_u = cN*Vncx*(N_u^3/(kna^3 + N_u^3))*(m/(kncx + m));
        
        % MCU
        Jmcu = (1 - cM)*Vmcu*(c^2/(kmcu^2 + c^2));
        
        % MCU_u
        Jmcu_u = cM*Vmcu*(u^2/(kmcu^2 + u^2));
        
        % leaks
        Jleak_u_c = leak_u_c*(u - c);
        Jleak_u_m = leak_u_m*(u - m);
        Jleak_e_u = leak_e_u*(e - u);
        Jleak_e_c = leak_e_c*(e - c);
        
        % Influx
        Jin = B;
        
        % PMCA
        Jpmca = Vpmca*c/(kpmca + c);
        
        % h
        ah = a2*d2*(ip3 + d1)/(ip3 + d3);
        bh = a2*c;
        
        % h_u
        bh_u = a2*u;
        
        % buffering
        theta = bt*K/((K + c)^2); % buffer factor
        
        %% Compute State Variables
        dcdt = (Jin + Jip3r + Jleak_u_c + Jleak_e_c + Jncx ...
            - Jpmca - Jserca - Jmcu)/(1 + theta);
        
        dedt = volCt/volER*(Jserca + Jserca_u ...
            - Jip3r - Jip3r_u - Jleak_e_u - Jleak_e_c);
        
        dmdt = volCt/volMt*(Jmcu + Jmcu_u + Jleak_u_m ...
            - Jncx - Jncx_u);
        
        dudt = volCt/volMd*(Jip3r_u + Jncx_u + Jleak_e_u ...
            - Jserca_u - Jmcu_u - Jleak_u_m - Jleak_u_c);
        
        dhdt = ah*(1 - h) - bh*h;
        
        dh_udt = ah*(1 - h_u) - bh_u*h_u;
        
        %% Assign equations to function output
        dXdt = zeros(numel(X),1);
        
        % State Variables
        dXdt(1) = dcdt;
        dXdt(2) = dedt;
        dXdt(3) = dmdt;
        dXdt(4) = dudt;
        dXdt(5) = dhdt;
        dXdt(6) = dh_udt;
        
        % Non-State Variables
        dXdt(7) = Jip3r;
        dXdt(8) = Jip3r_u;
        dXdt(9) = Jserca;
        dXdt(10) = Jserca_u;
        dXdt(11) = Jncx;
        dXdt(12) = Jncx_u;
        dXdt(13) = Jmcu;
        dXdt(14) = Jmcu_u;
        dXdt(15) = Jleak_u_c;
        dXdt(16) = Jleak_u_m;
        dXdt(17) = Jleak_e_u;
        dXdt(18) = Jleak_e_c;
        dXdt(19) = Jin;
        dXdt(20) = Jpmca;
        
    end
end

