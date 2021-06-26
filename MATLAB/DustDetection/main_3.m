%% ����
clear;
%clc;

calc_ref = false;

%% �⺻���� Ŭ���� �� ó��
dust = DustDetection_v3_1;
A = imread("����â��������\����â��_������3.jpg");
A = imresize(A,[720,1280]);

% denoising ����
%A_denoised = imnlmfilt(A,'DegreeOfSmoothing',10,'ComparisonWindowSize',7);
A_denoised = A;

% �޵�� ���� ������ �Ķ����
medi_size = 5;
[A_merged, A_medi, A_gray] = dust.seperate_dust(A_denoised,medi_size);

% ������Ȧ�� �Ķ����
diff = 6;
A_merged_th = dust.thresholding(A_merged,diff);


% mean-shift ������ ��
[A_finalPos, A_finalPos_Struct, A_means, radius_] = dust.mean_shift(A_merged_th,15,20,-1,1);






%% �������� ����
figure(1);
imshow(A);
imwrite(A,"main images\original.jpg")

%% �����¡ �˰��� �����ߴ���
figure(2);
imshow(A_denoised);
imwrite(A_denoised,"main images\original_denoised.jpg");
%% �����¡�� �������
figure(3)
imshow(A_gray);
imwrite(A_gray,"main images\gray.jpg");
%% �޵�� ���� �����
figure(4);
imwrite(A_medi,"main images\G_medi.jpg");
imshow(A_medi);
%% ������
figure(5);
imshow(A_merged);
imwrite(A_merged,"main images\G_merged.jpg");

%% ������� ����
figure(6);
imshow(A_merged_th);
imwrite(A_merged_th,"main images\G_mergedThresh.jpg");






