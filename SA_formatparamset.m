function P = SA_formatparamset(param)

% Description: turns a param set from the SA and turns it into the 
% parameter structure needed for the model.

% INPUT: param must be a row vector with parameter values, such that the
% order it is in matches the order that the P structure is in from
% the "initparamlist" function.

baseP = initparamlist;
names = fieldnames(baseP);
nParam = numel(names);

for i = 1:nParam
    baseP.(names{i}).Value = param(i);
end

P = baseP;

