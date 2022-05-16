clearvars
clc
load('Combined_extracted_wells.mat')


%%
imgSize = [100 100];

currImage = [8, 1];

I = collImgs{currImage(1), currImage(2)};

%Normalize I
I = double(I);
I = ((I - min(I(:))) ./ (max(I(:)) - min(I(:)))) * 65535;
I = uint16(I);

imshow(I, [])

%%
pos = [320 5668];

for iPos = 1:size(pos, 1)

    Icrop = I(pos(iPos, 2):(pos(iPos, 2) + imgSize(2) - 1), ...
        pos(iPos, 1):(pos(iPos, 1) + imgSize(1) - 1));

    imwrite(Icrop, sprintf('testImg_%.0f_%.0f_%.0f.tif', ...
        currImage(1), currImage(2), iPos));

end
