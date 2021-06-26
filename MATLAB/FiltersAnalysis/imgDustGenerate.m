function [dust_mask] = imgDustGenerate(image_sizes,x_split,y_split,dust_thickness,radius,blur_size)

% �̹��� ������
x_len = image_sizes(2);
y_len = image_sizes(1);

% ���� �߽����� ��ġ ���
all_centers = {};

y_seg = (y_len+1)/(y_split+1) * (1:1:y_split) - ones([1 y_split]);
x_seg = (x_len+1)/(x_split+1) * (1:1:x_split) - ones([1 x_split]);

y_seg = round(y_seg);
x_seg = round(x_seg);

% ���� ������, ���� �� Ŀ�� ������ ����
for y=1:1:y_split
    for x=1:1:x_split
        a=[];
        a.center = [y_seg(y) x_seg(x)];
        a.radius = randi([radius(1) radius(2)],1);
        a.blur_size = randi([(blur_size(1)-1)/2 (blur_size(2)-1)/2],1);
        a.blur_size = 2*a.blur_size + 1;
        a.im = [];
        all_centers{y,x} = a;
    end
end

% all_centers���ٰ� ������� �ӽ� �� �̹��� ����
for y=1:1:y_split
    for x=1:1:x_split
        p = all_centers{y,x};
        
        im_size = p.radius*2 + (p.blur_size-1) + 1;
        im_center = p.radius + (p.blur_size-1)/2 + 1;
        
        % �ӽ� �̹��� �ʱ�ȭ
        im = uint8(zeros([im_size im_size]));
        % �� �׸��� ä���
        dust_base_gray = randi(dust_thickness,1);
        for yy=1:1:im_size
            for xx=1:1:im_size
                dist = sqrt((xx-im_center)*(xx-im_center) + (yy-im_center)*(yy-im_center));
                if(dist <= p.radius)
                    im(yy,xx) = dust_base_gray;
                end
            end
        end
        
        % ���콺���� �����ؼ� �̹��� 
        im = imgaussfilt(im,'FilterSize',p.blur_size);
        p.im = im;
        % �ش� �̹��� ����
        all_centers{y,x} = p;
    end
end

% ���� �̹����� ¥����. ���� ����.
dust_mask = uint8(zeros([y_len x_len]));

for y = 1:1:y_split
   for x=1:1:x_split
       p = all_centers{y,x};
       c = p.center;
       im = p.im;
       im_half = (size(im,1)-1)/2;
       
       cut_leftup = max(1 -( c - im_half),0);
       cut_rightdown = max((c + im_half) - [y_len x_len],0);
       
       image_cord_y = [c(1) - im_half + cut_leftup(1) , c(1) + im_half - cut_rightdown(1)];
       image_cord_x = [c(2) - im_half + cut_leftup(2) , c(2) + im_half - cut_rightdown(2)];
       
       im_cut = im((1+cut_leftup(1)):1:(size(im,1)-cut_rightdown(1)) , (1+cut_leftup(2)):1:(size(im,2)-cut_rightdown(2)));
       
       for yy=image_cord_y(1):1:image_cord_y(2)
           for xx=image_cord_x(1):1:image_cord_x(2)
              base_gray = double(dust_mask(yy,xx));
              mask_gray = double(im_cut(yy - image_cord_y(1) + 1 , xx - image_cord_x(1) + 1));
              blend_gray = base_gray + mask_gray;
              dust_mask(yy,xx) = uint8(blend_gray);
           end
       end
       
   end
end



end