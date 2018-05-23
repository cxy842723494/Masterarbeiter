classdef FinderPattern
    properties
        posX
        posY
        estimatedModuleSize
        count
    end
    methods
        function obj = FinderPattern(x, y, moduleSize, c)
            if nargin == 4
                obj.posX = x;
                obj.posY = y;
                obj.estimatedModuleSize = moduleSize;
                obj.count = c;
            end
        end
        
        function result = aboutEquals(obj, moduleSize, y, x)
            % Determines if this finder pattern "about equals" a finder
            % pattern at the stated position and size -- meaning, it is
            % at nearly the same center with nearly the same size
            result = false;
            if (abs(y - obj.posY) <= moduleSize && ...
                    abs(x - obj.posX) <= moduleSize)
                moduleSizeDiff = abs(moduleSize - obj.estimatedModuleSize);
                if (moduleSizeDiff <= 1 || ...
                        moduleSizeDiff <= obj.estimatedModuleSize)
                    result = true;
                end
            end
        end
        
        function newObj = combineEstimate(obj, i, j , newModuleSize)
           % Combines this object's current estimate of a finder pattern
           % position and module size with a new estimate. It retunrs a
           % new FinderPattern object containing a weighted average based
           % on count.
           combinedCount = obj.count + 1;
           combinedX = (obj.count * obj.posX + j) / combinedCount;
           combinedY = (obj.count * obj.posY + i) / combinedCount;
           combinedModuleSize = (obj.count * obj.estimatedModuleSize + ...
               newModuleSize) / combinedCount;
           newObj = FinderPattern(combinedX, combinedY, ...
               combinedModuleSize, combinedCount);
        end
    end
end
