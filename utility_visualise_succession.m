function [] = utility_visualise_succession_new(S, succMtx, dead_ends, new_dot_sizes, plotSize)

% all combos and trophic levels

totalCombos = 2^S -1; % -1 to not count the no species state
allCombos = zeros(totalCombos, S);
% trophic levels
tl = allCombos;
tl(tl>0) = 1;
tl = sum(tl,2);

C = nchoosek(1:S,floor(S/2));
maxX = length(C);

for i = 0:S
    C = nchoosek(1:S,i);
    maxX(i+1) = size(C,1);
    
end

ycoords = zeros(sum(maxX), 2);
indx = 1;
xspan = max(maxX);
xs1 = linspace(0.1, 3, ceil((S+1)/2));
xscales = [xs1, fliplr(xs1)];
%xscales = linspace(0.1, 2, S+1);



for i = 0:S
    
    maxInd = maxX(1,i+1);
    if maxX(1,i+1) == 1
        %ints = (xspan*xs1(end))/2;
        ints = (xspan)/2;
    else
        %ints = linspace(((xspan*xs1(end))/2) - (xscales(i+1)*xspan)/2, xscales(i+1)*xspan,maxInd);
        ints = linspace(0, xspan,maxInd);
    end
    
    for j = 1:maxInd
        ycoords(indx, 1) = i;
        ycoords(indx, 2) = ints(j);
        indx = indx+1;
    end
    
end

ycoords(dead_ends,:)


%gplot(succMtx, [ycoords(:,2), ycoords(:,1)],'-o')
succMtx(eye(length(succMtx))==1)=0;
gg = digraph(succMtx);
plot(gg,'XData',ycoords(:,2),'YData',ycoords(:,1))
axis([0, xspan, 0, S])


fig = gcf
ax = fig.CurrentAxes;
set(findall(fig,'-property','FontSize'),'FontSize',15)
set(findall(fig,'-property','FontName'),'FontName','Arial')
set(findall(ax,'-property','MarkerSize'), 'MarkerSize',1)
set(findall(ax,'-property','MarkerFaceColor'), 'MarkerFaceColor',[1 1 1])
set(findall(ax,'-property','MarkerFaceAlpha'), 'MarkerFaceAlpha',0.00)
set(findall(ax,'-property','MarkerEdgeColor'), 'MarkerEdgeColor',[1 1 1])
set(findall(ax,'-property','MarkerEdgeAlpha'), 'MarkerEdgeAlpha',0.00)
set(findall(ax,'-property','EdgeColor'), 'EdgeColor',[.25 .25 .25])
set(findall(ax,'-property','ShowArrows'), 'ShowArrows','off')

hold on

new_dot_sizes(new_dot_sizes==0)=0.000001;
if plotSize
    for ix = 1:length(ycoords)
        
        scatter(ycoords(ix,2),ycoords(ix,1),new_dot_sizes(ix)*5000, 'MarkerFaceColor', [1 .5 0], 'MarkerEdgeColor',[1 .5 0])
        
    end
end


end