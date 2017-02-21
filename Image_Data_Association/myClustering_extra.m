clear
clc

addpath(genpath('.'))
bandwidth = .6;

disp('loading images');
tic
datapath = '../data/castle_entry_dense/urd/';
img_p10 = loadImages(datapath);
datapath = '../data/castle_dense/urd/';
img_p19 = loadImages(datapath);
toc

% GIST Parameters
clear param
param.imageSize = [512, 512];
param.orientationsPerScale = [8 8 8 8]; % number of orientations per scale
param.numberBlocks = 4;
param.fc_prefilt = 4;

[gist, gistPCA] = GistFeature(param, img_p10, img_p19);
c_h = ColorFeature( 10, 2,  img_p10, img_p19);

tic
[clustCent,point2cluster,clustMembsCell] = MeanShiftCluster(c_h',bandwidth);
toc

PlotFigure(c_h', bandwidth, clustCent, clustMembsCell);
