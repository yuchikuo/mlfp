d = 50;
sizeDR = 50;
sizeDS = 10;
sizeDC = 5;
sizeN = 100;

rand('seed', 0);

N = rand(sizeN, d);
D = rand(sizeDR, d);
center = [];
for ii=1:sizeDC
    center(ii, :) = rand(1, d);
    D(sizeDR+(ii-1)*sizeDS : sizeDR+ii*sizeDS-1, :) = ...
        ones(sizeDS, 1) * center(ii, :) + ...
        0.02 * (rand(sizeDS, d) - 0.01 * ones(sizeDS, d));
end

[cluster, W, W0] = IteratedSVM(D, N);

wsize = 0;
w = [];
for ii=1:length(W)
    instW = W{ii};
    if (length(instW) > 0)
        wsize = wsize + 1;
        w(wsize, :) = instW;
        cluster{ii}
    end
end

center
w
