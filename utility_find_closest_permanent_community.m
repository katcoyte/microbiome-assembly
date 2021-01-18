% this function loops through subcommunities looking for a permanent one

function [permSubCommIndx] = utility_find_closest_permanent_community(endComm, allCombos, allPerms)

checkReps = 0;
checkLevel = 1;
permSubCommIndx = [];

while checkReps == 0
    
    if checkLevel == length(endComm)
        checkReps = 1;
        permSubCommIndx = 1;
    else
        
        subComms = nchoosek(endComm,length(endComm)-checkLevel);
        
        if isempty(subComms) == 1
            %permSubCommIndx = 0;
            permSubCommIndx = 1;
            checkReps = 1;
        else
            
            for scInd = 1:size(subComms,1)
                
                [indx3] = utility_find_community_index(subComms(scInd,:), allCombos);
                replacementPerm = allPerms(indx3);
                if replacementPerm == 1
                    permSubCommIndx = [permSubCommIndx ; indx3];
                end
                checkReps = checkReps+replacementPerm;
                
            end
            checkLevel = checkLevel+1;
        end
    end
end

end