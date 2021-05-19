function models = multisvmtrain(TrainingSet,GroupTrain)
u=unique(GroupTrain);
numClasses=length(u);
for k=1:numClasses
    %Use one vs rest.
    group=(GroupTrain==u(k));
    models(k) = svmtrain(TrainingSet,group);
end
end