clear
clc

addpath(genpath('.'))
bandwidth = .5;

disp('loading images');
tic
datapath = '../data/castle_entry_dense/urd/';
img_c = loadImages(datapath);
datapath = '../data/fountain_dense/urd/';
img_f = loadImages(datapath);
datapath = '../data/herzjesu_dense/urd/';
img_h = loadImages(datapath);
toc

% GIST Parameters
clear param
param.imageSize = [512, 512];
param.orientationsPerScale = [8 8 8 8]; % number of orientations per scale
param.numberBlocks = 4;
param.fc_prefilt = 4;

[gist, gistPCA] = GistFeature(param, img_c, img_f, img_h);
c_h = ColorFeature( 10, 2,  img_c, img_f, img_h);

tic
[clustCent,point2cluster,clustMembsCell] = MeanShiftCluster(c_h', bandwidth);
%[clustCent,point2cluster,clustMembsCell] = MeanShiftCluster(gistPCA', bandwidth);
toc

PlotFigure(c_h', bandwidth, clustCent, clustMembsCell);
%PlotFigure(gistPCA', bandwidth, clustCent, clustMembsCell);
