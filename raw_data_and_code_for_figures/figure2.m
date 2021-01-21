%% Figure 2

marker_type = ['o','^','s','p','h'];
f = figure;

%%
sigma_space = [0.025, 0.05, 0.075, 0.1, 0.125];
PmSpace =  linspace(0.0,1,11);
repeats=150;

squeezed_stabilities = zeros(length(sigma_space), length(PmSpace));
squeezed_feasibility= zeros(length(sigma_space), length(PmSpace));
squeezed_mlcs = zeros(length(sigma_space), length(PmSpace));
squeezed_mlcs2 = zeros(length(sigma_space), length(PmSpace));


for sss = 1:length(sigma_space)
    for ppp = 1:length(PmSpace)
        squeezed_stabilities(sss, ppp) = mean(squeeze(all_stabilities(sss,ppp,:)));
        squeezed_feasibility(sss, ppp) = nanmean(squeeze(all_feasibilities(sss,ppp,:)));
        squeezed_mlcs(sss, ppp) = nanmean(squeeze(all_mlcs(sss,ppp,:)));
        squeezed_mlcs2(sss, ppp) = nanmean(squeeze(store_mlcs_2(sss,ppp,:)));
    end
    
end



%%
subplot(2,3,1)
imagesc(flipud(squeezed_stabilities))
xticks(1:length(PmSpace))
xticklabels(PmSpace)
yticks(1:length(sigma_space))
yticklabels(sigma_space)
colormap(gca, flipud(cbrewer('seq', 'Greys',100, 'PCHIP')))
caxis([0,1])

%%
subplot(2,3,4)
my_colors= cbrewer('div', 'RdYlBu', 11, 'PCHIP');

for sss=1:length(sigma_space)
    for pm = 1:length(PmSpace)
        scatter(squeezed_feasibility(sss, pm), squeezed_stabilities(sss, pm), 100, my_colors(pm,:),marker_type(sss), 'filled', 'MarkerEdgeColor',[0.5 .5 .5])

        hold on
    end
end
xlabel('# Feasible Sub-communities')
ylabel('P(Able to assemble)')

%%

subplot(2,3,3)


imagesc(flipud(squeezed_mlcs))
xticks(1:length(PmSpace))
xticklabels(PmSpace)
yticks(1:length(sigma_space))
yticklabels(sigma_space)
colormap(gca, flipud(cbrewer('seq', 'Greens',100, 'PCHIP')))
caxis([2,10])


subplot(2,3,6)
imagesc(flipud(squeezed_mlcs2))
xticks(1:length(PmSpace))
xticklabels(PmSpace)
yticks(1:length(sigma_space))
yticklabels(sigma_space)
colormap(gca, flipud(cbrewer('seq', 'Greens',100, 'PCHIP')))
caxis([2,10])

