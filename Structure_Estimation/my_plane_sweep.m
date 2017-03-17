clc
clear
input_path = '../data/fountain_dense2/urd';
[images, num_im] = parse_input(input_path);
[Hight, Width, ~] = size(images{1}.im);

% camera transformation
ref_img_id = 6;
ref_image = images(ref_img_id); % choose one image as basement
compare_img_id = [4 5 7 8]; % check 4 neighboring images
scan_img_sets = images(compare_img_id);
depth = zeros(4, 2);

for i = 1 : 4
    % t2 - R2R1't1
    scan_img_sets{i}.T = ref_image{1}.T - ref_image{1}.Rotation * scan_img_sets{i}.Rotation' * scan_img_sets{i}.T;
    depth_table = measure_depth(scan_img_sets{i}.bd_min, scan_img_sets{i}.bd_max, ref_image{1});
    depth_map(i, 1) = min(depth_table(3,:));
    depth_map(i, 2) = max(depth_table(3,:));
end
depth_start = min(depth_map(:,1));
depth_end = min(depth_map(:,2));

n_disparity = 50;
NORMAL = [0 0 -1];
Sample = linspace(depth_start, depth_end, n_disparity);
disparity = linspace(1./depth_start, 1./depth_end, n_disparity); 

% plane sweeping
best_costs = zeros(Hight, Width) + realmax;
depth = zeros(Hight, Width);
figure; imshow(ref_image{1}.im);
title('Reference Image');

tic
for depth_idx = 1 : n_disparity
    disp(['Sweep ' num2str(depth_idx) ' at depth ' num2str(disparity(depth_idx))]);
    cur_cost = zeros(Hight, Width) + realmax;
    
    %compute cost for each source camera
    for src_idx = 1 : 4
        K2 = ref_image{1}.K;    
        K1 = scan_img_sets{src_idx}.K;
        R2 = ref_image{1}.Rotation; 
        R1 = scan_img_sets{src_idx}.Rotation;
        H = K2 * (R2 * R1' - scan_img_sets{src_idx}.T * NORMAL ./ Sample(depth_idx)) / K1;
        
        timg = imtransform(scan_img_sets{src_idx}.im,...
                            maketform('projective', H'),...
                            'XData', [1, Width],...
                            'YData', [1, Hight]);
        %aggregate matching cost
        cur_cost = min(cur_cost, mySSD(timg, ref_image{1}.im, 30));
    end
    
    new_idx = best_costs > cur_cost;
    depth(new_idx) = 1 ./ disparity(depth_idx);
    best_costs(new_idx) = cur_cost(new_idx);
    
    figure(n_disparity);
    imagesc(depth);axis image;drawnow;
end
toc

