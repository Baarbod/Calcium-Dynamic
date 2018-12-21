%% Perform sensitivity analysis of parameter sets.

% Description: Determines how sensistive a feature is to parameters. 

% Features: Oscillations?, Max, Min, Trend, Frequency

clear, clc, close all

%% Choose number of parameter sets to generate
nParamSet = 1000;    
paramSpan = 0.2;

%% Set parameter lower/upper bounds
P = initparamlist;
fields = fieldnames(P);
nParam = numel(fields);
for i = 1:nParam
    paramVal = P.(fields{i}).Value;
    lb.(fields{i}) = paramVal*(1 - paramSpan);
    ub.(fields{i}) = paramVal*(1 + paramSpan);
end

%% Manually change some bounds based on common sense
lb.cI = 0;
ub.cI = 1;
lb.cS = 0;
ub.cS = 1;
lb.cM = 0;
ub.cM = 1;
lb.cN = 0;
ub.cN = 1;
lb.volMd = 0.03*0.9;
ub.volMd = 0.03*1.1;

%% Create vectors of lower/upper bounds

pars_lb = zeros(1,nParam);
pars_ub = zeros(1,nParam);

for i = 1:nParam
    pars_lb(i) = lb.(fields{i});
    pars_ub(i) = ub.(fields{i});
end

%% Create parameter set array. Dimensions: [nParamSet X nParam]
X = lhsdesign(nParamSet,nParam,'criterion','correlation');      
paramSetArray = bsxfun(@plus,pars_lb,bsxfun(@times,X,(pars_ub-pars_lb)));   

%% Find features of each parameter set

CompartmentNames = {'Ct','Er','Mt','Md'};
nCompartment = numel(CompartmentNames);

oscillatory = zeros(nParamSet,nCompartment);
frequency = zeros(nParamSet,nCompartment);
maximum = zeros(nParamSet,nCompartment);
% minimum = zeros(nParamSet,nCompartment);

oscmat = zeros(nParamSet,1);

tic
% f = waitbar(0,'Finding features of each parameter set...');
parfor i = 1:nParamSet
    try
        [oscFeature,freqFeature,maxFeature] = ...
            SA_getfeatures(paramSetArray(i,:));
    catch
        fprintf("Problem in parameter set: %i\n",i)
        continue
    end
     
    oscillatory(i,:) = oscFeature;
    frequency(i,:) = freqFeature;
    maximum(i,:) = maxFeature;
    
%     waitbar(i/nParamSet,f)
end
% close(f)
toc

save('SA_output','oscillatory','frequency','maximum',...
    'paramSetArray','pars_lb','pars_ub')

%% Keep param sets that have oscillations in all four compartments
Data = load('SA_output');
paramSetArrayFiltered = SA_filterparamset(Data);

%% Loop through parameter sets to visualize them

[nParamSetFiltered,~] = size(paramSetArrayFiltered);
for i = 1:nParamSetFiltered
    clf
    P = SA_formatparamset(paramSetArrayFiltered(i,:));
    [~,~,~] = calcium_model(P,'-showplot','-usesubplot');
    figName = ['Parameter Set: ' num2str(i)];
    fig = gcf; fig.Name = figName;
    pause
end











