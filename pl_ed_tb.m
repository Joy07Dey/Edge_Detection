%% box_ed_tb.m 06-06-2020 02:10PM
clear all
close all
clc
%% Image Read
I = imread('OpTiK.jpg');
%I = imread('image.JPG');
%I = imread('left_raw_img.jpg');
%I = imread('right_raw_img.jpg');
figure; imshow(I);
title("Original Image")

%% RGB to gray conversion
R=I(:,:,1);G=I(:,:,2);B=I(:,:,3);
%Img=0.298936*R + 0.587043*G + 0.114021*B;
Img=0.3*R + 0.6*G + 0.1*B;
figure; imshow(Img);
title("Gray-scale Image")

%% Differentiation using HDL
filter = 1; thld = 50; slice = 5;


[row,col] = size(Img);
ZXZY = reshape(Img,[row,col]);
IMG_COL = zeros(row,slice+2);
A=1:slice:col;

% Parallel processing, slicing data
for i = A
    if(i==1)
        IMG_COL=Img(:,i:i+slice+1);
        first_slice = 1;
        end_slice = 0;
    elseif(i==A(end))
        col_padding=(slice+2) -(col-i+2);
        IMG_COL(:,1:(col-i+2))=Img(:,i-1:end);
        for j=1:col_padding
            IMG_COL(:,col-i+1+j)=Img(:,end);
        end
        first_slice = 0;
        end_slice = 1;
    else
        IMG_COL=Img(:,i-1:i+slice);
        first_slice = 0;
        end_slice = 0;
    end
    [r,c]=size(IMG_COL);
    IMG = reshape(IMG_COL,[1,r*c]);
    ZZZ = pl_ed(IMG, filter, r, c, thld);

    if (first_slice==1)
        ZXZY(1:slice*row) = ZZZ(:,1:slice*row);
    elseif (end_slice==1)
        ZXZY((i-1)*row+1:end) = ZZZ(:,row+1 : end - col_padding*row);
    else
        ZXZY((i-1)*row+1:(i+slice-1)*row) = ZZZ(:,row+1:(slice+1)*row);
    end

end
IMG_ED = reshape(ZXZY,[row,col]);

%figure; imshow(IMG_ED);
%title("Edge detected via HDL")

%% Differentiation using MATLAB
x = 1; y = 1;
[I1,I2] = f_CD(Img,x,y);
%figure; imshow(I1);
figure; imshow(I2);
title("Edge detected via MATLAB")

