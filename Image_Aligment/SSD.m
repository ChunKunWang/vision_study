% Chun-Kun Wang (amos@cs.unc.edu)

function [search] = SSD(template_1, template_2)
    %% decide search range
    radius = floor(0.05 * min(size(template_2,1), size(template_2,2)));
    ssd = zeros(2*radius + 1);
    
   %% computing SSD
    for row = -radius : radius
        for col = -radius : radius
            roll = circshift(template_1, [row, col]);
            ssd(row + radius + 1,col + radius + 1) = ...
                sum((template_2(:)-roll(:)).^2);
        end
    end
    
    %% find max ssd value and pop up final offset
    [~, max_ind] = max(ssd(:));
    [new_r, new_c] = ind2sub(size(ssd), max_ind);
    search = [new_r - radius - 1, new_c - radius - 1];
end
