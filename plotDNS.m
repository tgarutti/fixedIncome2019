function [ ] = plotDNS( DNS, dates )
%PLOTDNS
beta = DNS{2};
subplot(3,1,1);
plot(1:120, beta(1,1:(end-1)));
subplot(3,1,2);
plot(1:120, beta(2,1:(end-1)));
subplot(3,1,3);
plot(1:120, beta(3,1:(end-1)));
end

