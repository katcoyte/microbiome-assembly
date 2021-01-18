function [all_communities, all_permanences, all_steady_states] = utility_calculate_permanent_subcommunities_withcap(M, mu, cut_off_level)
        
        S = length(mu);
        
        total_communities = 2^S; % -1 to not count the no species state
        all_communities = zeros(total_communities, S);
        
        j = 2;
        for i = 1:S
            CC = nchoosek(1:S,i);
            cc = size(CC,1);
            all_communities(j:j+cc-1, 1:i) = CC;
            j = j+cc;
        end
        
        all_permanences = zeros(total_communities,1);
        all_steady_states = zeros(total_communities, S);
        
        all_permanences(1) = 1;
        tic
        parfor i = 2:total_communities 
            currComm = all_communities(i,:);
            Mtemp = M(currComm(currComm>0), currComm(currComm>0));
            muTemp = mu(currComm(currComm>0));
            
            % check whether feasible and linearly stable
            steady_state = (-Mtemp\muTemp)';
            is_unreal = any(steady_state<0) + any(steady_state==Inf);
            if is_unreal>0
                steady_state(steady_state<0)=0;
                all_permanences(i) = 0;
                temp_steady_state = steady_state;
                [Yall, tall] = utility_calculate_community_dynamics_nocap_withcap(Mtemp, muTemp, length(muTemp), ones(1, length(muTemp)), 10, cut_off_level);
                tmpY = Yall(end,:);
                if length(tmpY(tmpY>cut_off_level))==length(muTemp)
                   all_permanences(i) = 1;
                   temp_steady_state = Yall(end,:);
                end
                
            else
                my_jac = Mtemp.*repmat(steady_state, length(steady_state),1);
                
                try
                my_stab = max(real( eigs(my_jac)));
                catch
                   'here' 
                end
                my_stab(my_stab>0)=0;
                my_stab(my_stab<0)=1;
                all_permanences(i) = my_stab;
                temp_steady_state = steady_state;
            end
            
            
            slice_steady_states = zeros(1, S);
            slice_steady_states(currComm(currComm>0)) = temp_steady_state;
            all_steady_states(i,:) = slice_steady_states;

        end
        toc
        

end