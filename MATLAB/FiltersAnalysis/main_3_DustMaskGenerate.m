%% ����
clc;
clear all;

%% ���� �̸� ����
mask_num = 16;
image_size = [720 1280];
% seg 0.5, 1 1.5 2
x_seg = round(127*2);
y_seg = round(79*2);
% rad 1, 2
initial_dust_gray = [50 255];
dust_radius = [0 2];
blur_radius = [1 5];
%blur 3 5
%% ����
%[dust_mask] = imgDustGenerate(image_size,x_seg,y_seg,initial_dust_gray,dust_radius,blur_radius);
[dust_mask] = imgDustGenerate2(image_size,x_seg,y_seg,initial_dust_gray,dust_radius,blur_radius);
figure(1)
imshow(dust_mask);

%% ����

imshow(dust_mask)
imwrite(dust_mask,strcat('DustGenerator\DustMask_',num2str(mask_num),'.png'),'Mode','lossless');

