clearvars
clc

imageDir = fullfile('training', 'img');
labelsDir = fullfile('training', 'gtruth');

imds = imageDatastore(imageDir);
classNames = ["spot", "background"];
labelIDs = [1 0];

pxds = pixelLabelDatastore(labelsDir, classNames, labelIDs);

imageSize = [256 256];
numClasses = 2;
lgraph = unetLayers(imageSize, numClasses);

%%

%Read in an image
counts = countEachLabel(pxds);
histogram('Categories', counts.Name, 'BinCounts', counts.PixelCount)

%%

I = readimage(imds, 35000);
imshow(I, [])