function [ t_test ] = robustnessSim( params, DGP, MDL, N, plot )
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
sigma2 = [0.001:(1/N):2];
for i=1:N
    yields = DGP(tau, lambda, beta0, sigma1, phi, sigma2(i), T, R);
    mdlEst = evaluateSimulations(yields, lambda, tau, 1, MDL);
    [~, simPhi] = statsPlots(mdlEst, 0);
    tStat(:,:,i) = (simPhi{1} - phi)./(simPhi{2});
    pVal(:,:,i) = 2*(1-tcdf(abs(tStat(:,:,i)), R-1));
end
t_test{1} = tStat;
t_test{2} = pVal;

if plot == true
        subplot(3,4,1);
    histogram(pVal(1,1,:),R/4);
    xlabel('c_1');
    subplot(3,4,2);
    histogram(pVal(1,2,:),R/4);
    xlabel('\Phi_{1,1}');
    subplot(3,4,3);
    histogram(pVal(1,3,:),R/4);
    xlabel('\Phi_{1,2}');
    subplot(3,4,4);
    histogram(pVal(1,4,:),R/4);
    xlabel('\Phi_{1,3}');
    subplot(3,4,5);
    histogram(pVal(2,1,:),R/4);
    xlabel('c_2');
    subplot(3,4,6);
    histogram(pVal(2,2,:),R/4);
    xlabel('\Phi_{2,1}');
    subplot(3,4,7);
    histogram(pVal(2,3,:),R/4);
    xlabel('\Phi_{2,2}');
    subplot(3,4,8);
    histogram(pVal(2,4,:),R/4);
    xlabel('\Phi_{2,3}');
    subplot(3,4,9);
    histogram(pVal(3,1,:),R/4);
    xlabel('c_3');
    subplot(3,4,10);
    histogram(pVal(3,2,:),R/4);
    xlabel('\Phi_{3,1}');
    subplot(3,4,11);
    histogram(pVal(3,3,:),R/4);
    xlabel('\Phi_{3,2}');
    subplot(3,4,12);
    histogram(pVal(3,4,:),R/4);
    xlabel('\Phi_{3,3}');
end
    
            
end
end

