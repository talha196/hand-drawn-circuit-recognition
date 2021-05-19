function result = multisvmtest(models,test)
numClasses = length(models);
for k=1:numClasses
    if(svmclassify(models(k),test))
        break;
    end
end
result = k;
end