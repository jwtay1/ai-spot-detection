%Make training datasets
clearvars
clc

%options
outputSz = [96 96];
particleSz = [0.5; 1; 3; 5; 7; 20; 30; 40];
numParticlesRange = [...
    15 80; ...
    10 40; ...
    4 12; ...
    2 8; ...
    1 3; ...
    1 2; ...
    1 1; ...
    1 1];

particleSzVar = 0.2;

particleAVar = 0.8;
amplitudeRange = 2;

outputDir = 'training_96x96_subset';

polarity = 'dark';

numImages = 100;  %Each

ctr = 0;

for iP = 1:numel(particleSz)
    fprintf('Particles %.0f/%.0f\n', iP, numel(particleSz));

    for cntImage = 1:numImages

        %Decide on number of particles
        numParticles = round(numParticlesRange(iP, 1) + ...
            (numParticlesRange(iP, 2) - numParticlesRange(iP, 1)) * rand(1));

        %Generate a series of coordinates - this is the ground truth
        xyPos = [(outputSz - 1) .* rand(numParticles, 2) + 1];

        %Generate the images
        outputI = zeros(outputSz);

        xGrid = 1:outputSz(2);
        yGrid = 1:outputSz(1);
        [xGrid, yGrid] = meshgrid(xGrid, yGrid);

        gtruth = false(outputSz);

        for ii = 1:numParticles

            outputI = outputI + ((1 - particleAVar) + (particleAVar) * rand(1) * amplitudeRange) * exp(-((xGrid - xyPos(ii, 1)).^2 + (yGrid -xyPos(ii, 2)).^2)/(2 * ((1 - particleSzVar) + (particleSzVar) * rand(1)) * particleSz(iP)^2));

            gtruth(round(xyPos(ii, 2)), round(xyPos(ii, 1))) = true;

        end

        %     imshow(outputI, [])
        %     keyboard

        %Convert to uint16
        outputI = im2uint16(outputI);

        if strcmpi(polarity, 'dark')
            outputI = imcomplement(outputI);
        end

        %     showoverlay(outputI, gtruth)
        %     keyboard

        %Write to disk
        if ~exist(fullfile(outputDir, 'img'), 'dir')
            mkdir(fullfile(outputDir, 'img'));
        end
        imwrite(outputI, fullfile(outputDir, 'img', sprintf('img%04.0f.tif', ctr)), ...
            'Compression', 'none');

        %Save ground truth
        if ~exist(fullfile(outputDir, 'gtruth'), 'dir')
            mkdir(fullfile(outputDir, 'gtruth'));
        end

        ctr = ctr + 1;
        imwrite(gtruth, fullfile(outputDir, 'gtruth', sprintf('img%04.0f.tif', ctr)), ...
            'Compression', 'none');


    end
end
% imshow(imcomplement(outputI), [])
