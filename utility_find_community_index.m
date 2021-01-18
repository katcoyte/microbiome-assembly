function [indx] = utility_find_community_index(searchComm, allCombos)

S = size(allCombos, 2);

sortedComm = sort(searchComm);

searchTerm = zeros(1,S);

searchTerm(1:length(sortedComm)) = sortedComm;

[~,indx]=ismember(searchTerm,allCombos,'rows');

end