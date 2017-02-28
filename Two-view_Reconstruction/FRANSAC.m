% Chun-Kun Wang (amos@cs.unc.edu)
function [F,inliers]=FRANSAC(matchedPoints1, matchedPoints2,probSol,threshold)
%
%  matchedPoints1, matchedPoints2 matrix of size no_matches x 2 containing
%                                 the x, y coordinates of all matched 
%                                 features in image 1,2 respectively
%
%  probSol  probability of having seen a good solution before stopping. 
%           Typically,this should be 0.95 to 0.99
%  
%  threshold inlier threshold typical ranges between 1 und 4 pixels
%
%

% 
    current = [];
    best_inliers = [];
    [Row, Col] = size(matchedPoints1);
    
    % pick up 8 points, 4 pairs randomly
    idx = randperm(Row, 8);
    Points1 = matchedPoints1(idx, :);
    Points2 = matchedPoints2(idx, :);
    
    % Hartley Normalization
    [Shift_Points1, T1] = Normalize(Points1);
    [Shift_Points2, T2] = Normalize(Points2);
        
    % generate F
    F1 = generate_F(Shift_Points1, Shift_Points2);     
    % get the eigenvector, with the smallest singular value
    [uf,sf,vf] = svd(F1);
    % generate fundamental matrix
    F_norm_prime = uf*diag([sf(1) sf(5) 0])*(vf');
    F = T2' * F_norm_prime * T1;
     
    for i =1:Row
        p1 = matchedPoints1(i,:)';
        p1(3,1) = 1;
        p2 = matchedPoints2(i,:)';
        p2(3,1) = 1;
        temp = p2' * F * p1;
        
        if(abs(temp) <= threshold)
            current(end+1)=i;
        end
            
        % figure out largest set of inliers
        if( size(current,2) > size(best_inliers,2) )
            best_inliers = current;
        end
    end               
  
    inliers = best_inliers';
    Points1 = matchedPoints1(inliers,:);
    Points2 = matchedPoints2(inliers,:);
    
    % Hartley Normalization
    [Shift_Points1, T1] = Normalize(Points1);
    [Shift_Points2, T2] = Normalize(Points2);
        
    % generate F
    F1 = generate_F(Shift_Points1, Shift_Points2);  
    % get the eigenvector, with the smallest singular value
    [uf,sf,vf] = svd(F1);
    % generate fundamental matrix
    F_norm_prime = uf*diag([sf(1) sf(5) 0])*(vf');
    F= T2' * F_norm_prime* T1;
end

% reference: http://www.mathworks.com/matlabcentral/fileexchange/27541-fundamental-matrix-computation
function [ F1 ] = generate_F( points1, points2 )
    Row = size(points1,1);
    new_1 = [points1 ones(Row,1)];
    new_1 = new_1';
    new_2 = [points2 ones(Row,1)];
    new_2 = new_2';
    W = [ repmat(new_2(1,:)',1,3) .* new_1', repmat(new_2(2,:)',1,3) .* new_1', new_1'];
    [U,S,V] = svd(W);
    F1 = reshape(V(:,end),3,3)';
end

function [ output T ] = Normalize( input )
    Row = size(input,1);
    new_input = [input ones(Row,1)];
    new_input = new_input';
    center = mean(new_input,2);
    
    dist = mean(sqrt(sum((new_input - repmat(center,1,Row)).^2,1)));
    
    T = [sqrt(2)/dist, 0, -sqrt(2)/dist*center(1); ...
              0, sqrt(2)/dist, -sqrt(2)/dist*center(2); ... 
              0, 0, 1];

    output = T * new_input;
    output = output';
    output(:,3) = [];
end

