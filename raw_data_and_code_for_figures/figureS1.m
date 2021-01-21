%% Figure S1B - uncapped model results (S1A as in Fig 2)

PmSpace =  linspace(0.0,1,11);
sigma_space = [0.025,0.05,0.075,0.1,0.125];


imagesc(flipud(nanmean(uncapped_model_results,3)))
xticks(1:length(PmSpace))
xticklabels(PmSpace)
yticks(1:length(sigma_space))
yticklabels(sigma_space)
colormap(gca, flipud(cbrewer('seq', 'Greys',100, 'PCHIP')))
caxis([0,1])