% my_ncc_alignment_main_function
% Chun-Kun Wang (amos@cs.unc.edu)
clc; clear; close all;

%% set up parameters
in_path = './data';
out_path = './output';
infile = dir(fullfile(in_path, '*.jpg'));
log = fullfile(out_path, 'log_ncc.txt');
outfile = fopen(log,'w');

for i = 1:length(infile)
    fprintf('Input image %s: ', infile(i).name);
    image = imread(fullfile(in_path, infile(i).name));
    image = im2double(image);
    %figure; imshow(image);
    
    %% image alignment
    [R, G, B] = extract_RGB(image);
    search_R = NCC(R, G);
    search_B = NCC(B, G);
    new_R = circshift(R, search_R);
    new_B = circshift(B, search_B);
    output = cat(3, new_R, G, new_B);
    %figure, imagesc(output), title(infile(i).name);
    
    %% record log and generate image
    [path, name, ext] = fileparts(infile(i).name);
    name = fullfile(out_path, ['ncc_', name, '.jpg']);
    imwrite(output, name);
    fprintf(outfile, '[%s], Red offset: (%d, %d); Green offset: (%d, %d)\n', ...
        infile(i).name, search_R(1), search_R(2), search_B(1), search_B(2));
    fprintf('Done in %s\n', name);
end
fclose(outfile);
