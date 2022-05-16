clearvars
clc

%Load data
imageDir = fullfile('training_96x96', 'img');
labelsDir = fullfile('training_96x96', 'gtruth');

imds = imageDatastore(imageDir);
classNames = ["background", "spot"];
labelIDs = [0, 1];

pxds = pixelLabelDatastore(labelsDir, classNames, labelIDs);

imageSize = [96 96];
numClasses = 2;
lgraph = unetLayers(imageSize, numClasses, ...
    'EncoderDepth', 4, ...
    'NumFirstEncoderFilters', 64);

ds = combine(imds, pxds);

options = trainingOptions('sgdm', ...
    'InitialLearnRate',1e-6, ...
    'MaxEpochs', 10, ...
    'VerboseFrequency', 100, ...
    'MiniBatchSize', 8);

net = trainNetwork(ds,lgraph,options);

save('model0005_20220513.mat','net','options')