% Chun-Kun Wang (amos@cs.unc.edu)

function [R, G, B] = extract_RGB(input)
    %% set Hight and Width and Hight is 1/3 of original image
    [H, W] = size(input);
    H = floor(H/3);
    
    %% filter order from top to bottom is BGR
    temp_B = input(1:H,:);
    temp_G = input(H+1:H*2,:);
    temp_R = input(H*2+1:H*3,:);
    %figure,imagesc(temp_B),title('temp_B');
    %figure,imagesc(temp_R),title('temp_R');
    %figure,imagesc(temp_G),title('temp_G');
    
    %% eliminate frame
    frame_H = floor(0.08 * H);
    frame_W = floor(0.08 * W);
    R = temp_R(1 + frame_H : H - frame_H, 1 + frame_W : W - frame_W);
    G = temp_G(1 + frame_H : H - frame_H, 1 + frame_W : W - frame_W);
    B = temp_B(1 + frame_H : H - frame_H, 1 + frame_W : W - frame_W);
    %figure,imagesc(R),title('R');
    %figure,imagesc(G),title('G');
    %figure,imagesc(B),title('B');

end
