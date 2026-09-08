% this script is a modified version of the Engel.m script, with modified parameters
% to save a better figure for the presentation

%% Start of Code
clear; clc;

data = readtable("../datasets/engel.csv", RowNamesColumn=1);
[n,~] = size(data);

X = [ones(n,1), data.income];
[~,p] = size(X);

y = data.foodexp;

tau = [0.25, 0.50, 0.75];

betaOLS = X \ y;

k = length(tau); % Number of iterations
betaQuant = zeros(p,k);

for i = 1:k
    betaQuant(:,i) = quantreg(y, X, tau(i));
end

xrange = [min(data.income); max(data.income)];
Xplot = [ones(2,1), xrange];

figure("Position", [100 100 1400 700]);
scatter(data, "income", "foodexp", "filled", "SizeData", 60, "DisplayName", "Households");
hold on
plot(xrange, Xplot * betaOLS, "--k", "LineWidth", 2, "DisplayName", "OLS regr")

colors = lines(k);
for i = 1:k
    if tau(i) == 0.5
        lineW = 3;
    else
        lineW = 2;
    end

    plot(xrange, Xplot * betaQuant(:,i), "Color", colors(i,:),"LineStyle", "-", ...
        "LineWidth", lineW, "DisplayName", sprintf('\\tau = %.2f', tau(i)))
end
legend show
xlabel("Household Income", "FontSize", 20)
ylabel("Food expenditure", "FontSize", 20)
axis("tight")
set(gca, 'FontSize', 16)
hold off

exportgraphics(gcf, '../slides/Images/EngelQR.png', 'Resolution', 300)
