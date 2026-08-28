function beta_hat = quantreg(y, X, tau)

arguments (Input)
    y (:,1) double
    X (:,:) double
    tau (1,1) double {mustBeGreaterThan(tau,0), mustBeLessThan(tau,1)}
end

arguments (Output)
    beta_hat (:,1) double
end

[n, p] = size(X);

if n ~= length(y)
    error("Error: dimension mismatch: X and y must have the same number of rows!")
end

beta = sdpvar(p, 1);
u = sdpvar(n, 1);
v = sdpvar(n, 1);
objective = tau * sum(u) + (1-tau) * sum(v);

options = sdpsettings('solver', 'gurobi', 'verbose', 0);

C = [y == X * beta + u - v;
    u >= 0;
    v >= 0];

sol = optimize(C, objective, options);

if sol.problem ~= 0
    error("Error! The solver didn't find an optimal solution")
end

beta_hat = value(beta);

end