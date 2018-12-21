function SA_saveparamset(Data,row)

% Description: saves chosen parameter sets 
% Input: file - must be SA_output loaded into a structure
%        row  - row indicies of filtered paramset array to save

path = uigetdir(pwd,'Select path for output');

paramSetArrayFiltered = SA_filterparamset(Data);
% maximum = Data.maximum;


for i = 1:numel(row)
    irow = row(i);
%     cMax = num2str(maximum(irow,1));
%     eMax = num2str(maximum(irow,2));
%     mMax = num2str(maximum(irow,3));
%     uMax = num2str(maximum(irow,4));
    P = SA_formatparamset(paramSetArrayFiltered(irow,:));
%     name = ['pset__Ct_' cMax '_Er_' eMax '_Mt_' mMax '_Md_' uMax '.mat'];
    name = ['pset__' num2str(i)];
    save([path '\' name],'P')
end
