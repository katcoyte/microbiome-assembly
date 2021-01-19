% This function creates the transition matrix for community succession,
% obey the following rules:

% 1. Species added at rate alpha
% 2. Species die at rate delta

% equal probability of each of the absent species arriving at any given
% time (NB, may want to change this later, eg to equal probability of *any*
% species arriving at a given time)

% 3. Species addition may lead to:
%   a. Augmentation - joins existing species
%   b. Replacement - replaces a single existing species
%   c. Replacement and loss - new species joins, triggers the loss of two
%   or more species

% 4. Species extinction may lead to:
%   a. Reduced community is permanent
%   b. Reduced community not permanent, community collapses down to one
%   possible permanent states

function [transitionMtx]  = utility_make_transition_matrix(successionMtx, extinctionMtx, replacementMtx, allCombos, S)

%% Parameters

alpha = 0.1;        % species arrival rate
delta = 0.025;        % species loss rate

%% Split different trophic levels to distinguish additions

trophicLevels = allCombos;
trophicLevels(trophicLevels>0) = 1;
trophicLevels = sum(trophicLevels,2);
trophicLevels = [0; trophicLevels];

%% First get addition probabilities

%%% If you want species to arrive without replacement
%alphaTL =  (ones(length(trophicLevels),1)*alpha ./ (S - trophicLevels));
%alphaTL(alphaTL == Inf) = 0;
%timesTL = repmat(alphaTL, 1, length(alphaTL));
%additionRates  = successionMtx.*timesTL;

%%% If each species arrives with equal probability

additionRates  = successionMtx*(alpha/S);


%% Next, replacement probabilities 
% need to know which edges corresponded to which addition, keep this
% information in replacement matrix itself

replacementRates = zeros(size(replacementMtx));

for i = 1:length(replacementMtx)
    
    currentRow = replacementMtx(i, :);
    repSpecies = unique(currentRow);
    repSpecies(repSpecies==0) = [];
    
    for j = 1:length(repSpecies)
       
        lookFor = repSpecies(j);
        repEvents = find(currentRow == lookFor);
        replacementRates(i, repEvents) = (alpha/S);
    end
   
    
end

%% Now extinction events
% currently each species has an equal probability of going extinct,
% regardless of whether actually present or not

extinctionRates = zeros(size(extinctionMtx));


for i = 1:length(extinctionMtx)
    
    currentRow = extinctionMtx(i, :);
    extSpecies = unique(currentRow);
    extSpecies(extSpecies==0) = [];
    
    for j = 1:length(extSpecies)
       
        lookFor = extSpecies(j);
        extEvents = find(currentRow == lookFor);
        %extinctionRates(i, extEvents) = (delta/S) / length(extEvents);
        extinctionRates(i, extEvents) = (delta/S);
    end
   
    
end


transitionMtx = additionRates + replacementRates + extinctionRates;

end