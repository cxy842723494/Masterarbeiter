function [ dataMatrix, bitsPerFrame ,nbDataFrames ] = createDataMatrix_twoChannel( data, packetHeader, x_delta, y_delta, blockSize, borderType )
%CREATEDATAMATRIX_SINGLECHANNEL Summary of this function goes here
%   Detailed explanation goes here
    if nargin < 6 || isempty(borderType)
        borderType = 0;
    end
    switch(borderType)
        case 1
            borderLeft = 2;
            borderRight = 2;
            borderTop = 2;
            borderBottom = 2;
        case 2
            borderLeft = 0;
            borderRight = 0;
            borderTop = 3;
            borderBottom = 3;
        case 3
            borderLeft = 3;
            borderRight = 3;
            borderTop = 3;
            borderBottom = 3;
        otherwise
            borderLeft = 0;
            borderRight = 0;
            borderTop = 0;
            borderBottom = 0;
    end
    length_data = length(data);
%     length_packetHeader = length(packetHeader);
    length_frameHeader = 8;
    bitsPerLine = floor(x_delta/blockSize);
    linesPerFrame = floor(y_delta/blockSize);
    bitsPerFrame = bitsPerLine * linesPerFrame;
    
    % data Bits per Frame except the first frame, which additionally contains the packet header
    dataBitsPerLine = bitsPerLine - (borderLeft+borderRight);
    dataLinesPerFrame = linesPerFrame - (borderTop+borderBottom);
    dataBitsPerFrame = dataBitsPerLine * dataLinesPerFrame - (2*length_frameHeader);
%     dataBitsInFirstFrame = dataBitsPerFrame - length_packetHeader;
    
   % Determine the number of frames necessary for the data
    nbDataFrames = ceil(length_data/dataBitsPerFrame);
%     if (length_data-dataBitsInFirstFrame-((nbDataFrames-1) * dataBitsPerFrame) > 0)
%         nbDataFrames = nbDataFrames+1;
%     end
    nbDataFrames = nbDataFrames + mod(nbDataFrames,2);
    
    if nbDataFrames < 2*256 % Data fits into 256 frames        
        dataMatrix = zeros(nbDataFrames, bitsPerFrame);
        st2 = RandStream('mt19937ar', 'seed', 7151); % Define Seed for frame wise interleaving
        for i=1:nbDataFrames
            % generate binary frame number, 8 Bit -> 0..255 (TODO: grey code?)
            frameNb = fliplr(de2bi(floor((i-1)/2)));
            frameNb = [zeros(1,8-length(frameNb)) frameNb]*2-1;

            dataStartIndex = (i-1)*dataBitsPerFrame + 1;
            dataEndIndex = dataStartIndex + dataBitsPerFrame - 1;
            
            %frameEvenness = 2*mod(floor(i/2),2)-1;
            frameEvenness = 1;

            % check, if data ends a) before this frame, b) in this frame
            % c) after the frame
            if length_data < dataStartIndex
                datarow = [frameNb randi([0 1],1,dataBitsPerFrame)*2-1 frameNb]; 
            elseif length_data >= dataStartIndex && length_data < dataEndIndex 
                dataEndIndex = length(data);
                datarow = [frameNb data(dataStartIndex:dataEndIndex) randi([0 1],1,dataStartIndex + dataBitsPerFrame - 1 - length_data)*2-1 frameNb];
            elseif length_data >= dataEndIndex
                datarow = [frameNb data(dataStartIndex:dataEndIndex) frameNb];
            end
            datarow_interleaved = double(randintrlv(datarow, st2));
            reset(st2);
%             datarow_interleaved = datarow;

            datagrid = reshape(datarow_interleaved,dataBitsPerLine,dataLinesPerFrame);
            grid = zeros(bitsPerLine,linesPerFrame);
            grid(borderLeft+(1:dataBitsPerLine),borderTop+(1:dataLinesPerFrame)) = datagrid;
            switch(borderType)
                case 1
                    grid([1 end],2:end-1) = 1;
                    grid(2:end-1,[1 end]) = 1;
                    grid([1 end],[1 end]) = -1;
                    grid([2 end-1],[2 end-1]) = -1;
                    grid(3:end-2,[2 end-1]) = (2*mod(1:dataBitsPerLine,2).'-1)*[1 -1];
                    grid([2 end-1],3:end-2) = [1;-1]*(2*mod(1:dataLinesPerFrame,2)-1);
                case 2
                    grid = [frameEvenness*ones(1,3*bitsPerLine) datarow_interleaved  frameEvenness*(2*repmat(mod(1:bitsPerLine,2),1,3)-1)];
                otherwise
            end
            dataMatrix(i,:) = grid(:).';
        end
    else
        dataMatrix = 0;
    end

end

