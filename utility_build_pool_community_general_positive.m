% Function to generate stable climax community. Generate random structured,
% competitive community, randomly switch proportion Pm of interactions to be positive

function [M, mu] = utility_build_pool_community_general_positive(S, C, sigma, Pm, self_inhibition)

permanent = 0;
tic
while permanent == 0
    
    % build a full competitive network
    M = rand(S);
    M(M>(1-C)) = 1;
    M(M<=(1-C)) = 0;
    M = M.* (sigma * abs(randn(S)))*-1;
    M(eye(S)==1)=0;

    % switch a certain proportion to positive
    non_zero = find(M<0);
    switch_to_p = rand(1, length(non_zero));
    find_switch = find(switch_to_p<Pm);
    find_switch = non_zero(find_switch);
    M(find_switch) = M(find_switch)*-1;

    % Add self-inhibition
    SelfDiag = ones(S,1)*self_inhibition;
    M = M - diag(SelfDiag);
    steady_state = rand(S,1);
    mu = -(M * steady_state);
    
    % Calculate Jacobian and stability
    my_jac = M.*repmat(steady_state', S,1);
    my_stab = max(real( eigs(my_jac)));
    if my_stab < 0
        permanent = 1;
    else 
        permanent = 0;
    end
    
end
toc


end

