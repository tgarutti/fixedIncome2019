function [ beta, phi ] = statsPlots( sims, plot )
%STATSPLOTS 
R = 100;
[I,J] = size(sims{3}(:,:,1));
stdBetas = zeros(I,1);
stdPhi = zeros(I,J);

for i=1:I
    beta = sims{2}(i,:,:);
    stdBetas(i) = std(beta(:));
    for j=1:J
        stdPhi(i,j) = std(sims{3}(i,j,:));
    end
end
beta = cell(2,1);
phi = cell(2,1);

beta{1} = mean(mean(sims{2},2),3);
phi{1} = mean(sims{3},3);
beta{2} = stdBetas;
phi{2} = stdPhi;

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
    subplot(3,4,2);
    histogram(sims{3}(1,2,:),R/4);
    subplot(3,4,3);
    histogram(sims{3}(1,3,:),R/4);
    subplot(3,4,4);
    histogram(sims{3}(1,4,:),R/4);
    subplot(3,4,5);
    histogram(sims{3}(2,1,:),R/4);
    subplot(3,4,6);
    histogram(sims{3}(2,2,:),R/4);
    subplot(3,4,7);
    histogram(sims{3}(2,3,:),R/4);
    subplot(3,4,8);
    histogram(sims{3}(2,4,:),R/4);
    subplot(3,4,9);
    histogram(sims{3}(3,1,:),R/4);
    subplot(3,4,10);
    histogram(sims{3}(3,2,:),R/4);
    subplot(3,4,11);
    histogram(sims{3}(3,3,:),R/4);
    subplot(3,4,12);
    histogram(sims{3}(3,4,:),R/4);
elseif plot == 0
    
end


end

