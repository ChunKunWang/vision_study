% My Dolly Zoom function 
% Chun-Kun Wang (amos@cs.unc.edu)
clc
clear all
% load variables: BackgroundPointCloudRGB,ForegroundPointCloudRGB,K,crop_region,filter_size)
load ../data/data.mat

output_path='./images';
mkdir('images');

data3DC = {BackgroundPointCloudRGB,ForegroundPointCloudRGB};
R       = eye(3);
move    = [0 0 -0.25]';

%% extract foreground object parameters
foreX = range(ForegroundPointCloudRGB(1,:));
%backW = range(BackgroundPointCloudRGB(1,:));
foreY = range(ForegroundPointCloudRGB(2,:));
%backH = range(BackgroundPointCloudRGB(2,:));
foreZ = mean(ForegroundPointCloudRGB(3,:));
%backD = mean(BackgroundPointCloudRGB(3,:));

%% extract foreground object by multiplying by K
foreObj = [ForegroundPointCloudRGB(1,:);...
           ForegroundPointCloudRGB(2,:);...
           ForegroundPointCloudRGB(3,:)];
Image = K * foreObj; %[3x3] * [3xN] = [3xN]

%% get ratio of projected image
rateX = Image(1,:)./Image(3,:); % x/z
rateY = Image(2,:)./Image(3,:); % y/z
% a bounding box 400 by 640
rateZ1 = foreZ * range(rateX) / 400;
rateZ2 = foreZ * range(rateY) / 640;
rateZ = (rateZ1+rateZ2)/2;

%% set up the parameters, how to move camera 
frames = 75;
camera = [0; 0; rateZ - foreZ];
move = linspace(0, rateZ - foreZ - 1, frames);
move = [zeros(2, frames); move];

%% use these frames to reproduce a .avi video
outputVideo = VideoWriter(fullfile('DollyZoom.avi'));
outputVideo.FrameRate = 15;
open(outputVideo);
log = fopen('log.txt', 'w');

%% generate Dolly zoom image
for step=1:frames
    tic
    fname       = sprintf('MyOutput%03d.jpg',step);
    display(sprintf('\nGenerating %s',fname));
    %% change focal len of x, y
    K(1,1)      = 400 / foreX * (rateZ + move(3, step));
    K(2,2)      = 640 / foreY * (rateZ + move(3, step));
    t           = camera + move(:, step);
    M           = K*[R t];
    fprintf(log, '[%2.f] distance: %.2f, focal length: (%.0f, %.0f)\n', step, -t(3), K(1,1), K(2,2));
    im          = PointCloud2Image(M,data3DC,crop_region,filter_size);

    %% check frame size, mmwrite only accept even frame size
    [m, n, ~]   = size(im);
    if mod(m, 2) ~= 0
        im(1,:,:) = [];
    end
    if mod(n, 2) ~= 0
        im(:,1,:) = [];
    end
    %figure; imshow(im);
    %% generate frames and video
    writeVideo(outputVideo,im);
    fname       = fullfile(output_path, fname);
    imwrite(im,fname);
    toc    
end

fclose(log);
close(outputVideo);

%% convert .avi to .wmv by using mmread & mmwrite
clear;
display('Convert .avi to .wmv');
addpath('../lib/mmread', '../lib/mmwrite');
[video, audio]  = mmread('DollyZoom.avi');
mmwrite('DollyZoom.wmv',video);
display('Done!');
