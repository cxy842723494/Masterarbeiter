%image_bgt.m

function level =image_bgt(I)

%?????basic global thresholding???????

I = im2double(I);          %??????

[M,N] = size(I);

T0 = 0.001;           %????

T1 = (max(max(I)) +min(min(I)))/2;          %??????T1

%??G1?G2??????????????

columns1 = 1;

columns2 = 1;

%????

while 1

    for i = 1:M

        for j = 1:N

            if I(i,j)>T1

                G1(columns1) = I(i,j);          %????G1

                columns1 = columns1 + 1;

            else

                G2(columns2) = I(i,j);          %????G2

                columns2 = columns2 + 1;

            end

        end

    end

       %??G1?G2??

    ave1 = mean(G1);

    ave2 = mean(G2);

    T2 = (ave1 + ave2)/2;           %?????T2

    if abs(T2 - T1)<T0        %??T2??????

        break;

    end

    T1 = T2;

    columns1 = 1;

    columns2 = 1;

end

level = T2;

end