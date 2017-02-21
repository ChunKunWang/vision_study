function output = loadImages(input_path)

in_names = dir(fullfile(input_path, '*.png'));
num = length(in_names);
images = cell(num, 1);
filenames = cell(num, 1);

for i = 1 : num
    %disp(i);
    images{i} = imresize(imread(fullfile(input_path, in_names(i).name)), [512, 512]);
    filenames{i} = in_names(i).name;
end

output = images';
end
