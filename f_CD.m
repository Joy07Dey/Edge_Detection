function [I1,I2] = f_CD(Img,x,y)

    [row,col] = size(Img);
    I1 = 0*Img; I2 = 0*Img;
    for i = y+1:row-y
        for j = x+1:col-x
            LR = (Img(i-x,j) - Img(i+x,j));
            UD = (Img(i,j-y) - Img(i,j+y));
            D1 = (Img(i-x,j-y) - Img(i+x,j+y));
            D2 = (Img(i-x,j+y) - Img(i+x,j-y));
            Diff = (LR + UD + D1 + D2);
            I1(i,j) = Diff; % Differentiate
            if Diff < 20  
                I2(i,j) = 0;
            else
                I2(i,j) = Diff;
            end
        end
    end
end
