function [ H ] = rgbhist_fast2( I, nBins, normalize )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if size(I,3) ~= 3
    error('rgbhist_fast2:','Number of Sample, Input must be RGB')
end
if (nargin < 3)
    normalize = 0;
end
I = double(I);
H = zeros(3, nBins);
I = reshape(I, [size(I,1)*size(I,2) 3]);
for i = 1:size(I,1)
    point = floor(I(i,1:3) / (256/nBins)) + 1;
    H(1, point(1)) = H(1, point(1)) + 1;
    H(2, point(2)) = H(2, point(2)) + 1;
    H(3, point(3)) = H(3, point(3)) + 1;
end
H = H(:);
if normalize ~= 0
    H = H./ norm(H,normalize);
end
end

