% hires_alignment_main_function
% Chun-Kun Wang (amos@cs.unc.edu)
clc; clear; close all;

%% set up parameters
in_path = './data_hires';
out_path = './output_hires';
infile = dir(fullfile(in_path, '*.tif'));
log = fullfile(out_path, 'log_hires.txt');
outfile = fopen(log,'w');

for i = 1:length(infile)
    fprintf('Input image %s: ', infile(i).name);
    image = imread(fullfile(in_path, infile(i).name));
    image = im2double(image);
    %figure; imshow(image);
    
    %% image alignment
    [R, G, B] = extract_hires_RGB(image);
    search_R = hires_pyramid(R, G);
    search_B = hires_pyramid(B, G);
    new_R = circshift(R, search_R);
    new_B = circshift(B, search_B);
    clear R; clear B;
    output = cat(3, new_R, G, new_B);
    %figure, imagesc(output), title(infile(i).name);
    
    %% record log and generate image
    [path, name, ext] = fileparts(infile(i).name);
    name = fullfile(out_path, ['hires_', name, '.jpg']);
    imwrite(output, name);
    fprintf(outfile, '[%s], Red offset: (%d, %d); Green offset: (%d, %d)\n', ...
        infile(i).name, search_R(1), search_R(2), search_B(1), search_B(2));
    fprintf('Done in %s\n', name);
end
fclose(outfile);

