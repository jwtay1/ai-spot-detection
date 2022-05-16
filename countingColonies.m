clearvars
clc
load('Combined_extracted_wells.mat');

%%
%Note: collImgs = Collated images, each row is a different dilution from
%densest to least dense. 4 cols are technical replicates. collStart = row
%where tip of pipette was detected

I = collImgs{1, 1};
Icrop = I(collStart{1, 1}:(collStart{1, 1} + 100), :);
imshow(Icrop, [])

%Identify the pipette tip
mask = Icrop < 870;
mask = imfill(mask, 'holes');
figure; imshow(mask)

spotMask = detectSpots(Icrop, mask, 3, -5, 1);
spotMask = imclearborder(spotMask);
imshow(spotMask)

spotData = regionprops(spotMask, 'Centroid', 'MajorAxisLength');

figure;
imshow(Icrop, [])
hold on
for iSpot = 1:numel(spotData)
    plot(spotData(iSpot).Centroid(1), spotData(iSpot).Centroid(2), 'x')
end
hold off


keyboard


%% Add refined spot detection

imgSize = size(Icrop);
imageIn = Icrop;

tic;
%Declare the 2D Gaussian surface model
gauss2Dmodel = fittype('- A * exp(-( ((xx - B).^2)/(2*D^2) + ((yy - C).^2)/(2*E.^2) )) + F',...
    'independent', {'xx', 'yy'});

%Generate the x-data and y-data axes

avMajorAxisLen = mean([spotData.MajorAxisLength])/2;

fitSize = round([1.5 * avMajorAxisLen 1.5 * avMajorAxisLen]);

if rem(fitSize(1), 2) == 0
    fitSize(1) = fitSize(1) + 1;
end

if rem(fitSize(2), 2) == 0
    fitSize(2) = fitSize(2) + 1;
end

% fitSize = fitSize + 1;

xdata = 1:fitSize(1);
ydata = 1:fitSize(2);
[xdata, ydata] = meshgrid(xdata, ydata);

%Initialize a matrix of NaNs (not-a-numbers) to store the position data
storeFitData = struct;
nP = 0;  %Counter of number of found particles

for iP = 1:numel(spotData)
    
    currSpotCenter = round(spotData(iP).Centroid);

    %Check that spot is not too close to edge of images
    if (any((currSpotCenter - fitSize) < 0)) || ...
            (any( (currSpotCenter + fitSize) > [imgSize(2), imgSize(1)] ))
%         keyboard
% 
%         imshow(imageIn, [])
%         hold on
%         plot(currSpotCenter(1), currSpotCenter(2), 'rx')
%         hold off

%         keyboard
        continue
    end

    %Crop a 5x5 image around each particle
    Icrop = double(...
        imageIn( (currSpotCenter(2) - floor(fitSize(1)/2)):(currSpotCenter(2) + floor(fitSize(1)/2)),...
        (currSpotCenter(1) - floor(fitSize(2)/2)):(currSpotCenter(1) + floor(fitSize(2)/2)) ));
    
%     imshow(Icrop, [])

    %Fit the surface - with a guess to the starting values
    [fitObj, gof] = fit([xdata(:), ydata(:)], Icrop(:), gauss2Dmodel, ...
        'StartPoint', [min(Icrop(:)), 3, 3, 2, 2, mean(Icrop(:))]);
    

%     plot(fitObj, [xdata(:), ydata(:)], Icrop(:))
%     keyboard

    %Save the fitted positions (remember to correct for the offset since we
    %cropped the image)
    storeFitData(nP + 1).Amplitude = fitObj.A;
    storeFitData(nP + 1).Center = [fitObj.B, fitObj.C] + [currSpotCenter(1) - 2, currSpotCenter(2) - 2];
    storeFitData(nP + 1).WidthX = fitObj.D;
    storeFitData(nP + 1).WidthY = fitObj.E;
    storeFitData(nP + 1).Background = fitObj.F;
    storeFitData(nP + 1).R2 = gof.rsquare;
    
    %Increment the counter
    nP = nP + 1;
end

toc


%% Plotting

figure;
imshow(imageIn, [])
hold on
for iSpot = 1:numel(storeFitData)
    plot(storeFitData(iSpot).Center(1), storeFitData(iSpot).Center(2), 'o')
end

for iSpot = 1:numel(spotData)
    plot(spotData(iSpot).Centroid(1), spotData(iSpot).Centroid(2), 'x')
end

hold off



