function [ yieldsEst ] = dgpDNS( tau, lambda, beta0, sigma1, phi, sigma2, T, R )
%DGPDNS
%Initialize variables
[m,n] = size(phi);
var1 = sigma1^2;
var2 = sigma2^2*eye(m);
B = [ones(size(tau)), (1-exp(-lambda*tau))./(lambda*tau),...
    (1-exp(-lambda*tau))./(lambda*tau) - exp(-lambda*tau)];
y = zeros(size(tau))';
yieldsEst = cell(R,1);

% Run R simulations of the DNS dgp
for r = 1:R
    %Set beta to initial value beta0
    beta = beta0;
    yieldsEst{r} = zeros(size(B,1), T);
    for t = 1:T
        % Simulate error terms
         nu = mvnrnd(zeros(m, 1), sqrt(var2))';   % correlated nu

        % Evaluate DNS dynamics
        var_y = var1;
        for i = 1:size(tau,1)
            eps = normrnd(0, sqrt(var_y));
            y(i) = B(i,:)*beta + eps;
            var_y = 0.9*var_y;
        end
        beta = phi*[1; beta] + nu;
        yieldsEst{r}(:, t) = y;
    end
end

end

