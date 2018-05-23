%     clean;
%     close all;

%% Input two candidate shape of the image
    % vorprocess
    Img = imread('15.png');   
    Img = rgb2gray(Img);
    Img = imbinarize(Img);
    figure,imshow(Img),hold on;
    
    % choose two candidate shape of the image
    P1 = Input(Img,2);
    P2 = Input(Img,3);
    P = cat(1,P1,P2);
     
    % centroid use the bounding_box_centroid     
    Pmean = bounding_box_centroid(P);
    Pmean1 = bounding_box_centroid(P1);
    Pmean2 = bounding_box_centroid(P2);
%     plot(Pmean2(1,1),Pmean2(1,2),'g.');
    
    % direction vector
    theta_p1 = Pmean-Pmean1;
    theta_p2 = Pmean-Pmean2;
    
    % cauculate the context_based orientation     
    anglecb(1) = atan2d(theta_p1(1,2),theta_p1(1,1));
    anglecb(2) = atan2d(theta_p2(1,2),theta_p2(1,1));
    anglecb = round(anglecb);
    for i = 1:2
        if(anglecb(i)<1)
           anglecb(i) =  anglecb(i) +360;
        end
    end
    
    % cauculate the context_free orientation of a candidate shape  
    thetar = zeros(2,1);
    thetal = zeros(2,1); 
    
    [thetar(1),thetal(1)] = Algorithmus5_Verification_of_an_openshape(P1,Pmean1);
    [thetar(2),thetal(2)] = Algorithmus5_Verification_of_an_openshape(P2,Pmean2);
    
    anglecf = zeros(2,1);
    for j = 1:2
        if(abs(thetar(j)-thetal(j))<=180)
            anglecf(j) = (thetar(j)+thetal(j))/2;
        else
            anglecf(j) = mod((thetar(j)+thetal(j))/2+180,360);
        end
    end   
    
     % the condition of complementary
     A = zeros(1,2);
     for k =1:2
     % check the "consistency" between the contextbased orientation and its contextfree orientation    
     	A(k) = cosd(anglecf(k))*cosd(anglecb(k))+sind(anglecf(k))*sind(anglecb(k));
        if A >= 0
            output = 1;
        else
            output = 0;
        end
        
     end
    
    
    
    
    
    
    
    
    
    
    
    