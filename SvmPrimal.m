function [w, w0, ksi, optVal, FLAG, OUTPUT] = SvmPrimal(X, Y, C)
    n = size(X, 1);
    d = size(X, 2);
    H = zeros(d + 1 + n);
    H(1:d, 1:d) = eye(d);
    f = [zeros(d + 1, 1); C*ones(n, 1)];
    A = zeros(2 * n, d + 1 + n);
    A(1:n, 1:d) = -(Y * ones(1, d)) .* X;
    A(1:n, d+1) = -Y;
    A(1:n, d+2:d+1+n) = -eye(n);
    A(n+1:2*n, d+2:d+1+n) = -eye(n);
    b = [-ones(n, 1); zeros(n, 1)];
    opts = chooseOptimizer();
    [optX, optVal, FLAG, OUTPUT] = quadprog(H, f, A, b, [], [], [], [], [], opts);
    w = optX(1:d)';
    w0 = optX(d+1);
    ksi = optX(d+2:n+d+1)';
end

function opts = chooseOptimizer()
    optim_ver = ver('optim');
    optim_ver = str2double(optim_ver.Version);
    if optim_ver >= 6
        opts = optimset('Algorithm', 'interior-point-convex');
    else
        opts = optimset('Algorithm', 'interior-point', 'LargeScale', 'off', 'MaxIter', 2000);
    end
end
