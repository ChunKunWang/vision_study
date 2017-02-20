% Chun-Kun Wang (amos@cs.unc.edu)

function [search] = NCC(template_1, template_2)
    %% decide search range
    radius = floor(0.05 * min(size(template_2,1), size(template_2,2)));
    ncc = zeros(2*radius + 1);
    
   %% computing NCC
    for row = -radius : radius
        for col = -radius : radius
            roll = circshift(template_1, [row, col]);
            ncc(row + radius + 1,col + radius + 1) = ...
                dot(template_2(:),roll(:))/norm(template_2(:))/norm(roll(:));
        end
    end
    
    %% find max ncc value and pop up final offset
    [~, max_ind] = max(ncc(:));
    [new_r, new_c] = ind2sub(size(ncc), max_ind);
    search = [new_r - radius - 1, new_c - radius - 1];
end
