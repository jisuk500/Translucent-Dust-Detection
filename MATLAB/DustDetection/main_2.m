%% ����
clear;
clc;

%% �⺻���� Ŭ���� �� ó��
dust = DustDetection;
A = imread("����â��������\����â��_������1_a.jpg");
%A = imresize(A,[720,1280]);
%A_denoised = imnlmfilt(A,'DegreeOfSmoothing',10,'ComparisonWindowSize',7);
A_denoised = A;
imwrite(A_denoised,"main images\denoised.jpg");
% �޵�� ���� ������ �Ķ����
medi_size = 5;
[A_medi, A_merged, A_gray] = dust.seperate_dust(A_denoised,medi_size);

% ������Ȧ�� �Ķ����
diff = 8;
A_merged_th = dust.thresholding(A_merged,diff);

% k-means ������ ��




%% �������� ����
figure(1);
imshow(A);
imwrite(A,"main images\original.jpg")
%% ���Ȱ�
figure(2)
imshow(A_gray)
imwrite(A_gray,"main images\gray.png")

%% �޵�� ���� �����
figure(3);
imwrite(A_medi,"main images\G_medi.jpg");
imshow(A_medi);
%% ������
figure(4);
imshow(A_merged);
imwrite(A_merged,"main images\G_merged.jpg");
%% ������� ����
figure(5);
imshow(A_merged_th)
imwrite(A_merged_th,"main images\G_mergedThresh.jpg");
%% �����¡ �˰��� �����ߴ���
figure(6);
imshow(A_denoised);

%% 





