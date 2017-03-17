function [images, num_im] = parse_input(input_path)
    im_name = dir(fullfile(input_path, '*.png'));
    im_camera = dir(fullfile(input_path, '*.png.camera'));
    im_bounding = dir(fullfile(input_path, '*.png.bounding'));
    im_P = dir(fullfile(input_path, '*.png.P'));

    num_im = numel(im_name);
    images = cell(num_im, 1);

    for i = 1 : num_im
        images{i}.im  = im2double(imread(fullfile(input_path,im_name(i).name)));

        f_bounding = fopen(fullfile(input_path, im_bounding(i).name));
        images{i}.bd_max = fscanf(f_bounding, '%f %f %f', 3);
        images{i}.bd_min = fscanf(f_bounding, '%f %f %f', 3);
        fclose(f_bounding);

        f_camera = fopen(fullfile(input_path, im_camera(i).name));
        temp = fscanf(f_camera, '%f');
        images{i}.K = reshape(temp(1:9),3,3);
        images{i}.K = images{i}.K';

        images{i}.Rotation = reshape(temp(13:21),3,3)';
        images{i}.Rotation = images{i}.Rotation';

        images{i}.Center = temp(22:24);
        images{i}.T = - images{i}.Rotation * images{i}.Center;
        fclose(f_camera);

        f_P =  fopen(fullfile(input_path, im_P(i).name),'r');
        images{i}.P = reshape(fscanf(f_P, '%f'),4,3)';
        fclose(f_P);
    end
end
