%%Use this script to collect the information on distances between Cy3 and
%%Cy5 spots and the dapi isosurface. This is for analysis done with the
%%script version2 that did not contain the distance collection already.
% Modify as needed for Cy3 or Cy5 only data.

rootfolder = pwd; %the SpotsData folder inside rootCell
list_files = dir(fullfile(rootfolder, 'SpotsIsosurfPos*.mat'));

spotNEdistCy3 = struct('Pos',{}, 'Distance',{});
spotNEdistCy5 = struct('Pos',{}, 'Distance',{});

for i = 1:size(list_files)
    
    load(strcat(rootfolder,'\', list_files(i).name), 'coloccy3dapi','coloccy5dapi');
    
    dist3 = struct('Pos', list_files(i).name(13:end), 'Distance', coloccy3dapi(:,4));
    dist5 = struct('Pos', list_files(i).name(13:end), 'Distance', coloccy5dapi(:,4));

    spotNEdistCy3 = [spotNEdistCy3, dist3];
    spotNEdistCy5 = [spotNEdistCy5, dist5];
    
    clear dist3 dist5 coloccy3dapi coloccy5dapi;
end;

struct2csv(spotNEdistCy3, 'spotNEdistCy3.csv')
struct2csv(spotNEdistCy5, 'spotNEdistCy5.csv')