function [cluster, W, W0] = IteratedSVM(D, N, initK, iterN, C, minMatch, sizeMatch)
    if (nargin < 3)
        initK = idivide(size(D, 1), int32(8));
    end
    if (nargin < 4)
        iterN = 6;
    end
    if (nargin < 5)
        C = 0.1;
    end
    if (nargin < 6)
        minMatch = 2;
    end
    if (nargin < 7)
        sizeMatch = 5;
    end


    d = size(D, 2);
    if (d ~= size(N, 2))
        error('D and N dimensions mismatch');
        return;
    end

    [D1, D2] = RandDivide(D);
    [N1, N2] = RandDivide(N);

    [tmpCenter, tmpErr, assign] = Kmeans(D1, initK);
    poss = ones(initK);
    for k = 1:initK
        cluster{k} = find(assign == k);
    end

    for iter = 1:iterN
        for k = 1:initK
            W{k} = [];
            W0{k} = [];

            if (poss(k) == 0) 
                continue;
            end

            positive = D1(cluster{k}, :);
            [w, w0] = SvmPrimal([N1; positive], ... 
                [-1 * ones(size(N1, 1), 1); ones(size(positive, 1), 1)], C);

            predict = [];
            for ii = 1:size(D2, 1)
                predict(ii) = dot(D2(ii, :), w) + w0;
            end

            if (length(find(predict > -1)) < minMatch)
                poss(k) = 0;
                continue;
            end

            W{k} = w;
            W0{k} = w0;
            
            cluster{k} = [];
            [sortValues, sortIndex] = sort(predict, 'descend');
            for ii = 1:sizeMatch
                if (sortValues(ii) > -1)
                    cluster{k}(ii) = sortIndex(ii);
                else
                    break;
                end
            end
            
            tmpD = D1;
            D1 = D2;
            D2 = tmpD;

            tmpN = N1;
            N1 = N2;
            N2 = tmpN;
        end
    end
    
    for kk = 1:initK
        if (length(W{kk}) > 0)
            predict = [];
            for ii = 1:size(D, 1)
                predict(ii) = dot(D(ii, :), W{kk}) + W0{kk};
            end

            [sortValues, sortIndex] = sort(predict, 'descend');
            for ii = 1:size(D, 1)
                if (sortValues(ii) > -1)
                    cluster{kk}(ii) = sortIndex(ii);
                else
                    break;
                end
            end
        else
            cluster{kk} = [];
        end
    end
end

function [D1, D2] = RandDivide(D)
    rand('seed', 0);
    n = size(D, 1);
    perm = randperm(n);
    mid = idivide(n, int32(2));
    D1 = D(1:mid, :);
    D2 = D(mid+1:n, :);
end
