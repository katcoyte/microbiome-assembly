% Keep all the stuff to do with analysing succession matrix in here

function [distanceToFull, totalReachableComms, totalDeadEnds,...
    C, v, number_graph_components,...
    numSuccessionSpecies, maxSize, reachable, average_de_interactions, average_undead_interactions] = utility_graph_analysis(succMtx,...
    replacementMtx,...
    extinctionMtx,...
    S,...
    allCombos,...
    allPerms,...
    M,...
    mu,...
    Pm,...
    Connectivity,...
    plotOn)


C=0;
v=0;
numSuccessionSpecies=0;
maxSize=0;

fullConnectivityMtx = logical(succMtx+ replacementMtx + extinctionMtx);

path = 0;
distanceToFull = length(path); % at the moment this will either be one at a time or never


%% get which communities are reachable
reachable = zeros(length(succMtx),1);
G = graph(succMtx + succMtx') ;
bins = conncomp(G);
reachable(bins==1) = 1;
totalReachableComms = sum(reachable);

%% how many graph components are there (i.e. is there a break in the graph)

[bin_counts,~]=hist(bins,unique(bins));
number_graph_components = sum(bin_counts>1);

%% how many dead end communities

notLeavable = zeros(length(succMtx),1);
dead_ends = []; k=1;
if reachable(end)
    for i = 1:length(succMtx)
        
        if reachable(i) == 1
            
            currentRow = fullConnectivityMtx(i,:);
            number_of_new_states = length(currentRow(currentRow>0));
            if number_of_new_states == 0
                notLeavable(i) = 1;
                dead_ends(k) = i;
                k=k+1;
            end
        end
    end
end
totalDeadEnds = sum(notLeavable);

%% NEW GET DEAD END COMP

% first get all dead end communities
average_undead_interactions = [0,0,0,0,0,0,0];
average_de_interactions = [-1,0,0,0,0,0,0];


%% Plotting things

myFig = 1;
if plotOn == 1
    
    myFig = figure;
    utility_visualise_succession(S, succMtx, dead_ends, 1)
    hold on
    utility_visualise_succession(S, replacementMtx, [], 2)

end
numAbsorbing = 1;
do_trans_analysis = 0;
if do_trans_analysis == 1
    %% Transition matrix analysis
    % Want to know how many communicating classes there are (amongst
    % communities that actually exist) stationary distribution etc

    realComms = allPerms;
    temp = allCombos;
    realCombos = temp(realComms==1,:);
    
    [transitionMtx]  = utility_make_transition_matrix(succMtx, extinctionMtx, replacementMtx, allCombos, S);
    [C,v] =commclasses(transitionMtx);
    
    closedClasses = v(realComms==1);
    
    % does this get the stationary distribution?
    tt = transitionMtx(realComms==1, realComms==1);
    statDist = limitdist(tt);
    
    if plotOn == 1
        figure
        subplot(1,3,2)
        myAxis = find(allPerms==1);
        bar(myAxis, statDist)
        
    end
    
    [~,maxInd] = max(statDist);
    maxComm = realCombos(maxInd,:);
    maxSize = sum(maxComm>0);
    
    numAbsorbing = sum(statDist>0.01)
    
end



end