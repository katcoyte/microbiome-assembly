function [invasion_growth, M_temp, mu_temp] = utility_calculate_invasion_growth_rate(M,...
    mu,...
    current_steady_state,...
    new_species,...
    invasion_level)

invasion_initial_conditions = current_steady_state;
invasion_initial_conditions(new_species) = invasion_level;

mu_temp = mu;
M_temp = M;

size_new_community = length(invasion_initial_conditions(invasion_initial_conditions>0));

% If community at cap, take into account relative growth rate of invading
% species versus existing species - if new species growth share is low,
% cannot invades
invasion_growth = mu_temp(new_species) + M_temp(new_species,:) * invasion_initial_conditions';

if sum(current_steady_state)>4950
    
    growthRates = invasion_initial_conditions'.*(mu + M*invasion_initial_conditions');
    growingSpeciesRates = sum(growthRates(growthRates>0));
    growthShare = growthRates/growingSpeciesRates;
    dYdt = (growthShare - mean(growthShare(growthShare>0.01)));
    growingSpeciesRates = sum(growthRates);
    growthShare = growthRates/growingSpeciesRates;
    dYdt(growthShare>0.01) = growthShare(growthShare>0.01) - mean(growthShare(growthShare>0.01));
    invasion_growth = dYdt(new_species);
end



end

