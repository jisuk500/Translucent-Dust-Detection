classdef DustDetection
   properties
       %HPF filter
      Filter = [-1 -1 -1
    -1 9 -1
    -1 -1 -1];
        %Threshold 
    diff = 10;
        %median filter size
    medi_size = 3;
        %histogram merge size
    histMerge_size = 5;
        %probability estimation section length threshold value
    sectionThresh = 0.1;
   end
   methods
       %seperate image dust
       function [mediFiltered, notsharped, gray] = seperate_dust(obj,original_img,medi_size)
           
           if ~exist('medi_size','var')
               medi_size = obj.medi_size;
           end
           
            A = rgb2gray(original_img);
            gray = A;
            A_medi = medfilt2(A,[medi_size medi_size]);
            A_sub = A - A_medi;
            A_subinv = A_medi - A;
            A_merged = A_sub + A_subinv;
            
            notsharped = A_merged;
            mediFiltered = A_medi;
       end
       % thresholding image
       function resultImg = thresholding(obj, img, diff)
           if ~exist('diff','var')
              diff = obj.diff; 
           end
           
           resultImg = zeros(size(img));
           for i=1:1:size(img,1)
               for j=1:1:size(img,2)
                   px = img(i,j);
                   if (px<diff)
                       resultImg(i,j) = 0;
                   else
                       resultImg(i,j) = 1;
                   end
               end
           end
       end
       % extract histograms
       function [dustandpx_hist_ori, dustandpx_hist, dustperpx_hist] = histograms(obj,mediimg, img,histMerge_size)
           
           if ~exist('histMerge_size','var')
              histMerge_size = obj.histMerge_size; 
           end
           
           a = zeros(3,256);
           
           for i=1:1:size(img,1)
               for j=1:1:size(img,2)
                   px_orig = mediimg(i,j);
                   px = img(i,j);
                   
                   a(1,px_orig+1) = a(1,px_orig+1) + 1;
                   
                   if(px>127)
                       a(3,px_orig+1) = a(3,px_orig+1) + 1;
                   else
                       a(2,px_orig+1) = a(2,px_orig+1) + 1;
                   end
               end
           end
           
           a_merged = zeros(3,256);
           for i=1:1:256
               for j=i-(histMerge_size-1)/2:1:i+(histMerge_size-1)/2
                  if (j>=1) && (j<=256)
                     a_merged(:,i) =  a_merged(:,i) + a(:,j);
                  end
               end
           end
           
           b = zeros(3,256);
           for i=1:1:256
               b(1,i) = a_merged(3,i)/a_merged(1,i);
               len = 2.58*sqrt( b(1,i)*(1- b(1,i))/a_merged(1,i));
               b(2,i) = b(1,i) - len;
               b(3,i) = b(1,i) + len;
               if len < 0.00001
                   b(1,i) = NaN;
                   b(2,i) = NaN;
                   b(3,i) = NaN;
               end
           end
           dustandpx_hist_ori = a;
           dustandpx_hist = a_merged;
           dustperpx_hist = b;
           
       end
       
       function dustperpx_hist = sectionThresholding(obj, hist, sectionThresh)
            if ~exist('sectionThresh','var')
               sectionThresh = obj.sectionThresh; 
            end
            for i=1:1:256
                if (hist(3,i) - hist(2,i)) >  sectionThresh
                    hist(1,i) = NaN;
                    hist(2,i) = NaN;
                    hist(3,i) = NaN;
                end
            end
            
            dustperpx_hist = hist;
       end
       
       function [p,g] = selectP(obj,hist)
          [~,i] = max(hist(3,:));
          
          p=hist(1,i);  
          g = i-1;
       end
       
       function a = k_means(obj, binary_im, k)
           % initialize clusters cell
           clusters = [];
           
           % initialize points array
           points = [];
           for i=1:1:size(binary_im,1)
              for j=1:1:size(binary_im,2)
                  if(binary_im(i,j) >0)
                     points = [points [j;i;-1]];
                  end
              end
           end
           
           
       end
       
       function a = mean_shift(obj,image,horseg,averseg,radius)
           im_size = size(image);
           ver = im_size(1);
           hor = im_size(2);
           
           
           
           verList = round((1:1:verseg) * (ver/verseg));
           horList = round((1:1:horseg) * (hor/horseg));
           
           for i= 1:1:size(verList,2)
               for j=1:1:size(horList,2)
                   
               end
           end
           
           
           
           
       end
       
   end
end