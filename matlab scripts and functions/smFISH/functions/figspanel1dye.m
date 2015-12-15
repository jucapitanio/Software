function [  ] = figspanel1dye( dapiiso, Vnorm, cy3dapi, cy3mid, cy3_spotStats_file )
%figspanel Create figure with 4 panels showing spot localization and
%hitogram distribution of distances from spots to NE isosurface.

rootfolder = pwd;
fig = figure('Visible', 'off');

% Graph 1 all spots with DAPI surface. Cytoplasmic red, Nuclear yellow.
subplot(1,3,1)
title('All negvRNA spots - Nuclear yellow, Cytoplasmic red')
scatter3(cy3dapi(cy3dapi(:,4) > 0,1),cy3dapi(cy3dapi(:,4) > 0,2),cy3dapi(cy3dapi(:,4) > 0,3),'MarkerEdgeColor','yellow','Marker','.');
hold on;
whitebg('black');
hold on;
scatter3(cy3dapi(cy3dapi(:,4) < 0,1),cy3dapi(cy3dapi(:,4) < 0,2),cy3dapi(cy3dapi(:,4) < 0,3),'MarkerEdgeColor','red','Marker','.');
hold on;
pd = patch(dapiiso);
Vnorm;
pd.FaceColor = 'blue';
pd.EdgeColor = 'none';
daspect([1,1,1]) % Corrigir isso no make fig.
view(3); axis tight
camlight 
lighting gouraud
pd.FaceAlpha = 0.5;

% Graph 2 mid spots plotted with all of DAPI surface. Cytoplasmic red, Nuclear yellow.
subplot(1,3,2)
title('Mid 10 stacks negvRNA spots - Nuclear yellow, Cytoplasmic red')
scatter3(cy3mid(cy3mid(:,4) > 0,1),cy3mid(cy3mid(:,4) > 0,2),cy3mid(cy3mid(:,4) > 0,3),'MarkerEdgeColor','yellow','Marker','.');
hold on;
whitebg('black');
hold on;
scatter3(cy3mid(cy3mid(:,4) < 0,1),cy3mid(cy3mid(:,4) < 0,2),cy3mid(cy3mid(:,4) < 0,3),'MarkerEdgeColor','red','Marker','.');
hold on;
pd = patch(dapiiso);
Vnorm;
pd.FaceColor = 'blue';
pd.EdgeColor = 'none';
daspect([1,1,1]) % Corrigir isso no make fig.
view(3); axis tight
camlight 
lighting gouraud
pd.FaceAlpha = 0.5;

% Graph 3 histogram of distances from spots to NE, all spots 
subplot(1,3,3)
title('All negvRNA spots distance to NE')
hB = histfit(cy3dapi(:,4),30,'kernel');
hB(1).EdgeColor = 'yellow';
hB(1).FaceColor = 'yellow';
hB(2).Color = 'yellow';
hB(1).FaceAlpha = 0.25;

set(fig, 'Visible', 'on'); 
savefig(fig, strcat(rootfolder,'\Cell plot images\',cy3_spotStats_file(5:9),'B.fig'));
set(fig, 'Visible', 'off');

end

