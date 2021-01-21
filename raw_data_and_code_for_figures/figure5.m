%% Figure 5

repeats= 100;
PmSpace =  linspace(0.0,1,11);

load('figure5_CD.mat')
load('figure5_EF.mat')

figure;

%%
subplot(2,2,1)

ste_standard = sqrt(mean(cp_standard,2).*(1 - mean(cp_standard,2))/repeats);
errorbar(PmSpace, mean(cp_standard,2), ste_standard);
hold on

ste_standard = sqrt(mean(cp_ma1,2).*(1 - mean(cp_ma1,2))/repeats);
errorbar(PmSpace, mean(cp_ma1,2), ste_standard);
hold on

ste_standard = sqrt(mean(cp_ma2,2).*(1 - mean(cp_ma2,2))/repeats);
errorbar(PmSpace, mean(cp_ma2,2), ste_standard);
hold on
title('probability of assembly')
axis([0,1,0,1])

%%
subplot(2,2,2)
ste_standard = std(cp_standard_feas');
errorbar(PmSpace, mean(cp_standard_feas,2), ste_standard);
hold on

ste_standard = std(cp_ma1_feas');
errorbar(PmSpace, mean(cp_ma1_feas,2), ste_standard);
hold on

ste_standard = std(cp_ma2_feas');
errorbar(PmSpace, mean(cp_ma2_feas,2), ste_standard);
hold on
title('# of edges')

%%
subplot(2,2,3)
ste_standard = sqrt(mean(can_assembly_old,2).*(1 - mean(can_assembly_old,2))/repeats);
errorbar(PmSpace, mean(can_assembly_old,2), ste_standard, 'Color', 'k');
hold on

ste_standard = sqrt(mean(can_assembly_new,2).*(1 - mean(can_assembly_new,2))/repeats);
errorbar(PmSpace, mean(can_assembly_new,2), ste_standard, 'Color', [0.5,0.5,0.5]);

ste_standard = sqrt(mean(can_assembly_combined,2).*(1 - mean(can_assembly_combined,2))/repeats);
errorbar(PmSpace, mean(can_assembly_combined,2), ste_standard, 'Color', 'r');

axis([0,1,0,1])
title('probability of assembly')

%%
subplot(2,2,4)
ste_standard = sqrt(mean(percent_feasible_new,2).*(1 - mean(percent_feasible_new,2))/repeats);
errorbar(1:1:10, mean(percent_feasible_new,2), ste_standard, 'Color', 'k');
hold on

ste_standard = sqrt(mean(percent_feasible_old,2).*(1 - mean(percent_feasible_old,2))/repeats);
errorbar(1:1:10, mean(percent_feasible_old,2), ste_standard, 'Color', [0.5,0.5,0.5]);

title('percent feasible')
