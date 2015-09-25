function [ cy3subset, cy5subset ] = stacksubset( cy3pointcoord, cy5pointcoord, start, stop )
%stacksubset subset point coordnate files only for given Z stacks.

start = start * 0.24 * 9.2239;
stop = stop * 0.24 * 9.2239;
cy3subset=cy3pointcoord(cy3pointcoord(:,3)>start & cy3pointcoord(:,3)<stop,:);
cy5subset=cy5pointcoord(cy5pointcoord(:,3)>start & cy5pointcoord(:,3)<stop,:);

end

