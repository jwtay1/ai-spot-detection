clearvars
clc

load('D:\Projects\Research\2022 Kralj Titers\MLtest\model0005_20220513.mat');

%%

imgSize = [96 96];
testDataFolder = 'D:\Projects\Research\2022 Kralj Titers\MLtest\realimages_100x100';

files = dir(fullfile(testDataFolder, '*.tif'));

%Test script on real data
%There are 38 test images

%Tile images 8 across

outputImg = cell(1, numel(files));

for iF = 1:numel(files)

    currI = imread(fullfile(files(iF).folder, files(iF).name));
    currI = currI(1:imgSize(1), 1:imgSize(2));
    prediction = semanticseg(currI, net);
    
    outputImg{iF} = showoverlay(currI, prediction == "spot");

end

out = imtile(outputImg);
imshow(out);