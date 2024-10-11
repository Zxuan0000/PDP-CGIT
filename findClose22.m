function maxCenters = findClose22(allCenters, centernow)
    % Initialize remainingIndices
    allCenters = allCenters';
    remainingIndices = 1:size(allCenters, 1);
    
    % Preallocate maxCenters matrix
    maxCenters = zeros(size(centernow, 1), size(centernow, 2));
    
    for k = 1:size(centernow, 1)
        % Concatenate centernow row to allCenters
        x = [allCenters(remainingIndices, :); centernow(k,:)];
        
        % Normalize x
        for i = 1:size(x, 1)
            x(i,:) = x(i,:) / (x(i,1) + 0.0001);
        end
        
        % Update data to x
        data = x;
        
        n = size(data, 1);
        ck = data(n,:);
        m1 = size(ck, 1);
        bj = data(1:n-1,:);
        m2 = size(bj, 1);
        
       % r = zeros(m1, n); % Initialize r vector
        
        for i = 1:m1
            te = zeros(m2, size(data, 2)); % Initialize te matrix
            for j = 1:m2
                te(j,:) = bj(j,:) - ck(i,:);
            end
            jc1 = min(min(abs(te')));
            jc2 = max(max(abs(te')));
            rho = 0.5;
            ksi = (jc1 + rho * jc2) ./ (abs(te) + rho * jc2);
            rt = sum(ksi') / size(ksi, 2);
            r(i,:) = rt; % Store rt in r vector
        end
        
        [~, maxIndex] = max(r);
        clear r;
        maxCenters(k, :) = allCenters(remainingIndices(maxIndex), :);
        
        % Remove selected index from remainingIndices
        remainingIndices(maxIndex) = [];
    end
end
