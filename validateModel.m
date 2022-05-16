clearvars
clc

load model004_20220506.mat

%%
% imdsTruth = imageDatastore('training_64x64\img');
% pxdsTruth = pixelLabelDatastore('training_64x64\gtruth', ["spot", "background"], [1, 0]);
% dsTruth = combine(imdsTruth, pxdsTruth);
% 
% testImage = readimage(imdsTruth, 5);
% 
% C = semanticseg(testImage, net);
% 
% B = labeloverlay(testImage, C);
% imshow(C == "spot", [])

%%

I = imread('test.tif');

Icrop = I(1:64, 1:64);

Icrop = double(Icrop);
Icrop = Icrop ./ max(Icrop(:));
Icrop = uint16(Icrop * 65535);

imshow(Icrop)

C = semanticseg(Icrop, net);
B = labeloverlay(Icrop, C);
imshow(B)
