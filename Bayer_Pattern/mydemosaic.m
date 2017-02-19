% My demosaic by using interpolation 
% Chun-Kun Wang (amos@cs.unc.edu)
clc; clear; close all;

%%  read image file and creat R, G, and B matrix
infile = imread('crayons_mosaic.bmp');
infile = im2double(infile);
[m, n] = size(infile);
R = infile.*repmat([1 0; 0 0], [m/2, n/2]);
G = infile.*repmat([0 1; 1 0], [m/2, n/2]);
B = infile.*repmat([0 0; 0 1], [m/2, n/2]);

%% design R, G, and B filters
R_f = [0.25, 0.5 , 0.25;
       0.5,  1.0 , 0.5 ;
       0.25, 0.5 , 0.25];
G_f = [0,    0.25, 0   ;
       0.25, 1.0 , 0.25;
       0,    0.25, 0   ];
B_f = [0.25, 0.5 , 0.25;
       0.5,  1.0 , 0.5 ;
       0.25, 0.5 , 0.25];

%% filter image and reunion R, G, and B into one image
R = imfilter(R, R_f);
G = imfilter(G, G_f);
B = imfilter(B, B_f);

%figure,imagesc(R),title('R');
%figure,imagesc(G),title('G');
%figure,imagesc(B),title('B');
outfile(:,:,1)=R; outfile(:,:,2)=G; outfile(:,:,3)=B;
figure, imagesc(outfile), title('Linear interpolation');

%% computing a map of squared differences
check = imread('crayons.jpg');
check = im2double(check);
diff = 0;
diff = diff + (check(:,:,1) - outfile(:,:,1)).^ 2;
diff = diff + (check(:,:,2) - outfile(:,:,2)).^ 2;
diff = diff + (check(:,:,3) - outfile(:,:,3)).^ 2;
figure,imagesc(diff),title('Squared difference');
colorbar;axis equal;

%% compute the average per-pixel errors
average = mean(diff(:));
fprintf('Average per-pixel errors for image is %f.\n', average);

%% compute the maximum per-pixel errors
[M, I] = max(diff(:));
[I_row, I_col] = ind2sub(size(diff),I);
fprintf('Maximum per-pixel errors is %f at (%d, %d).\n', M, I_row, I_col);

%% Show a close-up of maximum pixel error
radius = 20;
closeup_check = check(I_row - radius : I_row + radius, I_col - radius : I_col + radius, :);
closeup_outfile = outfile(I_row - radius : I_row + radius, I_col - radius : I_col + radius, :);

figure;
subplot(2, 2, 1);
imshow(closeup_outfile);
title('Max close-up of mydemosaic');
subplot(2, 2, 2);
imshow(closeup_check);
title('Max close-up of original image');

%% Show a close-up of edge
radius = 10;
E_row = radius+1; 
E_col = radius+1;
closeup_check = check(E_row - radius : E_row + radius, E_col - radius : E_col + radius, :);
closeup_outfile = outfile(E_row - radius : E_row + radius, E_col - radius : E_col + radius, :);
subplot(2, 2, 3);
imshow(closeup_outfile);
title('Edge close-up of mydemosaic');
subplot(2, 2, 4);
imshow(closeup_check);
title('Edge close-up of original image');
