function [bits, picsampledzb, picsampledzr, number] = decodeFrame_Dec17(diffpic,X,Y,filterf,thresh)
    if nargin < 4 || isempty(filterf)
        filterf = [1 2 1];
    end
    if nargin < 5 || isempty(thresh)
        thresh = 0 % 
    end
    %% Interpolation filtering
    picfilteredr = conv2(filterf,filterf,diffpic(:,:,1),'same');
    picfilteredb = conv2(filterf,filterf,diffpic(:,:,3),'same');
    %% Sample image at detected block centers, load sampled data to main memory
    samplesz = sub2ind(size(picfilteredr),round(Y),round(X));
    picsampledzr = gather(picfilteredr(samplesz));
    picsampledzb = gather(picfilteredb(samplesz));
    %% Truncate static border
    % M.O.: We know that the pattern is identical between U and V channels,
    % so the product of the bit polarity is always one. Since bit intensity
    % is identical to reliability, we can compute a weighted average. For
    % arbitrary data, positive and negative bits have approximately equal
    % probability, so the average should be close to zero. For patterns
    % held constant over entire lines, the average comes very close to 1.
    indicesz = zeros(1,4);
    indicesz(1) = find(sum(picsampledzr.*picsampledzb,2)./...
                    sum(abs(picsampledzr.*picsampledzb),2)<thresh,1,'first');
    indicesz(2) = find(sum(picsampledzr.*picsampledzb,2)./...
                    sum(abs(picsampledzr.*picsampledzb),2)<thresh,1,'last');
    indicesz(3) = find(sum(picsampledzr.*picsampledzb,1)./...
                    sum(abs(picsampledzr.*picsampledzb),1)<thresh,1,'first');
    indicesz(4) = find(sum(picsampledzr.*picsampledzb,1)./...
                    sum(abs(picsampledzr.*picsampledzb),1)<thresh,1,'last');
    % Now that the static patterns on the edge are found, we can extract
    % the remaining modulated area to only get the encoded data. As the
    % green channel is most affected by crosstalk and does not contain
    % significant information, U and V are extracted directly from the blue
    % and red channels. Data is then linearized to represent the serial
    % stream the image was generated from.
%     bitszu_twoDim = picsampledzb(indicesz(1):indicesz(2),...
%                             indicesz(3):indicesz(4));
%     bitszv_twoDim = picsampledzr(indicesz(1):indicesz(2),...
%                             indicesz(3):indicesz(4));
    bitszu_twoDim = picsampledzb(3:end-2,3:end-2);
    bitszv_twoDim = picsampledzr(3:end-2,3:end-2);
    bitszu = bitszu_twoDim(:);
    bitszv = bitszv_twoDim(:);
    %% Output bits
    % The first and last eight blocks contain an 8-bit frame number,
    % redundantly transmitted in two opposing corners and both channels for
    % reliability.
    %% First performe a framewise deinterleaving at this point
%   Seed: 7151 aus Christians Simulation
    st2 = RandStream('mt19937ar','seed',7151);
    bitszu_deinterleaved = randdeintrlv(bitszu,st2);
    reset(st2);
    bitszv_deinterleaved = randdeintrlv(bitszv,st2);
    reset(st2);    
    numberdata = round(heaviside(bitszu_deinterleaved(1:8)+bitszu_deinterleaved(end-7:end)+bitszv_deinterleaved(1:8)+bitszv_deinterleaved(end-7:end)));
%     numberdata = round(heaviside(bitszv_deinterleaved(1:8)+bitszv_deinterleaved(end-7:end)));
    number = bi2de(numberdata.','left-msb')+1;
    % The remaining data contains the data fragment. The first half is in
    % the U channel, the second half in the V channel.
    bits = [bitszu_deinterleaved(9:end-8),bitszv_deinterleaved(9:end-8)];
end

