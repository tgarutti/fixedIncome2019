function [ beta, phi ] = statsPlots( sims, plot )
%STATSPLOTS 
R = 100;
[I,J] = size(sims{3}(:,:,1));
stdBetas = zeros(I,1);
stdPhi = zeros(I,J);
skewBetas = zeros(I,1);
skewPhi = zeros(I,J);
kurtBetas = zeros(I,1);
kurtPhi = zeros(I,J);

minBetas = zeros(I,1);
maxBetas = zeros(I,1);
ac1Betas = zeros(I,1);
ac12Betas = zeros(I,1);

beta = cell(8,1);
phi = cell(4,1);
beta{1} = mean(mean(sims{2},2),3);
phi{1} = mean(sims{3},3);

for i=1:I
    b = sims{2}(i,:,:);
    stdBetas(i) = std(b(:));
    skewBetas(i) = skewness(b(:));
    kurtBetas(i) = kurtosis(b(:));
    
    minBetas(i) = mean(min(b,[],2),3);
    maxBetas(i) = mean(max(b,[],2),3);
    ac1 
    
    for j=1:J
        stdPhi(i,j) = std(sims{3}(i,j,:));
        skewPhi(i,j) = skewness(sims{3}(i,j,:));
        kurtPhi(i,j) = kurtosis(sims{3}(i,j,:));
        
    end
end


beta{2} = stdBetas;
beta{3} = skewBetas;
beta{4} = kurtBetas;

phi{2} = stdPhi;
phi{3} = skewPhi;
phi{4} = kurtPhi;

if plot == 1
    subplot(3,1,1);
    histogram(mean(sims{2}(1,:,:),3),R/2);
    subplot(3,1,2);
    histogram(mean(sims{2}(2,:,:),3),R/2);
    subplot(3,1,3);
    histogram(mean(sims{2}(3,:,:),3),R/2);
elseif plot == 2
    subplot(3,4,1);
    histogram(sims{3}(1,1,:),R/4);
    xlabel('c_1');
    subplot(3,4,2);
    histogram(sims{3}(1,2,:),R/4);
    xlabel('\Phi_{1,1}');
    subplot(3,4,3);
    histogram(sims{3}(1,3,:),R/4);
    xlabel('\Phi_{1,2}');
    subplot(3,4,4);
    histogram(sims{3}(1,4,:),R/4);
    xlabel('\Phi_{1,3}');
    subplot(3,4,5);
    histogram(sims{3}(2,1,:),R/4);
    xlabel('c_2');
    subplot(3,4,6);
    histogram(sims{3}(2,2,:),R/4);
    xlabel('\Phi_{2,1}');
    subplot(3,4,7);
    histogram(sims{3}(2,3,:),R/4);
    xlabel('\Phi_{2,2}');
    subplot(3,4,8);
    histogram(sims{3}(2,4,:),R/4);
    xlabel('\Phi_{2,3}');
    subplot(3,4,9);
    histogram(sims{3}(3,1,:),R/4);
    xlabel('c_3');
    subplot(3,4,10);
    histogram(sims{3}(3,2,:),R/4);
    xlabel('\Phi_{3,1}');
    subplot(3,4,11);
    histogram(sims{3}(3,3,:),R/4);
    xlabel('\Phi_{3,2}');
    subplot(3,4,12);
    histogram(sims{3}(3,4,:),R/4);
    xlabel('\Phi_{3,3}');
elseif plot == 0
    
end


end

