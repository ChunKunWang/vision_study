% Author: Johannes L. Schönberger, Jan-Michael Frahm <{jsch, jmf} at cs.unc.edu>

clear;
close all;
clc;

image1 = 'P1180210.mat';
image2 = 'P1180208.mat';

%image1 = 'P1180204.mat';
%image2 = 'P1180205.mat';

%image1 = 'P1180218.mat';
%image2 = 'P1180211.mat';

[projMatrix1, projMatrix2, points3D] = reconstructTwoViewModel(image1, image2, true);
