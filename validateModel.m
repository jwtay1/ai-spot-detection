clearvars
clc

load model001_20220504.mat

imdsTruth = imageDatastore('validation\img');
pxdsTruth = pixelLabelDatastore('validation\gtruth', ["spot", "background"], [1, 0]);
dsTruth = combine(imdsTruth, pxdsTruth);

testImage = readimage(imdsTruth, 1);
%%
C = semanticseg(testImage, net);

B = labeloverlay(testImage, C);
imshow(B)