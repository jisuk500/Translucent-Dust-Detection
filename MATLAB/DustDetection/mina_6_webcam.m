%% ����
clear;
clc;
%% ��ķ ��ǲ
cam = webcam(1);

%% �⺻���� Ŭ���� �� ó��
dust = DustDetection;

while(true)
    A = snapshot(cam);
    A_denoised = imnlmfilt(A,'DegreeOfSmoothing',10,'ComparisonWindowSize',7);
    A_denoised = A;
    imwrite(A_denoised,"main images\denoised.jpg");
    % �޵�� ���� ������ �Ķ����
    medi_size = 5;
    [A_medi, A_merged] = dust.seperate_dust(A_denoised,medi_size);
    
    % ������Ȧ�� �Ķ����
    diff = 20;
    A_merged_th = dust.thresholding(A_merged,diff);
    %figure(1);
   % imshow(A_denoised);
    figure(2);
    imshow(A_merged_th);
end

clear('cam');
