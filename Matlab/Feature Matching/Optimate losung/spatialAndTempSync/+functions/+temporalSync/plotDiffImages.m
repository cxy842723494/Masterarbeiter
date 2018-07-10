function [ output_args ] = plotDiffImages( Images, result )
%PLOTDIFFIMAGES Summary of this function goes here
%   Detailed explanation goes here
% figure; 
% imshow(Images,[]);
% ax = gca;
imSize = size(Images);
nbLines = imSize(1);
nbPictures = size(Images,4);
% nbWindows = ceil(imSize(1)/windowHeight);

nbWindows = size(result(1).differences,2);
windowHeight = floor( nbLines / nbWindows);

figure;
ax1 = gcf;
imshow(Images(:,:,1),[]); hold on;

slider = uicontrol('style', 'slider', 'Value', 1, 'Min',1, 'Max',nbPictures,...
    'position',[20 0 200 15], 'Units','pixels',...
    'SliderStep',[1/(nbPictures-1), 1/(nbPictures-1)],'Callback',@slidercallback);
text_imageNb = uicontrol('style', 'text', 'String', '1/12', 'Units', 'pixels',...
        'position',[250 0 80 15]);
textFields_Diff = [];
textFields_CorrDelta = [];


imagePlotPosition = ax1.Children(end).Position;
imageHeightPerLine = imagePlotPosition(4)/imSize(1);
plotLinesPeripherals(1);

function slidercallback(~,~)
    Value = round(get(slider, 'Value'));
    imshow(Images(:,:,Value),[]);
    plotLinesPeripherals(Value);
end

function plotLinesPeripherals(imageNb)
    % update diff.-image nb
    set(text_imageNb, 'String', [int2str(imageNb) '/' int2str(nbPictures)]);
    
    % Horizontal window borders
    i = windowHeight + 1;
    while i<imSize(1);
%         line([ax1.Children(end).XLim(1),ax1.Children(end).XLim(2)],[i,i], 'Color', [0 230 0]./255, 'Linewidth',2);
          line([ax1.Children(end).XLim(1),ax1.Children(end).XLim(2)],[i,i], 'Color', [0 230 0]./255);
        i = i + windowHeight;
    end  
    
    % Diff.-Image-Numbers
    if isempty(textFields_Diff)
        % generate the textfields...
        for i=1:nbWindows
            color = [0 0.5 0];
            if i<nbWindows && sum((result(imageNb).differences(:,i) - result(imageNb).differences(:,i+1)) == 0) ~= 2
                color = [1 0 0];
            elseif i>1 && sum((result(imageNb).differences(:,i) - result(imageNb).differences(:,i-1)) == 0) ~= 2
                color = [1 0 0];
            end
            textFields_Diff(i) = uicontrol('style', 'text', 'String', [int2str(result(imageNb).differences(2,i) ) ...
                ' - ' int2str(result(imageNb).differences(1,i))], 'Units', 'normalized',...
                'Fontsize', 11, 'ForegroundColor',color,...
                'position',[0.9 imagePlotPosition(2) + imagePlotPosition(4) - (i-1)*windowHeight*imageHeightPerLine - ...
                0.5*windowHeight*imageHeightPerLine- 0.0162 0.05 0.027]);
            
%             textFields_CorrDelta(i) = uicontrol('style', 'text', 'String', num2str(result(imageNb).corrCoeffs_y(i)), ...
%                 textFields_CorrDelta(i) = uicontrol('style', 'text', 'String', num2str(result(imageNb).corrCoeffs_v(1,i)), ...
%                 'Fontsize', 11, 'ForegroundColor',[0 0 0], 'Units', 'normalized', 'position',[0.94, imagePlotPosition(2)...
%                 + imagePlotPosition(4) - (i-1)*windowHeight*imageHeightPerLine - 0.5*windowHeight*imageHeightPerLine...
%                 - 0.0162, 0.05, 0.027]);
            
        end
    else
        %... update the textfields
        for i=1:nbWindows
            
            color = [0 0.5 0];
            if i<nbWindows && sum((result(imageNb).differences(:,i) - result(imageNb).differences(:,i+1)) == 0) ~= 2
                color = [1 0 0];
            elseif i>1 && sum((result(imageNb).differences(:,i) - result(imageNb).differences(:,i-1)) == 0) ~= 2
                color = [1 0 0];
            end
            
            set(textFields_Diff(i), 'String', [int2str(result(imageNb).differences(2,i) ) ' - ' int2str(result(imageNb).differences(1,i))]);
            set(textFields_Diff(i), 'ForegroundColor', color);
%             set(textFields_CorrDelta(i), 'String', num2str(result(imageNb).corrCoeffs_v(1,i)));
%             set(textFields_CorrDelta(i), 'String', num2str(result(imageNb).corrCoeffs_y(i)));
        end
            
    end
end


end
