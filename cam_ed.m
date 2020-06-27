%% cam_ed.m 27-06-2020 12:48PM
clear all
close all
clc
%% Image Read
cam = webcam;
%cam.Brightness = 50;
%cam.AvailableResolutions
cam.Resolution = '1280x720';
vidWriter = VideoWriter('frames.avi');
open(vidWriter);
figure; hold on

for index = 1:50
    % Acquire frame for processing
    I = snapshot(cam);

	%% RGB to gray conversion
	R=I(:,:,1);G=I(:,:,2);B=I(:,:,3);
	%Img=0.298936*R + 0.587043*G + 0.114021*B;
	Img=0.3*R + 0.6*G + 0.1*B;
	%figure; imshow(Img);
	%title("Gray-scale Image")

	%% Differentiation for HDL implementation
	filter = 1; thld = 50; slice = 5;
	%IMG_ED = slice_data (Img, slice, filter, thld);

	[row,col] = size(Img);
	ZXZY = reshape(Img,[row,col]);
	IMG_COL = zeros(row,slice+2);
	A=1:slice:col;

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
		ZZZ = ped(IMG, filter, r, c, thld);

		if (first_slice==1)
			ZXZY(1:slice*row) = ZZZ(:,1:slice*row);
		elseif (end_slice==1)
			ZXZY((i-1)*row+1:end) = ZZZ(:,row+1 : end - col_padding*row);
		else
			ZXZY((i-1)*row+1:(i+slice-1)*row) = ZZZ(:,row+1:(slice+1)*row);
		end

	end
	IMG_ED = reshape(ZXZY,[row,col]);
    I_mf = medfilt2(IMG_ED,[3 3]);
    for i = 1:row
        for j = 1:col            
            if (I_mf(i,j) > 0)
                I(i,j,1)=0;
				I(i,j,2)=255;
				I(i,j,3)=0;
            end

        end
    end
	%figure; 
    imshow(I);
	%title("Edge detected via HDL")
    writeVideo(vidWriter,I);

end
hold off
close(vidWriter);
clear cam
