%Make training datasets
clearvars
clc


%options
outputSz = [256 256];
particleSz = 0.5;
particleSzVar = 0.2;

particleAVar = 0.8;
amplitudeRange = 2;

numParticlesRange = [100 500];

polarity = 'dark';

numImages = 1000;

for cntImage = 1:numImages

    %Decide on number of particles
    numParticles = round(numParticlesRange(1) + ...
        (numParticlesRange(2) - numParticlesRange(1)) * rand(1));

    %Generate a series of coordinates - this is the ground truth
    xyPos = [(outputSz - 1) .* rand(numParticles, 2) + 1];

    %Generate the images
    outputI = zeros(outputSz);

    xGrid = 1:outputSz(2);
    yGrid = 1:outputSz(1);
    [xGrid, yGrid] = meshgrid(xGrid, yGrid);

    gtruth = false(outputSz);

    for ii = 1:numParticles

        outputI = outputI + ((1 - particleAVar) + (particleAVar) * rand(1) * amplitudeRange) * exp(-((xGrid - xyPos(ii, 1)).^2 + (yGrid -xyPos(ii, 2)).^2)/(2 * ((1 - particleSzVar) + (particleSzVar) * rand(1)) * particleSz(1)^2));

        gtruth(round(xyPos(ii, 2)), round(xyPos(ii, 1))) = true;

    end

    %Convert to uint16
    outputI = im2uint16(outputI);

    showoverlay(outputI, gtruth)
    keyboard

%     %Write to disk
%     imwrite(outputI, fullfile('validation', 'img', sprintf('img%04.0f.tif', cntImage)));
% 
%     %Save ground truth
%     imwrite(gtruth, fullfile('validation', 'gtruth', sprintf('img%04.0f.tif', cntImage)));


end

% imshow(imcomplement(outputI), [])
