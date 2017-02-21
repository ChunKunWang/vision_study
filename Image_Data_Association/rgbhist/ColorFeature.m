function [ ch ] = ColorFeature( nBins, normalize,  varargin)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
disp('Compute Color Feature  ');
tic
dim = nBins^3;
chn={};
ch = [];
for cnt = 1:nargin-2
    n = length(varargin{cnt});   %c=varargin{1}
    chn{cnt} = zeros(n, dim);
    for i = 0:n-1
        chn{cnt}(i+1,:) = rgbhist_fast(varargin{cnt}{i+1}, nBins,normalize);
    end
    ch = [ch; chn{cnt}];
end
toc

end


