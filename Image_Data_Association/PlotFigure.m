function [] = PlotFigure(fturT, bandwidth, clustCent, clustMembsCell)

numClust = length(clustMembsCell);
figure,clf,hold on
cVec = 'bgrcmykbgrcmykbgrcmykbgrcmyk';%, cVec = [cVec cVec];
for k = 1:min(numClust,length(cVec))
    myMembers = clustMembsCell{k};
    myClustCen = clustCent(:,k);
    %plot(fturT(1,myMembers),fturT(2,myMembers),[cVec(k) '.'])
    plot3(fturT(1,myMembers),fturT(2,myMembers),fturT(3,myMembers),[cVec(k) '.'])
    %plot(myClustCen(1),myClustCen(2),'o','MarkerEdgeColor','k','MarkerFaceColor',cVec(k), 'MarkerSize',10)
    plot3(myClustCen(1),myClustCen(2),myClustCen(3),'o','MarkerEdgeColor','k','MarkerFaceColor',cVec(k), 'MarkerSize',10)
end
title(sprintf('%s clusters with %.2f bandwidth', int2str(numClust), bandwidth))

end
