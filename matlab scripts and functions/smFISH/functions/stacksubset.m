function [ spotsubset ] = stacksubset( spotpointcoord, start, stop )
%stacksubset subset point coordnate files only for given Z stacks.

start = ((start + 5) * 2.213736) - 2.213726;
stop = ((stop + 5) * 2.213736) - 2.213726;
spotsubset=spotpointcoord(spotpointcoord(:,3)>start & spotpointcoord(:,3)<stop,:);


end

