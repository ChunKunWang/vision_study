% Chun-Kun Wang (amos@cs.unc.edu)
function [idxs] = PutativeMatchSURF(features1,features2)
%
%  features1 matrix of size no-features x 64 which in the i-th row has 
%            the values of the descriptor of the i-th feature of the first
%            image
%  features2 the feature descriptors for the second image
%
%  idxs      matrix of size no matches x 2 with each row consisting of the
%            feature index for the first image in the first column and the 
%            matching features index in the second image. If a feature does
%            not match no row is provided for the feature

    idxs = [];
    Dstd = pdist2(features1, features2, 'euclidean');
    [new_Dstd,idx] = sort(Dstd,2);
    [M, N] = size(Dstd);

    %new_Dstd(1,1)
    %idx(1,2)
    %Dstd(1,idx(1,2))
    for i=1:M
        threshold = new_Dstd(i,1)/Dstd(i,idx(i,2));
        if threshold < 0.5
            idxs = [idxs; i idx(i,1)];
        end
    end

% showMatchedFeatures(features1, features2,'montage','Parent',ax);
end
