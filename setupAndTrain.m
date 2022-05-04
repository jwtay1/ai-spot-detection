clearvars
clc

%Load data
imageDir = fullfile('training', 'img');
labelsDir = fullfile('training', 'gtruth');

imds = imageDatastore(imageDir);
classNames = ["spot", "background"];
labelIDs = [1 0];

pxds = pixelLabelDatastore(labelsDir, classNames, labelIDs);

imageSize = [256 256];
numClasses = 2;
lgraph = unetLayers(imageSize, numClasses);

ds = combine(imds, pxds);

options = trainingOptions('sgdm', ...
    'InitialLearnRate',1e-3, ...
    'MaxEpochs',20, ...
    'VerboseFrequency',10, ...
    'MiniBatchSize', 16);

net = trainNetwork(ds,lgraph,options);
