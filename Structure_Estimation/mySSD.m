function [cost] = mySSD(I1, I2, window)
    cost = abs(I1(:,:,1) - I2(:,:,1)) .^ 2 + ...
           abs(I1(:,:,2) - I2(:,:,2)) .^ 2 + ...
           abs(I1(:,:,3) - I2(:,:,3)) .^ 2;

    h = ones(window);
    cost = imfilter(cost, h);
end
