function [BER,bitbuffer_corrected] = restorefile(bitbuffer)
n=255;
k=205;
    softbits = bitbuffer(:);
    packetheader = heaviside(softbits(1:40) + softbits(41:80));
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
    namebits = round(heaviside(softbits(81:80+namelength*8)...
                        +softbits(81+namelength*8:80+namelength*16)));
    filename = char(bi2de(reshape(namebits,8,[]).','left-msb')).';
    codelength = ceil((filelength-headlength)/k)*n;
    payload = softbits(81+namelength*16+headlength*8:80+namelength*16+headlength*16+codelength*8);
    softbits = softbits(1:80+namelength*16+headlength*8);
    payload(1:headlength*8) = payload(1:headlength*8) + softbits(81+namelength*16:80+namelength*16+headlength*8);
    payloadbits = heaviside(payload);
%     st2 = 4831;
    st2 = RandStream('mt19937ar', 'seed', 4831);
    payloadhead = payloadbits(1:headlength*8);
    payloadnh = payloadbits((headlength*8+1):end);
    payloaddeint = randdeintrlv(payloadnh,st2);
    payloaddeint(payloaddeint == 0.5) = 0;
    payload_gf = gf( bi2de(reshape(payloaddeint, [8, length(payloaddeint)/8])','left-msb') , 8 );
    payload_gf_matrix = reshape(payload_gf, n, [length(payload_gf)/n])';
    payload_dec = rsdec(payload_gf_matrix, n, k)';
    
    payload_reenc = rsenc(payload_dec.',n,k).';
    payload_reenc = payload_reenc(:);
    payload_reenc_bits = de2bi(payload_reenc.x,8,'left-msb').';
    payload_reenc_bits = payload_reenc_bits(:);
    BER = sum(payloaddeint ~= payload_reenc_bits)/length(payloaddeint);
    payload_corrected = [nan(headlength*8,1);randintrlv(double(payload_reenc_bits)*2-1,st2)];
    bitbuffer_corrected = nan(size(bitbuffer));
    bitbuffer_corrected(length(softbits)+(1:length(payload))) = payload_corrected;
    %bitbuffer_deviation = bitbuffer.*bitbuffer_corrected;
    
    payload_dec = payload_dec(:);
    payload_dec_bin = de2bi(payload_dec.x,8,'left-msb')';
    payloadbits_new = [payloadhead(:);payload_dec_bin(:)];
    payloadbits_new = payloadbits_new(1:(8*filelength));
    payloadbytes = uint8(bi2de(reshape(payloadbits_new,8,[]).','left-msb')).';
    [hfile,error] = fopen(sprintf('output/%s',filename),'w');
    try
        fwrite(hfile,payloadbytes.');
    catch exc
        disp(error);
        disp(exc);
    end
    fclose(hfile);
    winopen(sprintf('output/%s',filename));
end