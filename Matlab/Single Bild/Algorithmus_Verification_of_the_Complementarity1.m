    clean;
    close all;

%% Input two candidate shape of the image
    % vorprocess
    Img = imread('14.png');   
    Img = rgb2gray(Img);
    Img = imbinarize(Img);
%     figure,imshow(Img);
    
    % choose two candidate shape of the image
    P1 = Input(Img,2);
    P2 = Input(Img,3);
    P = cat(1,P1,P2);
     
    % find the Smallest rectangle of the candidate shape (regionprops)
    thetar = zeros(2,1);
    thetal = zeros(2,1);
    % centroid use the bounding_box_centroid of the union P1andP2
    Pmean = bounding_box_centroid(P);
    
    [thetar(1),thetal(1)] = Algorithmus5_Verification_of_an_openshape(P1,Pmean);
    [thetar(2),thetal(2)] = Algorithmus5_Verification_of_an_openshape(P2,Pmean);
    
    % calculated the open degrees of a candidate shape P
    % einzige open degree
    opendegree = zeros(2,1);
    for i = 1:2
        if thetal(i) >= thetar(i)
            opendegree(i) = 360-thetal(i)+thetar(i);
        else
            opendegree(i) = thetar(i)-thetal(i);
        end
    end
    
    % open degree of the union of the cadinate shape
    [thetarsum,thetalsum] = Algorithmus5_Verification_of_an_openshape(P,Pmean);
    
    if thetalsum(1) >= thetarsum(1)
        opendegreesum = thetarsum(1)+thetarsum(2)-thetalsum(1)+360-thetalsum(2);
    else
        opendegreesum = thetarsum(2)-thetalsum(2)+thetarsum(1)-thetalsum(1);
    end
        
    % the condition of complementary 
    
    if opendegree(1)+opendegree(2)-opendegreesum == 360 % make tolerant 5 grad?
        output=1;
    else 
        output=0;
    end
    
    
    
    
    