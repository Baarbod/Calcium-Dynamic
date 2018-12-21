%% Find Partial Correlation and show bar char

% load SA_output

%%
X = [paramSetArray, oscillatory(:,1)];
[rho,pval] = partialcorr(X);
% rows = find(oscillatory(:,1));
% x_new = X(rows, :);
% [rho,pval] = partialcorr(x_new);
coeffs = rho(:,end); coeffs(end) = [];
p_vals = pval(:,end); p_vals(end) = [];
x = 1:numel(coeffs);
y = coeffs;
z = p_vals;

figure, h = bar(x, coeffs);    ax = gca;
for jj =1:numel(y)
    h1 = text(x(jj),y(jj),num2str(z(jj),'%0.2g'),...
        'HorizontalAlignment','center',...
        'VerticalAlignment','bottom');
    h1.FontSize = 10; h1.FontWeight = 'bold'; h1.FontName = 'times new roman';
    if z(jj)>0.05
        h1.Color = 'k';
    else
        h1.Color = 'r';
    end
end
ax.Color = 'none';
labels = field;
ax.YLabel.String = 'Partial Corr Coeff';
ax.YLabel.FontSize = 16;
ax.XTick = 1:numel(labels);
ax.TickLength = [0 0];
ax.XTickLabel = labels; 
ax.LineWidth = 3; 
ax.FontWeight = 'bold';
ax.FontName = 'times new roman'; box off
fig = gcf;
fig.Color = 'w';

















