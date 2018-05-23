% verification

    sigma = 0.5;
    G1 = fspecial('gauss',[round(10*sigma), round(10*sigma)], sigma);
    [Gx,Gy] = gradient(G1);

    A = [   0 0 0 10 10 10 0 0 0; 
            0 0 0 10 10 10 0 0 0; 
            0 0 0 10 10 10 0 0 0; 
            0 0 0 10 10 10 0 0 0; 
            0 0 0 10 10 10 0 0 0; 
            0 0 0 10 10 10 0 0 0; 
            0 0 0 10 10 10 0 0 0; 
            0 0 0 10 10 10 0 0 0; 
            0 0 0 10 10 10 0 0 0; ];

    Y = filter2(Gx,A,'full');
    
     B = [      0 0 0 10 10 10 ; 
                0 0 0 10 10 10 ; 
                0 0 0 10 10 10 ; 
                0 0 0 10 10 10 ; 
                0 0 0 10 10 10 ; 
                0 0 0 10 10 10 ; ];
        
        Y1 = filter2(rot90(Gx,2),B,'same');  % filter just correlation, not the convolution,Pad by 0
        C = conv2(B,Gx,'same');% Pad by 0
        
        D =imgaussfilt(A,'FilterSize',5); % Pad by repeating border elements of array.
        diff = gradient(D);
        
        E = imfilter(A,Gx,'replicate','same','conv');
        diffE = gradient(E);
        
        
        s = [-1 0 1; -2 0 2; -1 0 1]
        v = [1; 2; 1]
        h = [-1 0 1]
        conv2(v,h)
        
        A = [.006 .061 .242 .383 .242 .061 .006];
        B =A.';
        conv2(A,B);
        
        %% Separable convolution
        % If a matrix is an outer product of two vectors, its rank is 1.
        [U,S,V] = svd(G1);
        % Now get the horizontal and vertical vectors from the first columns of U and V.
        v = U(:,1) * sqrt(S(1,1));
        h = V(:,1)' * sqrt(S(1,1));
        % Now check to make sure this works:
        G1-v*h;
        
        h = fspecial('gaussian',[1,5],sigma);