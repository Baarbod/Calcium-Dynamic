function [paramSetArrayWithOsc,ind] = SA_filterparamset(Data)

% Description: function takes a parameter set array generated from the 
% SA_main script and filters the parameter sets based on desired features.

paramSetArray = Data.paramSetArray;
oscillatory = Data.oscillatory;

nParamSet = length(paramSetArray);
ind = zeros(nParamSet,1);

for i = 1:nParamSet
    oscSum = sum(oscillatory(i,:));
    oscCondition = oscSum == 4;
    
    if ~oscCondition
        paramSetArray(i,:) = 0;
    else
        ind(i) = i;
    end
    
end

ind = ind(any(paramSetArray,2),:);
paramSetArrayWithOsc = paramSetArray(any(paramSetArray,2),:);