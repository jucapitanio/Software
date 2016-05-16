function [ spotsubset ] = stacksubsetBen( spotpointcoord, start, stop )
%stacksubset subset point coordnate files only for given Z stacks.

start = ((start + 5) * 1.84478) - 1.84478;
stop = ((stop + 5) * 1.84478) - 1.84478;
spotsubset=spotpointcoord(spotpointcoord(:,3)>start & spotpointcoord(:,3)<stop,:);


end

