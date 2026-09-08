% this script uses the quantreg function to execute quantile regression on
% the Engel curves dataset.

%% Start of Code
clear; clc;

data = readtable("../datasets/engel.csv", RowNamesColumn=1);
[n,~] = size(data);

X = [ones(n,1), data.income];
[~,p] = size(X);

y = data.foodexp;

tau = [0.1, 0.25, 0.50, 0.75, 0.9];

betaOLS = X \ y;

k = length(tau); % Number of iterations
betaQuant = zeros(p,k);

for i = 1:k
    betaQuant(:,i) = quantreg(y, X, tau(i));
end

xrange = [min(data.income); max(data.income)];
Xplot = [ones(2,1), xrange];

figure;
scatter(data, "income", "foodexp", "filled", "SizeData", 60, "DisplayName", "Households");
hold on
title("Quantile regression vs OLS", "FontSize", 18)
subtitle("comparison on the Engel Curves Dataset", "FontSize", 16)
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
set(gca, 'FontSize', 16)
axis("tight")
hold off
