% Possible full radical distortion function 
% Chun-Kun Wang (amos@cs.unc.edu)
clc
clear all

im = imread('./distort/MyDistort040.jpg');
im = im2double(im);
K1 = 0.05;
K4 = 0.05;
K5 = 0.05;
[m, n, ~]   = size(im);
distortim = zeros(m, n, 3);

for i = 1 : m
    ut = ( 2 * i - m )/n; % normalized [ut,vt] camera coordinates
    r1 = ut^2;
    for j = 1 : n
        vt = ( 2 * j - n )/n;
        r2 = r1 + vt^2;
        % u = (1+K1r^2)*ut+2K4uv+2K5(r^2+2u^2)
        u  = ( 1+ K1*r2 )*ut + 2*K4*ut*vt + 2*K5*(r2 + 2*ut^2);
        % v = (1+K1r^2)*vt+K4
        v  = ( 1+ K1*r2 )*vt + 2*K4*(r2 + 2*vt^2) + 2*K5*ut*vt; 
        x  = round((u*n + m) / 2); % resume original [x,y] coordinates 
        if ( x < 1 || x > m )
            continue;
        end
        y  = round((v*n + n ) / 2);
        if ( y < 1 || y > n )
           continue;
        end
        if distortim(i,j,1) == 0
            distortim(i,j,:) = im(x,y,:);
        else
            distortim(i,j,:) = (distortim(i,j,:)+im(x,y,:))/2;
        end
    end
end

imwrite(distortim,'Possible040.jpg');
