%% Figure 5 E and F

repeats= 100;
PmSpace =  linspace(0.0,1,11);


figure;
subplot(1,2,1)
ste_standard = sqrt(mean(can_assembly_old,2).*(1 - mean(can_assembly_old,2))/repeats);
errorbar(PmSpace, mean(can_assembly_old,2), ste_standard, 'Color', 'k');
hold on

ste_standard = sqrt(mean(can_assembly_new,2).*(1 - mean(can_assembly_new,2))/repeats);
errorbar(PmSpace, mean(can_assembly_new,2), ste_standard, 'Color', [0.5,0.5,0.5]);

ste_standard = sqrt(mean(can_assembly_combined,2).*(1 - mean(can_assembly_combined,2))/repeats);
errorbar(PmSpace, mean(can_assembly_combined,2), ste_standard, 'Color', 'r');


title('probability of assembly')
axis([0,1,0,1])


subplot(1,2,2)
ste_standard = sqrt(mean(percent_feasible_new,2).*(1 - mean(percent_feasible_new,2))/repeats);
errorbar(1:1:10, mean(percent_feasible_new,2), ste_standard, 'Color', 'k');
hold on

ste_standard = sqrt(mean(percent_feasible_old,2).*(1 - mean(percent_feasible_old,2))/repeats);
errorbar(1:1:10, mean(percent_feasible_old,2), ste_standard, 'Color', [0.5,0.5,0.5]);

title('percent feasible')
