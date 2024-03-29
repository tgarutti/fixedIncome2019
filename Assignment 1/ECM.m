function [ output ] = ECM(yields, lambda, tau, steps_ahead)
% ECM forecasts yields using the error-correction model (1)

[m,T] = size(yields);
F = length(steps_ahead);
yield_forecasts = nan(m,F);

for tau=1:m
    % Estimate cointegration relation of yield_t and yield_(t-1)
    X = [ones(T-1,1),yields(tau,1:end-1)'];
    Y = yields(tau,2:end)';
    b = X\Y;
    
    % Estimate error-correction model
    error = Y - X*b;
    dX = [yields(tau,2:end-1) - yields(tau, 1:end-2)]';
    Z = [dX, -error(1:end-1)];
    dY = [yields(tau,3:end) - yields(tau, 2:end-1)]';
    PHI = Z\dY; %PHI = [phi; gamma]
    
    %     % forecast yield / dY specification
    %     for f=1:F
    %         error_f = error(end);
    %         Z_f = [yields(tau,end)-yields(tau,end-1), -error_f];
    %         dyield_sum = 0;
    %         for s = 1:steps_ahead(f)
    %             dyield = Z_f*PHI;
    %             dyield_sum = dyield_sum + dyield;
    %             error_f = (1-PHI(2))*error_f; %estimate next error using rho = 1-gamma
    %             Z_f = [dyield, -error_f];
    %         end
    %         yield_forecasts(tau,f) = yields(tau,end) + dyield_sum;
    %     end
    
    % forecast yield / Y specification
    for f=1:F
        error_f = error(end);
        X_f = [1,yields(tau,end)];
        for s = 1:steps_ahead(f)
            Y_f = X_f*b + error_f; %predict next yield, correcting for error
            error_f = (1-PHI(2))*error_f; %forecast next error
            X_f = [1,Y_f]; %lagged yield as explanatory variable
        end
        yield_forecasts(tau,f) = Y_f;
    end
    
    output = cell(1);
    output{1} = yield_forecasts;
    
end

end


