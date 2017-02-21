function [ gist, gistPCA ] = GistFeature( param,  varargin)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
disp('Compute Gist Feature  ');
dim = 512;
tic
gist = [];
gistPCA = [];
gistn = {};
SCORE = {};
for cnt = 1:nargin-1
    n = length(varargin{cnt});   %c=varargin{1}
    gistn{cnt} = zeros(n, dim);
    for i = 0:n-1
        [gistn{cnt}(i+1,:), ~] = LMgist(varargin{cnt}{i+1}, '', param);
    end
    [~,SCORE{cnt}] = princomp(gistn{cnt});
    gist = [gist; gistn{cnt}];
    gistPCA = [gistPCA; SCORE{cnt}];
end

toc 
end

