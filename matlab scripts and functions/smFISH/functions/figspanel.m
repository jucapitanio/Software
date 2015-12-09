function [  ] = figspanel( dapiiso, Vnorm, coloccy3dapi, coloccy5dapi, cy3midcoloc, cy5midcoloc, cy3_spotStats_file )
%figspanel Create figure with 4 panels showing spot localization and
%hitogram distribution of distances from spots to NE isosurface.

rootfolder = pwd;
fig = figure('Visible', 'off');

% Graph 1, all spots plotted with DAPI surface. Cy3 yellow, Cy5 red.
subplot(2,2,1)
title('All posvRNA spots - Cy3 yellow, Cy5 red')
scatter3(coloccy3dapi(:,1),coloccy3dapi(:,2),coloccy3dapi(:,3),'MarkerEdgeColor','yellow','Marker','.');
hold on;
whitebg('black');
scatter3(coloccy5dapi(:,1),coloccy5dapi(:,2),coloccy5dapi(:,3),'MarkerEdgeColor','red','Marker','.');
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

% Graph 2 all spots with DAPI surface. Cytoplasmic red, Nuclear yellow.
subplot(2,2,2)
title('All posvRNA spots - Nuclear yellow, Cytoplasmic red')
scatter3(coloccy3dapi(coloccy3dapi(:,4) > 0,1),coloccy3dapi(coloccy3dapi(:,4) > 0,2),coloccy3dapi(coloccy3dapi(:,4) > 0,3),'MarkerEdgeColor','yellow','Marker','.');
hold on;
whitebg('black');
scatter3(coloccy5dapi(coloccy5dapi(:,4) > 0,1),coloccy5dapi(coloccy5dapi(:,4) > 0,2),coloccy5dapi(coloccy5dapi(:,4) > 0,3),'MarkerEdgeColor','yellow','Marker','.');
hold on;
scatter3(coloccy5dapi(coloccy5dapi(:,4) < 0,1),coloccy5dapi(coloccy5dapi(:,4) < 0,2),coloccy5dapi(coloccy5dapi(:,4) < 0,3),'MarkerEdgeColor','red','Marker','.');
hold on;
scatter3(coloccy3dapi(coloccy3dapi(:,4) < 0,1),coloccy3dapi(coloccy3dapi(:,4) < 0,2),coloccy3dapi(coloccy3dapi(:,4) < 0,3),'MarkerEdgeColor','red','Marker','.');
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

% Graph 3 mid spots plotted with all of DAPI surface. Cytoplasmic red, Nuclear yellow.
subplot(2,2,3)
title('Mid 10 stacks posvRNA spots - Nuclear yellow, Cytoplasmic red')
scatter3(cy3midcoloc(cy3midcoloc(:,4) > 0,1),cy3midcoloc(cy3midcoloc(:,4) > 0,2),cy3midcoloc(cy3midcoloc(:,4) > 0,3),'MarkerEdgeColor','yellow','Marker','.');
hold on;
whitebg('black');
scatter3(cy5midcoloc(cy5midcoloc(:,4) > 0,1),cy5midcoloc(cy5midcoloc(:,4) > 0,2),cy5midcoloc(cy5midcoloc(:,4) > 0,3),'MarkerEdgeColor','yellow','Marker','.');
hold on;
scatter3(cy5midcoloc(cy5midcoloc(:,4) < 0,1),cy5midcoloc(cy5midcoloc(:,4) < 0,2),cy5midcoloc(cy5midcoloc(:,4) < 0,3),'MarkerEdgeColor','red','Marker','.');
hold on;
scatter3(cy3midcoloc(cy3midcoloc(:,4) < 0,1),cy3midcoloc(cy3midcoloc(:,4) < 0,2),cy3midcoloc(cy3midcoloc(:,4) < 0,3),'MarkerEdgeColor','red','Marker','.');
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

% Graph 4 histogram of distances from spots to NE, all spots 
subplot(2,2,4)
title('All posvRNA spots distance to NE - Cy3 yellow, Cy5 red')
hA = histfit(coloccy5dapi(:,4),30,'kernel');
hA(1).EdgeColor = 'red';
hA(1).FaceColor = 'red';
hA(2).Color = 'red';
hA(1).FaceAlpha = 0.25;
hold on;
hB = histfit(coloccy3dapi(:,4),30,'kernel');
hB(1).EdgeColor = 'yellow';
hB(1).FaceColor = 'yellow';
hB(2).Color = 'yellow';
hB(1).FaceAlpha = 0.25;

set(fig, 'Visible', 'on'); 
savefig(fig, strcat(rootfolder,'\Cell plot images\',cy3_spotStats_file(5:9),'B.fig'));
set(fig, 'Visible', 'off');

end

