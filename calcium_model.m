function [t, StateVar, NonStateVar] = calcium_model(varargin)
% Input Options:
%   -showcompartmentplot
%   -showchannelplot 

nOpt = 0;
modelOptions = {};
for i = 1:length(varargin)
    if ischar(varargin{i}) && varargin{i}(1) == '-'
        nOpt = nOpt + 1;
        modelOptions{nOpt} = varargin{i}(2:end);
        varargin{i} = [];
    end
end

varargin( cellfun( @isempty, varargin ) ) = [];

if isempty(varargin)
    P = setparameterlist({},[]);
elseif isstruct(varargin{1})
    P = varargin{1};
end

volCt = P.volCt.Value;      % [pL] volume cytosol
volMd = P.volMd.Value;      % [pL] volume microdomain
volER = P.volER.Value;      % [pL] volume ER
volMt = P.volMt.Value;      % [pL] volume mitocondria
Jin = P.Jin.Value;          % [uM/s] flux into cytosol
Vpmca = P.Vpmca.Value;      % [uM/s] max membrane efflux of PMCA
kpmca = P.kpmca.Value;      % [uM] efflux half max constant for PMCA
Vip3r = P.Vip3r.Value;      % [1/s] max flux of IP3R
Vserca = P.Vserca.Value;    % [uM/s] max flux of SERCA pump
kserca = P.kserca.Value;    % [uM] activation constant for SERCA pump
ip3 = P.ip3.Value;          % [uM] IP3 in the cytosol
a2 = P.a2.Value; % [uM^-1*s^-1] IP3R binding rate ca inhibition sites
d1 = P.d1.Value; % [uM] IP3R dissociation constant for IP3 sites
d2 = P.d2.Value; % [uM] IP3R dissociation constant for ca inhibition sites
d3 = P.d3.Value; % [uM] IP3R dissociation constant for IP3 sites
d5 = P.d5.Value; % [uM] IP3R dissociation constant for ca activation sites
Vmcu = P.Vmcu.Value;        % [uM/s] max rate of ca uptake by MCU
kmcu = P.kmcu.Value;        % [uM] half-max rate of ca pumping from c to m
Vncx = P.Vncx.Value;        % [uM/s] max rate of ca release through NCX
kncx = P.kncx.Value;        % [uM] activation constant for NCX
kna = P.kna.Value;          % [mM] Na activation constant for MCU
N = P.N.Value;              % [mM] Na in cytosol
N_u = P.N_u.Value;          % [mM] Na in microdomain
leak_e_u = P.leak_e_u.Value; % [1/s] leak constant from ER to Md
leak_e_c = P.leak_e_c.Value; % [1/s] leak constant from ER to Ct
leak_u_c = P.leak_u_c.Value; % [1/s] leak constant from Md to Ct
leak_u_m = P.leak_u_m.Value; % [1/s] leak constant from Md to Mt
cI = P.cI.Value;            % fraction of IP3R facing microdomain
cS = P.cS.Value;            % fraction of SERCA facing microdomain
cM = P.cM.Value;            % fraction of MCU facing microdomain
cN = P.cN.Value;            % fraction of mNCX facing microdomain
bt_c = P.bt_c.Value;      % [uM] total buffer concentration in cytosol
K_c = P.K_c.Value;        % buffer rate constant ratio (Qi 2015)
bt_e = P.bt_e.Value;      % [uM] total buffer concentration in ER
K_e = P.K_e.Value;        % buffer rate constant ratio (Qi 2015)
bt_m = P.bt_m.Value;      % [uM] total buffer concentration in mitocondria
K_m = P.K_m.Value;        % buffer rate constant ratio (Qi 2015)
bt_u = P.bt_u.Value;      % [uM] total buffer concentration in micro-domain
K_u = P.K_u.Value;        % buffer rate constant ratio (Qi 2015)


%% Time
tstart = 0; % [s]
tend = 1500; % [s]
tstep = 0.1; % [s]

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
M = zeros(length(initStateVar),length(initStateVar));
options = odeset;
options.Mass = M;
options.MassSingular = 'yes';


tspan = tstart:tstep:tend;
[t,X] = ode15s(@equations,tspan,X0);

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


%% Plot Cytosol
if ismember('showcompartmentplot',modelOptions)
    fields = fieldnames(StateVar);
    for i = 1:numel(fields)
        figure
        VarXaxis = t;
        VarYaxis = StateVar.(fields{i});
        h = plot(VarXaxis,VarYaxis);
        h.LineWidth = 1.5;
        h.Color = 'b';
        
        fig = gcf;
        fig.Color = 'w';
        
        ax = gca;
        ax.FontWeight = 'bold';
        ax.FontName = 'Times New Roman';
        ax.FontSize = 10;
        ax.Title.String = ["Compartment: " fields{i}];
        ax.Title.FontSize = 18;
        ax.AmbientLightColor = 'magenta';
        ax.LineWidth = 1.5;
        ax.XAxis.Label.String = 'Time (sec)';
        ax.YAxis.Label.String = '[Ca] \muM';
    end
end

if ismember('showchannelplot',modelOptions)
    fields = fieldnames(NonStateVar);
    for i = 1:numel(fields)
        figure
        VarXaxis = t;
        VarYaxis = NonStateVar.(fields{i});
        h = plot(VarXaxis,VarYaxis);
        h.LineWidth = 1.5;
        h.Color = 'b';
        
        fig = gcf;
        fig.Color = 'w';
        
        ax = gca;
        ax.FontWeight = 'bold';
        ax.FontName = 'Times New Roman';
        ax.FontSize = 10;
        ax.Title.String = ["Channel: " fields{i}];
        ax.Title.FontSize = 18;
        ax.AmbientLightColor = 'magenta';
        ax.LineWidth = 1.5;
        ax.XAxis.Label.String = 'Time (sec)';
        ax.YAxis.Label.String = '[Ca] \muM';
    end
end

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
        nsJip3r = X(7);
        nsJip3r_u = X(8);
        nsJserca = X(9);
        nsJserca_u = X(10);
        nsJncx = X(11);
        nsJncx_u = X(12);
        nsJmcu = X(13);
        nsJmcu_u = X(14);
        nsJleak_u_c = X(15);
        nsJleak_u_m = X(16);
        nsJleak_e_u = X(17);
        nsJleak_e_c = X(18);
        nsJin = X(19);
        nsJpmca = X(20);
        
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
        Jin = Jin;

        % PMCA
        Jpmca = Vpmca*c/(kpmca + c);
        
        % h
        ah = a2*d2*(ip3 + d1)/(ip3 + d3);
        bh = a2*c;
        
        % h_u
        bh_u = a2*u;
        
        % buffering
        theta_c = bt_c*K_c/((K_c + c)^2); % buffer factor
        theta_e = bt_e*K_e/((K_e + e)^2); % buffer factor
        theta_m = bt_m*K_m/((K_m + m)^2); % buffer factor
        theta_u = bt_u*K_u/((K_u + u)^2); % buffer factor
        
        %% Compute State Variables
        dcdt = (Jin + Jip3r + Jleak_u_c + Jleak_e_c + Jncx ...
            - Jpmca - Jserca - Jmcu)/(1 + theta_c);
        
        dedt = (volCt/volER*(Jserca + Jserca_u ...
            - Jip3r - Jip3r_u - Jleak_e_u - Jleak_e_c))/(1 + theta_e);
        
        dmdt = (volCt/volMt*(Jmcu + Jmcu_u + Jleak_u_m ...
            - Jncx - Jncx_u))/(1 + theta_m);
        
        dudt = (volCt/volMd*(Jip3r_u + Jncx_u + Jleak_e_u ...
            - Jserca_u - Jmcu_u - Jleak_u_m - Jleak_u_c))/(1 + theta_u);
        
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
        dXdt(7) = Jip3r - nsJip3r;
        dXdt(8) = Jip3r_u - nsJip3r_u;
        dXdt(9) = Jserca - nsJserca;
        dXdt(10) = Jserca_u - nsJserca_u;
        dXdt(11) = Jncx - nsJncx;
        dXdt(12) = Jncx_u - nsJncx_u;
        dXdt(13) = Jmcu - nsJmcu;
        dXdt(14) = Jmcu_u - nsJmcu_u;
        dXdt(15) = Jleak_u_c - nsJleak_u_c;
        dXdt(16) = Jleak_u_m - nsJleak_u_m;
        dXdt(17) = Jleak_e_u - nsJleak_e_u;
        dXdt(18) = Jleak_e_c - nsJleak_e_c;
        dXdt(19) = Jin - nsJin;
        dXdt(20) = Jpmca - nsJpmca;
        
    end
end

