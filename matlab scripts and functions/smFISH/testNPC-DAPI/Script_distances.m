Alldist = [];
for i = 1:61
    Alldist = [Alldist; spotNEdistCy5(i).Distance];
end;
histogram(Alldist(Alldist(:,1) > -100));

dist05 = size(Alldist(Alldist(:,1) > -5),1) / size(Alldist,1);
dist10 = size(Alldist(Alldist(:,1) > -10),1) / size(Alldist,1);
dist15 = size(Alldist(Alldist(:,1) > -15),1) / size(Alldist,1);
dist20 = size(Alldist(Alldist(:,1) > -20),1) / size(Alldist,1);
distwithin05 = size(Alldist(Alldist(:,1) > -5 & Alldist(:,1) < 5),1) / size(Alldist,1);
distwithin10 = size(Alldist(Alldist(:,1) > -10 & Alldist(:,1) < 10),1) / size(Alldist,1);
max(Alldist);

test = Alldist(Alldist(:,1) > -100),1);
%%
dist05 = size(Alldist(Alldist(:,1) > -5),1) / size(Alldist,1);
dist10 = size(Alldist(Alldist(:,1) > -10),1) / size(Alldist,1);
dist15 = size(Alldist(Alldist(:,1) > -15),1) / size(Alldist,1);
dist20 = size(Alldist(Alldist(:,1) > -20),1) / size(Alldist,1);
distwithin05 = size(Alldist(Alldist(:,1) > -5 & Alldist(:,1) < 5),1) / size(Alldist,1);
distwithin10 = size(Alldist(Alldist(:,1) > -10 & Alldist(:,1) < 10),1) / size(Alldist,1);