%% Figure 3

sigma_space = [0.025, 0.05, 0.075, 0.1, 0.125];
PmSpace =  linspace(0.0,1,11);
repeats=150;

squeezed_stabilities = zeros(length(sigma_space), length(PmSpace));
squeezed_feasibility= zeros(length(sigma_space), length(PmSpace));
squeezed_paths= zeros(length(sigma_space), length(PmSpace));
squeezed_paths_std= zeros(length(sigma_space), length(PmSpace));


for sss = 1:length(sigma_space)
    for ppp = 1:length(PmSpace)
        squeezed_stabilities(sss, ppp) = mean(squeeze(all_stabilities(sss,ppp,:)));
        squeezed_feasibility(sss, ppp) = nanmean(squeeze(all_feasibilities(sss,ppp,:)));
        squeezed_paths(sss, ppp) = nanmean(squeeze(all_paths(sss,ppp,:)));
        squeezed_paths_std(sss, ppp) = nanstd(squeeze(all_paths(sss,ppp,:)));

    end
    
end

%%

figure
subplot(2,3,3)

hold on
my_colors= cbrewer('div', 'RdYlBu', 11, 'PCHIP');
marker_type = ['o','^','s','p','h'];
 
for sss=1:length(sigma_space)
    
    strongest = squeeze(all_stabilities(sss,:,:));
    ste_standard = sqrt(mean(strongest,2).*(1 - mean(strongest,2))/repeats);
    
    for pm = 1:length(PmSpace)
        scatter(squeezed_stabilities(sss, pm),(max(max(squeezed_paths))-squeezed_paths(sss, pm))/max(max(squeezed_paths)), 100, my_colors(pm,:),marker_type(sss), 'filled', 'MarkerEdgeColor',[0.5 .5 .5])
        hold on
    end
end
ylabel({'Predictability'; '(possible paths to assembly)'})
xlabel('P(Able to assemble)')

%%

subplot(2,3,6)

my_colors= cbrewer('div', 'RdYlBu', 11, 'PCHIP');

for sss = 1:length(sigma_space)
    store_proportions_of_types = zeros(11, 10);
    for pm_ix = 1:length(PmSpace)
        
        for comm_size = 1:10
            number_of_species_colonizing_at_this_point =[];
            for rep_ix = 1:repeats
                
                if store_reachable(sss, pm_ix, rep_ix) ==1
                    number_of_species_colonizing_at_this_point = [store_comm_types(sss, pm_ix, rep_ix, comm_size)/10; number_of_species_colonizing_at_this_point];
                end
                
            end
            store_proportions_of_types(pm_ix, comm_size) = mean(number_of_species_colonizing_at_this_point);
        end
    end
    
    concat_sum = [store_proportions_of_types(:,1), sum(store_proportions_of_types(:,2:end),2)];

    for pm = 1:length(PmSpace)
        scatter(squeezed_stabilities(sss, pm),concat_sum(pm,2), 100, my_colors(pm,:), marker_type(sss), 'filled', 'MarkerEdgeColor',[0.5 .5 .5])
        hold on
    end
    
end
xlabel('P(Able to assemble)')
ylabel({'Predictability'; '(% secondary colonizers)'})


%%
subplot(2,3,5)

my_colors= cbrewer('div', 'RdYlBu', 11, 'PCHIP');

store_all_secondaries = zeros(length(sigma_space), length(PmSpace));


for sss = 1:length(sigma_space)
    store_proportions_of_types = zeros(11, 10);
    for pm_ix = 1:length(PmSpace)
        
        for comm_size = 1:10
            number_of_species_colonizing_at_this_point =[];
            for rep_ix = 1:repeats
                
                if store_reachable(sss, pm_ix, rep_ix) ==1
                    number_of_species_colonizing_at_this_point = [store_comm_types(sss, pm_ix, rep_ix, comm_size)/10; number_of_species_colonizing_at_this_point];
                end
                
            end
            store_proportions_of_types(pm_ix, comm_size) = mean(number_of_species_colonizing_at_this_point);
        end
    end
    
    concat_sum = [store_proportions_of_types(:,1), sum(store_proportions_of_types(:,2:end),2)];
    store_all_secondaries(sss,:) = concat_sum(:,2);
    
    for pm = 1:length(PmSpace)
        scatter(squeezed_feasibility(sss, pm),concat_sum(pm,2), 100, my_colors(pm,:), marker_type(sss), 'filled', 'MarkerEdgeColor',[0.5 .5 .5])
        hold on
    end
    
end
xlabel('Feasible subcommunities')
ylabel({'Predictability'; '(% secondary colonizers)'})


%%

subplot(2,3,2)
hold on
my_colors= cbrewer('div', 'RdYlBu', 11, 'PCHIP');

marker_type = ['o','^','s','p','h'];
 

for sss=1:length(sigma_space)
    
    for pm = 1:length(PmSpace)
        scatter(squeezed_feasibility(sss, pm),(max(max(squeezed_paths))-squeezed_paths(sss, pm))/max(max(squeezed_paths)), 100, my_colors(pm,:),marker_type(sss), 'filled', 'MarkerEdgeColor',[0.5 .5 .5])
        hold on
    end
end
ylabel({'Predictability'; '(possible paths to assembly)'})
xlabel('Feasible subcommunities')

%%
subplot(2,3,4)

imagesc(flipud(store_all_secondaries))
xticks(1:length(PmSpace))
xticklabels(PmSpace)
yticks(1:length(sigma_space))
yticklabels(fliplr(sigma_space))
colormap(gca, flipud(cbrewer('seq', 'Greys',100, 'PCHIP')))

heatmap_paths= zeros(length(sigma_space), length(PmSpace));

for sss = 1:length(sigma_space)
    heatmap_paths(sss,:) = squeezed_paths(sss, :);
    hold on
end

subplot(2,3,1)
imagesc(flipud(heatmap_paths))
xticks(1:length(PmSpace))
xticklabels(PmSpace)
yticks(1:length(sigma_space))
yticklabels(fliplr(sigma_space))
colormap(gca, cbrewer('seq', 'Greys',100, 'PCHIP'))
caxis([0,5000])



