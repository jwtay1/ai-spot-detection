function [maskOut, imageOut] = identifyPipette(imageIn)
%IDENTIFYPIPETTE  Identify the edges of the pipette in the image
%
%  M = IDENTIFYPIPETTE(I) will return the mask of the region inside the
%  pipette.

%Compute the gradient magnitude of the image
Gmag = imgradient(imageIn);

%Mask the image
maskOut = Gmag > (0.01 * max(Gmag(:)));

%Clean up the mask
maskOut = imfill(maskOut, 'holes');
maskOut = bwareaopen(maskOut, 100);

%Erode slightly to remove the edges
maskOut = imerode(maskOut, strel('disk', 10));

%Generate an image of only the pipette interior
if nargout > 1
    imageOut = zeros(size(imageIn));
    imageOut(maskOut) = imageIn(maskOut);
end

end