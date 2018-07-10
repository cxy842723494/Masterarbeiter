function [BER,bitbuffer_corrected, dataMatrix] = restorefile_Dec17(bitbuffer, blocksize)
n=255;
k=205;
    H = dvbs2ldpc(4/5);
    N = size(H,2);
    K = diff(size(H));
    dec = comm.LDPCDecoder(H, 'DecisionMethod', 'Soft decision');
    
    softbits = bitbuffer(:);
    
    %% Decode the first block to obtain the header; 
    firstBlock = softbits(1:N);
    firstBlock_Decoded_soft = dec.step(firstBlock);
            
    packetheader = heaviside(firstBlock_Decoded_soft(1:40) + firstBlock_Decoded_soft(41:80));
    filelength = 0;
    namelength = 0;
    headlength = 0;
    for l=1:24
        filelength = filelength * 2;
        filelength = filelength+packetheader(l);
    end
    for l=25:32
        namelength = namelength * 2;
        namelength = namelength+packetheader(l);
    end
    for l=33:40
        headlength = headlength * 2;
        headlength = headlength+packetheader(l);
    end
    namebits = heaviside(firstBlock_Decoded_soft(81:80+namelength*8)...
                        +firstBlock_Decoded_soft(81+namelength*8:80+namelength*16));
    filename = char(bi2de(reshape(namebits,8,[]).','left-msb')).';
    codelength = ceil((filelength + 2*(namelength + 5))*8/K)*N; %packetHeader and filename are aencoded 2x 
%     if codelength > length(softbits)
%         disp('Header Corruption: invalid file length');
%         BER = 0.5;
%         bitbuffer_corrected = nan(size(bitbuffer));
%         return;
%     end
    
    %% At this point, we know how long the whole data packet is, therefore we can decode the remaining blocks
    remainingBits = softbits(N+1:codelength);
    M_= length(remainingBits)/N;
    M = M_ + 1;
    packetDecoded = zeros(size(remainingBits));
    packetDecoded(1:K) = heaviside(firstBlock_Decoded_soft);
    for m=1:M_
        packetDecoded((1:K)+K*(m)) = heaviside(dec.step(remainingBits((1:N)+N*(m-1))));
    end
    payloadDecoded_bin = packetDecoded(81 + 2*8*namelength:80 + 2*8*namelength + 8*filelength);
    
    %% re encode the bits to get the BER
    enc = comm.LDPCEncoder(H);
    packet_reenc_bits = zeros(M*N,1);
    
    for m=1:M
        packet_reenc_bits((1:N)+N*(m-1)) = enc.step(packetDecoded((1:K)+K*(m-1)));
    end
    BER = sum(heaviside(softbits(1:codelength)) ~= packet_reenc_bits)/codelength
    
%     payload_corrected = [nan(headlength*8,1);randintrlv(double(payload_reenc_bits)*2-1,st2)];
    bitbuffer_corrected = nan(size(bitbuffer));
    bitbuffer_corrected(1:codelength) = packet_reenc_bits;
%     bitbuffer_corrected(length(softbits)+(1:length(payload))) = payload_corrected;
       
%     payloadbits_new = [payloadDecoded_bin(:)];
%     payloadbits_new = payloadbits_new(1:(8*filelength));
    payloadbytes = uint8(bi2de(reshape(payloadDecoded_bin,8,[]).','left-msb')).';
    try
        [hfile,error] = fopen(sprintf('output/%s',filename),'w');
        fwrite(hfile,payloadbytes.');
        fclose(hfile);
        winopen(sprintf('output/%s',filename));
    catch exc
        disp(error);
        disp(exc);
    end
    
    [dataMatrix, bitsPerFrame, nbDataFrames] = functions.createDataMatrix_twoChannel_Dec17(...
        packet_reenc_bits', packet_reenc_bits(1:40)', 1920, 1080, blocksize, 1);
    dataMatrix = reshape(dataMatrix', [1920/blocksize, 1080/blocksize, 2, nbDataFrames/2]); 
    dataMatrix = permute(dataMatrix, [2 1 4 3]);
end