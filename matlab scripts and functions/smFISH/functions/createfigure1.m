function createfigure1(X1, Y1, X2, Y2, C3, C4)
%CREATEFIGURE1(X1, Y1, X2, Y2, C2, C3, C4)
%  X1:  Xpos cy3
%  Y1:  Ypos cy3
%  S1:  set to 49 (7x7point squared dots)
%  C1:  set to green
%  X2:  Xpos cy5
%  Y2:  Ypos cy5
%  C2:  set to red
%  S2:  set to 49 (7x7point squared dots)
%  C3:  Col indicating nuc or cyto (4th) for cy3
%  C4:  Col indicating nuc or cyto (4th) for cy5

%  Auto-generated by MATLAB on 01-Sep-2015 14:23:11

% Create figure
figure1 = figure;

% Create subplot
subplot1 = subplot(1,2,1,'Parent',figure1);
%% Uncomment the following line to preserve the X-limits of the axes
xlim(subplot1,[0 1000]);
ylim(subplot1,[0 1000]);
hold(subplot1,'on');

% Create scatter
scatter(X1,Y1,49,'green','DisplayName','cy3','Parent',subplot1,'Marker','.');

% Create scatter
scatter(X2,Y2,49,'red','DisplayName','cy5','Parent',subplot1,'Marker','.');

% Create legend
legend(subplot1,'show');

% Create subplot
subplot2 = subplot(1,2,2,'Parent',figure1);
%% Uncomment the following line to preserve the X-limits of the axes
xlim(subplot2,[0 1000]);
%% Uncomment the following line to preserve the Y-limits of the axes
ylim(subplot2,[0 1000]);
hold(subplot2,'on');

% Create scatter
scatter(X1,Y1,49,C3,'Parent',subplot2,'Marker','.');

% Create scatter
scatter(X2,Y2,49,C4,'DisplayName','data2','Parent',subplot2,'Marker','.');
