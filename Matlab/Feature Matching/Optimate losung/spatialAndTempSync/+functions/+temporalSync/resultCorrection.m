function [ result ] = resultCorrection( result )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% result_in.
nbDiffImages = length(result);
nbWindows = size(result(1).differences,2); 

for i=fliplr(1:nbDiffImages)
    currentResult = result(i).differences;
    
    if i>nbDiffImages-2
        if numel(currentResult(currentResult == 0)) > numel(currentResult)/2 ||...
                ~isequal(size(currentResult), size(result(1).differences))
            %             result(end).differences = [];
            tmp = result;
            clear result;
            result = tmp(1:end-1)
            continue;
        end
    end
    
   
    % If the result of the first and/or last window differs from the
    % adjacent window... correct it
    if ~isequal(currentResult(:,1), currentResult(:,2))
%         result(i).differences(:,1) = currentResult(:,2);
        currentResult(:,1) = currentResult(:,2);
    end
    if ~isequal(currentResult(:,end), currentResult(:,end-1))
%         result(i).differences(:,end) = currentResult(:,end-1);
        currentResult(:,end) = currentResult(:,end-1);
    end
    
    
    % If there is one window, where the result differs from the result of both adjacent
    % windows, but the result of the two adjacent windows is equal
    % --> Correct the middle window
    for i2=2:nbWindows-1
        if ~isequal(currentResult(:,i2), currentResult(:,i2-1)) &&...
            ~isequal(currentResult(:,i2), currentResult(:,i2+1)) &&...
            isequal(currentResult(:,i2-1), currentResult(:,i2+1))
            currentResult(:,i2) = currentResult(:,i2+1);
        end
    end
    
    result(i).differences = currentResult;    
end




end

