function [ ] = plotDNS( DNS, dates )
%PLOTDNS
beta = DNS{2};
subplot(3,1,1);
plot(dates(1:120), beta(1,1:(end-1)), 'color', 'r');
ylabel('$\hat{\beta_1}$ (Level)','interpreter','latex','FontSize',20);
subplot(3,1,2);
plot(dates(1:120), beta(2,1:(end-1)), 'color', 'b');
ylabel('$\hat{\beta_2}$ (Slope)','interpreter','latex','FontSize',20);
subplot(3,1,3);
plot(dates(1:120), beta(3,1:(end-1)), 'color', 'black');
ylabel('$\hat{\beta_3}$ (Curvature)','interpreter','latex','FontSize',20);
end

