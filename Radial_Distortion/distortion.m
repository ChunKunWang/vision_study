% My radical distortion function 
% Chun-Kun Wang (amos@cs.unc.edu)
clc
clear all
% load variables: BackgroundPointCloudRGB,ForegroundPointCloudRGB,K,crop_region,filter_size)
load ../data/data.mat

output_path='./distort';
mkdir('distort');

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
K1 = linspace(-1, 1, frames); % defined in the range [-1,1]

%% use these frames to reproduce a .avi video
outputVideo = VideoWriter(fullfile('Radial_Dist.avi'));
outputVideo.FrameRate = 15;
open(outputVideo);
log = fopen('log.txt', 'w');

%% generate Dolly zoom image and Distortion effect
for step=1:frames
    tic
    fname       = sprintf('MyDistort%03d.jpg',step);
    display(sprintf('\nGenerating %s',fname));
    %% change focal len of x, y
    K(1,1)      = 400 / foreX * (rateZ + move(3, step));
    K(2,2)      = 640 / foreY * (rateZ + move(3, step));
    check           = camera + move(:, step);
    M           = K*[R check];
    fprintf(log, '[%2.f] distance: %.2f, focal length: (%.0f, %.0f), K1: %.2f\n', step, -check(3), K(1,1), K(2,2), K1(step));
    im          = PointCloud2Image(M,data3DC,crop_region,filter_size);
    %% check frame size, mmwrite only accept even frame size
    [m, n, ~]   = size(im);
    if mod(m, 2) ~= 0
        im(1,:,:) = [];
        m = m-1;
    end
    if mod(n, 2) ~= 0
        im(:,1,:) = [];
        n = n-1;
    end
    %figure; imshow(im);
    %% Radical Distortion body
    distortim = zeros(m, n, 3);
    for i = 1 : m
        ut = ( 2 * i - m )/n; % normalized [ut,vt] camera coordinates
        r1 = ut^2;
        for j = 1 : n
            vt = ( 2 * j - n )/n;
            r2 = r1 + vt^2;
            u  = ( 1+K1(step) * r2 ) * ut; % u = (1+K1r^2)*ut
            v  = ( 1+K1(step) * r2 ) * vt; % v = (1+K1r^2)*vt
            x  = round((u*n + m) / 2); % resume original [x,y] coordinates 
            if ( x < 1 || x > m )
                continue;
            end
            y  = round((v*n + n ) / 2);
            if ( y < 1 || y > n )
                continue;
            end
            if distortim(i,j,1) == 0
                distortim(i,j,:) = im(x,y,:);
            else
                distortim(i,j,:) = (distortim(i,j,:)+im(x,y,:))/2;
            end
        end
    end
    %% generate frames and video
    writeVideo(outputVideo,distortim);
    fname       = fullfile(output_path, fname);
    imwrite(distortim,fname);
    toc    
end

fclose(log);
close(outputVideo);

%% convert .avi to .wmv by using mmread & mmwrite
clear;
display('Convert .avi to .wmv');
addpath('../lib/mmread', '../lib/mmwrite');
[video, audio]  = mmread('Radial_Dist.avi');
mmwrite('Radial_Dist.wmv',video);
display('Done!');
