function result = spearman(x, y)
    n = length(x); % 假设 x 和 y 的长度相同
    diff = x - y;
    result = 1.0 - 6.0 * sum(diff.^2) / (n * (n^2 - 1));
end
