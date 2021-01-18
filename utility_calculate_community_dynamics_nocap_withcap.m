function [Yall, tall] = utility_calculate_community_dynamics_nocap_withcap(M, mu, S, init, t_i, cut_off_level)


totalCap = 5000;

check = ones(1,length(init));

Yall = zeros(1,S);
tall = t_i;
tend=t_i;
store_timesteps=0;

t_gap = 5;

check_val = 0.001*sum(Yall(end,:));

while sum(check>check_val) > 0
    
    % run underneath cap
    options = odeset('Events',@hit_cap);
    
    if sum(Yall(end,:))>500
        %t_gap = 0.01;
        t_gap = 100;
    end
    
    if sum(Yall(end,:))<totalCap - 1
        [t, Y] = ode15s(@(t,Y)utility_ode_dynamics(t,Y, M, mu, totalCap, cut_off_level),[tend,tend+t_gap], init, options);
    else
        [t, Y] = ode45(@(t,Y)utility_ode_dynamics(t,Y, M, mu, totalCap, cut_off_level),[tend,tend+t_gap], init);
        Y(end, Y(end,:)<0.01*sum(Y(end,:))) = 0;
        
        if sum(sum(isnan(Y)))>0
            'hi';
            [t, Y] = ode23s(@(t,Y)utility_ode_dynamics(t,Y, M, mu, totalCap, cut_off_level),[tend,tend+10], init);
        end
    end
    
    % uncomment if want to output full dynamics
    %Yall = [Yall;Y];
    %tall =[tall;t];
    
    Yall = Y;
    tall = t;
    
    check_val = 0.001*sum(Yall(end,:));
    
    if size(Y,1) > 2
        size_check = min(10, size(Y,1)-1);
        check = abs(Y(end,:) - Y(size(Y,1)-size_check,:));
    else
        check = 0;
    end
    
    Y(Y<cut_off_level)=0;
    
    
    
    tend = t(end);
    store_timesteps = store_timesteps+1;
    if store_timesteps>10000
        check=0;
        store_timesteps
    end
    
    init = Y(end,:);
end




end

function [dYdt] = utility_ode_dynamics(t, Y, M, mu, totalCap, cut_off_level)

totalCells = sum(Y);

if totalCells < totalCap
    
    Y(Y<cut_off_level) = 0;
    dYdt =  Y.*(mu + M*Y);
    dYdt = dYdt;
    
else
    Y(Y<10) = 0;
    growthRates = Y.*(mu + M*Y);
    growingSpeciesRates = sum(growthRates(growthRates>0));
    growthShare = growthRates/growingSpeciesRates;
    dYdt = (growthShare - mean(growthShare(growthShare>0.001)));
    growingSpeciesRates = sum(growthRates);
    growthShare = growthRates/growingSpeciesRates;
    dYdt(growthShare>0.01) = growthShare(growthShare>0.01) - mean(growthShare(growthShare>0.01));
    dYdt(Y < 10) = 0;
    dYdt=dYdt*10;
end





end

function [value,isterminal,direction] = hit_cap(t,Y)
value = sum(Y) - 5000;     % Detect height = 0
isterminal = 1;   % Stop the integration
direction = 0;

end