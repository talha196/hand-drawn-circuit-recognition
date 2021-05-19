function localBwImg = Locally_adaptive_Threshold(inputimage)
%Modified Lecture code
[row, col] = size(inputimage);
level = 0.1;
stepSize = 16;
varThresh = 0.0025;

% Perform locally adaptive thresholding
localBwImg = ones(row, col);
uniformMask = zeros(row, col);
threshIm = zeros(int32(row / stepSize),int32(col / stepSize));
for i = 1: floor(row / stepSize)
    % Get indices for row
    rowStep = (i - 1) * stepSize + 1 : i * stepSize;
    rowTile = (i - 1) * stepSize + 1 : (i + 1) * stepSize;
    if i == floor(row / stepSize)
        rowTile = (i-2) * stepSize + 1 : i * stepSize;
    end
    
    % Calculate Otsu's threshold for row
    for j = 1: floor(col / stepSize)
        % Get indices for column    
        colStep = (j - 1) * stepSize + 1 : j * stepSize;
        colTile = (j - 1) * stepSize + 1 : (j + 1) * stepSize;
        if j == floor(col / stepSize)
            colTile = (j - 2) * stepSize + 1 : j * stepSize;
        end

        % Calculate local variance
        step = inputimage(rowStep, colStep); 
        varStep = var(step(:));

        % Calculate local Otsu's threshold
        tile = inputimage(rowTile, colTile);
        localThresh = graythresh(tile);
        
        % Threshold based on local Ostu's threshold
        if (varStep > varThresh)
            localBwImg(rowStep, colStep) = im2bw(step, localThresh);
            uniformMask(rowStep, colStep) = ones(stepSize, stepSize);
            threshIm(i, j) = localThresh;
            
        % Threshold based on local mean
        else
            localMean = mean(tile(:));
            threshIm(i, j) = 0;
            if (localMean > level)
                localBwImg(rowStep, colStep) = ones(stepSize, stepSize);
            else
                localBwImg(rowStep, colStep) = zeros(stepSize, stepSize);
            end
            uniformMask(rowStep, colStep) = zeros(stepSize, stepSize);
        end

    end % j
end % i
end