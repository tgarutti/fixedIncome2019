function [ t_test ] = robustnessSim( params, DGP, MDL, N )
%ROBUSTNESSSIM
%Select parameters for dgp
tau = params{1};
lambda = params{2};
beta0 = params{3};
sigma1 = params{4};
phi = params{5};
sigma2 = params{6};
T = params{7};
R  = params{8};

t_test = cell(2,1);
tStat = zeros(3,4,N);
pVal = zeros(3,4,N);
sigma2 = [0.01:(1/N):1];
for i=1:N
    yields = DGP(tau, lambda, beta0, sigma1, phi, sigma2(i), T, R);
    mdlEst = evaluateSimulations(yields, lambda, tau, 1, MDL);
    [~, simPhi] = statsPlots(mdlEst, 0);
    tStat(:,:,i) = (simPhi{1} - phi)./(simPhi{2});
    pVal(:,:,i) = 2*(1-tcdf(abs(tStat(:,:,i)), R-1));
end
t_test{1} = tStat;
t_test{2} = pVal;
end

