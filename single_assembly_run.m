function [reachable,...
    succMtx,...
    replacementMtx,...
    extinctionMtx,...
    S,...
    all_communities,...
    all_permanences,...
    all_steady_states] = single_assembly_run(M,...
    mu,...
    S,...
    C,...
    Pm,...
    all_communities,...
    all_permanences,...
    all_steady_states,...
    arrival_size,...
    invasion_level,...
    cut_off_level,...
    plotOn)


if isempty(all_communities)
    % calculate permanent subcommunities
    [all_communities, all_permanences, all_steady_states] = utility_calculate_permanent_subcommunities_withcap(M, mu, cut_off_level);
else
    % using precalulcated comms
end

% create empty succession matrices
number_potential_communities = length(all_permanences);
succMtx = zeros(number_potential_communities,number_potential_communities);
replacementMtx = zeros(number_potential_communities,number_potential_communities);
extinctionMtx = zeros(number_potential_communities,number_potential_communities);

%% Look for transitions
tic
parfor i = 2:number_potential_communities
    %% Initialize, set up slices
    parallel_all_permanences = all_permanences;
    parallel_all_communities = all_communities;
    parallel_succMtx_slice = succMtx(i,:);
    parallel_replacementMtx_slice = replacementMtx(i,:);
    parallel_extinctionMtx_slice = extinctionMtx(i,:);
    
    % get current community
    current_community = parallel_all_communities(i,:);
    
    %% go through each permanent community, look at where it could go
    if parallel_all_permanences(i) == 1
        
        %%%%%%%%%%%%%%% First look for consequences of additions %%%%%%%%%%%%%%%%%
        current_steady_state = all_steady_states(i,:);
        missing = setdiff(1:S, current_community)';
        
        % if missing == 0 then have reached the top community
        if missing == 0
            
        else
            % if not, calculate all the additional species
            % then the additions of more than one species at once
            missing = [missing, zeros(length(missing),arrival_size-1)];
            missing_store = missing;
            for arrival_ix = 2:arrival_size
                if length(missing(:,1)) >= arrival_ix
                    add_multiple = combnk(missing_store(:,1),arrival_ix);
                    if arrival_ix < arrival_size
                        add_multiple = [add_multiple, zeros(size(add_multiple,1), arrival_size - arrival_ix)];
                    end
                    missing = [missing; add_multiple];
                end
            end

            %missing(missing==0) = [];
            
            for j = 1:size(missing,1)
                
                % get species to add
                try
                new_species = missing(j,:);
                new_species(new_species==0) = [];
                catch
                   'here' 
                end
                
                
                % find the index of that community
                [indx] = utility_find_community_index([current_community(current_community>0), new_species], parallel_all_communities);
                
                %% permanent community to permanent community
                if parallel_all_permanences(indx) == 1
                    
                    parallel_succMtx_slice(indx) = 1;
                    if sum(current_steady_state) > 4950
                        [invasion_growth, M_temp, mu_temp] = utility_calculate_invasion_growth_rate(M,...
                            mu,...
                            current_steady_state,...
                            new_species,...
                            invasion_level);
                        
                        if invasion_growth < 0
                            parallel_succMtx_slice(indx) = 0;
                        else
                            invasion_initial_conditions = current_steady_state;
                            invasion_initial_conditions(new_species) = invasion_level;
                            [Y, t] = utility_calculate_community_dynamics_nocap_withcap(M_temp,...
                                mu_temp,...
                                S,...
                                invasion_initial_conditions,...
                                0,...
                                cut_off_level);
                        end
                    end

                    % perm to non-perm, where does it go next?
                else
                    
                    % what happens upon addition
                    [invasion_growth, M_temp, mu_temp] = utility_calculate_invasion_growth_rate(M,...
                        mu,...
                        current_steady_state,...
                        new_species,...
                        invasion_level);
                    
                    % if invasion_growth less that zero do nothing
                    if invasion_growth > 0
                        % simulate addition, what happened?
                        invasion_initial_conditions = current_steady_state;
                        invasion_initial_conditions(new_species) = invasion_level;
                        [Y, ~] = utility_calculate_community_dynamics_nocap_withcap(M_temp,...
                            mu_temp,...
                            S,...
                            invasion_initial_conditions,...
                            0,...
                            cut_off_level);
                        end_community = Y(end,:);
                        end_community = find(end_community>cut_off_level);
                        [indx] = utility_find_community_index(end_community, parallel_all_communities);
                        
                        % need to see if that new community is permanent
                        if parallel_all_permanences(indx) == 1
                            parallel_replacementMtx_slice(indx) = 1;%new_species;
                        else
                            % new comm not permanent, what next?
                            [permanent_subcommunity_indx] = utility_find_closest_permanent_community(end_community, all_communities, all_permanences);
                            parallel_replacementMtx_slice(permanent_subcommunity_indx) = 1;%new_species;
                        end
                        
                    end
                end
            end
        end
        
        succMtx(i,:) = parallel_succMtx_slice(:);
        replacementMtx(i,:) = parallel_replacementMtx_slice(:);
        extinctionMtx(i,:) = parallel_extinctionMtx_slice(:);
    end
    
    %
end

for i = 1:S
    if all_permanences(i+1) == 1
        succMtx(1,i+1) = 1;
        extinctionMtx(i+1, 1) = i;
    end
end

toc

[~, ~,...
    totalDeadEnds, ~, ~, ~,...
    ~, ~, reachable, ~] = utility_graph_analysis(succMtx,...
    replacementMtx,...
    extinctionMtx,...
    S,...
    all_communities,...
    all_permanences,...
    M,...
    mu,...
    Pm,...
    C,...
    plotOn);

end