function createfigureBen(dapiiso, Vnormdapi, cy5iso, Vnormcy5, cy3dapinucleoli, cy3_spotStats_file)

rootfolder = pwd;

% Create figure
fig = figure('Visible', 'off');

% Create axes
axes1 = axes('Parent',fig,'DataAspectRatio',[1 1 1]);
view(axes1,[0.5 90]);
hold(axes1,'on');

pd = patch(dapiiso);
Vnormdapi;
pd.FaceColor = 'blue';
pd.EdgeColor = 'none';
daspect([1,1,1]) % Corrigir isso no make fig.
view(3); axis tight
camlight 
lighting gouraud
pd.FaceAlpha = 0.25;

hold on

pd = patch(cy5iso);
Vnormcy5;
pd.FaceColor = 'red';
pd.EdgeColor = 'none';
daspect([1,1,1]) % Corrigir isso no make fig.
view(3); axis tight
camlight 
lighting gouraud
pd.FaceAlpha = 0.25;

hold on

scatter3(cy3dapinucleoli(:,1),cy3dapinucleoli(:,2),cy3dapinucleoli(:,3),'MarkerEdgeColor','green','Marker','.');
whitebg('black');

set(fig, 'Visible', 'on'); 
savefig(fig, strcat(rootfolder,'\Cell plot images\',cy3_spotStats_file(5:9),'.fig'));
set(fig, 'Visible', 'off');

