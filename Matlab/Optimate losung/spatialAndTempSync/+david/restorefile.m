function [BER,bitbuffer_corrected] = restorefile(bitbuffer)
n=255;
k=205;
    H = dvbs2ldpc(4/5);
    N = size(H,2);
    K = diff(size(H));
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
    namebits = heaviside(softbits(81:80+namelength*8)...
                        +softbits(81+namelength*8:80+namelength*16));
    filename = char(bi2de(reshape(namebits,8,[]).','left-msb')).';
    codelength = ceil((filelength-headlength)*8/K)*N;
    if codelength > length(softbits)-(80+namelength*16+headlength*16)
        disp('Header Corruption: invalid file length');
        BER = 0.5;
        bitbuffer_corrected = nan(size(bitbuffer));
        return;
    end
    payload = softbits(81+namelength*16+headlength*8:80+namelength*16+headlength*16+codelength);
    softbits = softbits(1:80+namelength*16+headlength*8);
    payload(1:headlength*8) = payload(1:headlength*8) + softbits(81+namelength*16:80+namelength*16+headlength*8);
    payloadbits = -payload;
    %st2 = 4831;
    st2 = RandStream('mt19937ar','seed',4831);
    payloadhead = payloadbits(1:headlength*8);
    payloadnh = payloadbits((headlength*8+1):end);
    payloaddeint = randdeintrlv(payloadnh,st2);
    payloaddeint(payloaddeint == 0.5) = 0;
    %dec = comm.RSDecoder(n,k,'BitInput',1);
    M = length(payloaddeint)/N;
    payload_dec_bin = zeros(M*K,1);
    dec = comm.LDPCDecoder(H);
    BER = nan;
    for m=1:M
        payload_dec_bin((1:K)+K*(m-1)) = dec.step(payloaddeint((1:N)+N*(m-1)));
    end
    bitbuffer_corrected = nan(size(bitbuffer));
%     payload_gf = gf( bi2de(reshape(payloaddeint, [8, length(payloaddeint)/8])','left-msb') , 8 );
%     payload_gf_matrix = reshape(payload_gf, n, [length(payload_gf)/n])';
%     payload_dec = rsdec(payload_gf_matrix, n, k)';
%{
    enc = comm.RSEncoder(n,k,'BitInput',1);
    payload_reenc_bits = enc.step(payload_dec_bin);
%     payload_reenc = rsenc(payload_dec.',n,k).';
%     payload_reenc = payload_reenc(:);
%     payload_reenc_bits = de2bi(payload_reenc.x,8,'left-msb').';
%     payload_reenc_bits = payload_reenc_bits(:);

    %bitbuffer_deviation = bitbuffer.*bitbuffer_corrected;
%}
%     payload_dec = payload_dec(:);
%     payload_dec_bin = de2bi(payload_dec.x,8,'left-msb')';
    enc = comm.LDPCEncoder(H);
    payload_reenc_bits = zeros(M*N,1);
    for m=1:M
        payload_reenc_bits((1:N)+N*(m-1)) = enc.step(payload_dec_bin((1:K)+K*(m-1)));
    end
    BER = sum(heaviside(-payloaddeint) ~= payload_reenc_bits)/length(payloaddeint);
    payload_corrected = [nan(headlength*8,1);randintrlv(double(payload_reenc_bits)*2-1,st2)];
    bitbuffer_corrected = nan(size(bitbuffer));
    bitbuffer_corrected(length(softbits)+(1:length(payload))) = payload_corrected;
    
    payloadbits_new = [payloadhead(:);payload_dec_bin(:)];
    payloadbits_new = payloadbits_new(1:(8*filelength));
    payloadbytes = uint8(bi2de(reshape(payloadbits_new,8,[]).','left-msb')).';
    try
        [hfile,error] = fopen(sprintf('output/%s',filename),'w');
        fwrite(hfile,payloadbytes.');
        fclose(hfile);
        winopen(sprintf('output/%s',filename));
    catch exc
        disp(error);
        disp(exc);
    end
end