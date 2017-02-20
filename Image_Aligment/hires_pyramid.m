% Chun-Kun Wang (amos@cs.unc.edu)

function [search] = hires_pyramid(template_1, template_2)
    if size(template_1, 1) > 500
        I1 = impyramid(template_1, 'reduce'); 
        I2 = impyramid(template_2, 'reduce'); 
        search = hires_pyramid(I1, I2);
    else
        search = hires_NCC(template_1, template_2).*8;
    end
end

