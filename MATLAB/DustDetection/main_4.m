%% ����
clear;
clc;

calc_ref = false;

dust = DustDetection_v2;

%% ���۷��� ����
ref_image_paths = ["���������2\���۷���1.jpg"];
result_merged_ths = {};
ref_densities = [];

for i = 1:1:size(ref_image_paths,2)
    result_merged_ths{i} = merged_thresh(ref_image_paths(i));
    imwrite( result_merged_ths{i},strcat("main_4\ref_result_",num2str(i),".jpg"))
end

[~, ref_densities(i)] = dust.calc_dustRef(result_merged_ths);
ref_density = mean(ref_densities);


%% �ű� �̹��� ó��
test_image_paths = [
    "���������2\�׽�Ʈ����1.jpg";
    "���������2\�׽�Ʈ����2.jpg";
    "���������2\�׽�Ʈ����3.jpg";
    "���������2\�׽�Ʈ����4.jpg";
    "���������3\�׽�Ʈ����1.jpg";
    '���������3\�׽�Ʈ����2.jpg';
    ];
test_image_paths = test_image_paths';
test_result_merged_ths = {};
test_densities = [];

for i = 1:1:size(test_image_paths,2)
    test_result_merged_ths{i} = merged_thresh(test_image_paths(i));
    % mean_shift ���� ��� = �̹���, verseg, horseg, radius �ڵ�����, 
    [~, final_pos_struct, ~, radius] = dust.mean_shift(test_result_merged_ths{i},15,20,-1,1);
    % �ش� ����� ������ maximum density ����
    maximum_density = dust.get_maximum_dustDensity_withMeanShift(final_pos_struct,radius,[],false);
    test_densities = [test_densities maximum_density];
end

%% ��Ȯ�� ��
accuracy = [];
for i =1:1:size(test_densities,2)
   acc_temp =  (100 - abs(test_densities(i) - ref_density) / ref_density * 100);
   accuracy = [accuracy acc_temp];
   figure(i);
   imshow(test_result_merged_ths{i});
   imwrite(test_result_merged_ths{i},strcat("main_4\test_result_",num2str(i),"_",num2str(acc_temp),".jpg"));
end

ref_densities
test_densities
accuracy

