% Kmean algorithm for clustering
% Author: surwdkgo
% Input: data: n x d matrix of n input points in d simensions
%        sizeK: k, number of clusters
%        converge: convergence threshold (optional)
%        center: initial cluster center locations (optional)
% Output: center: k x d matrix of final cluster center locations
%         err: L2-error of final cluster assignment
%         assign: n-vector reporting the cluster assignment (1~k) of data points
%         niter: number of iterations required for convergence

function [center, err, assign, niter] = Kmeans(data, sizeK, converge, center)    
    if (nargin < 3)
        converge = 1e-8;
    end
    if (nargin < 4)
        rand('seed', 0);
        vard = sqrt(sum(data .^ 2) / size(data, 1));
        center = 2*rand(sizeK, size(data, 2))-1;
        for ii = 1:sizeK
            center(ii, :) = center(ii, :) .* vard;
        end
    end

    dim = size(data, 2);
    n = size(data, 1);

    niter = 0;
    err = inf;

    while true
        nerr = 0;
        csum = zeros(sizeK, dim);
        ccount = zeros(sizeK, 1);
        for ii = 1:n
            minv = inf;
            for jj = 1:sizeK
                l2 = norm(center(jj, :) - data(ii, :));
                if (l2 < minv)
                    minv = l2;
                    minp = jj;
                end
            end
            assign(ii) = minp;
            nerr = nerr + minv;
            csum(minp, :) = csum(minp, :) + data(ii, :);
            ccount(minp) = ccount(minp) + 1;
        end

        flag = false;
        for ii = 1:sizeK
            if (ccount(ii) == 0) 
                center(ii, :) = data(int32(floor(rand() * n)+1), :);
                flag = true;
            end
        end
        if (flag)
            continue;
        end
        
        if (nerr > err - converge)
            break;
        end
        niter = niter + 1;
        err = nerr;
        
        for ii = 1:sizeK
            center(ii, :) = csum(ii, :) / ccount(ii);
        end
    end
end
