function SA_saveparamset(Data,row)

% Description: saves chosen parameter sets 
% Input: file - must be SA_output loaded into a structure
%        row  - row indicies of filtered paramset array to save

path = uigetdir(pwd,'Select path for output');

[paramSetArrayFiltered,ind] = SA_filterparamset(Data);
maximumFiltered = Data.maximum(ind,:);


for i = 1:numel(row)
    irow = row(i);
    cMax = num2str(maximumFiltered(irow,1));
    eMax = num2str(maximumFiltered(irow,2));
    mMax = num2str(maximumFiltered(irow,3));
    uMax = num2str(maximumFiltered(irow,4));
    P = SA_formatparamset(paramSetArrayFiltered(irow,:));
    name = ['pset__Ct_' cMax '_Er_' eMax '_Mt_' mMax '_Md_' uMax '.mat'];
%     name = ['pset__' num2str(i)];
    save([path '\' name],'P')
end
