function [NewImage] = blend(warped_image, unwarped_image, x, y)
% Blend two image by using cross dissolve
% Input:
% warped_image - original image
% unwarped_image - the other image
% x - x coordinate of the lefttop corner of unwarped image
% y - y coordinate of the lefttop corner of unwarped image
% Output:
% newImage
% 
% Yihua Zhao 02-02-2014
% zhyh8341@gmail.com

% MAKE MASKS FOR BOTH IMAGES 
warped_image(isnan(warped_image))=0;%��ûֵ�Ķ����0
mask1 = (warped_image(:,:,1)>0 |warped_image(:,:,2)>0 | warped_image(:,:,3)>0);%��ĤA���ɣ����лҶȵĵط����1

newImage = zeros(size(warped_image));%������������С�ο�Ťת��ͼ��
NewImage = zeros(size(warped_image));
newImage(y:y+size(unwarped_image,1)-1, x: x+size(unwarped_image,2)-1,:) = unwarped_image;%�Ѳ���ͼ������ȥ

mask2 = (newImage(:,:,1)>0 | newImage(:,:,2)>0 | newImage(:,:,3)>0);%������Ĥ������ͼ��Ϊ1
mask = and(mask1, mask2);%�޸���Ĥ����ʱ��Ĥ����ͼ���ص����֡�
mask11=xor(mask,mask1);
mask22=xor(mask,mask2);
only1(:,:,1) = warped_image(:,:,1).*mask11;
only1(:,:,2) = warped_image(:,:,2).*mask11;
only1(:,:,3) = warped_image(:,:,3).*mask11;
only2(:,:,1) = newImage(:,:,1).*mask22;
only2(:,:,2) = newImage(:,:,2).*mask22;
only2(:,:,3) = newImage(:,:,3).*mask22;
% NewImage(:,:,1) = only1(:,:,1)+only2(:,:,1);
% GET THE OVERLAID REGION
[raw,col] = find(mask);%�ҵ�mask������1�������������ŵ�col���С���о����ص���������������ص�������
left = min(col);
right = max(col);
top=min(raw);
bottom=max(raw);
%bottom=min(max(raw),raw(end));
% mask = ones(size(mask));%ȫ�ֵ�ȨֵΪ1
maskz = zeros(size(mask));
if( x<2)
maskz(top:bottom,left:right) = repmat(linspace(0,1,right-left+1),bottom-top+1,1);%����Ĥ�ص������ڵ��н��в�����ÿ�ж������ɵ�С��
else
maskz(top:bottom,left:right) = repmat(linspace(1,0,right-left+1),bottom-top+1,1);%��ÿ�ж�һ��������һ��ʡʱ�Ľ��뽥������
end
maskz=maskz.*mask;
% BLEND EACH CHANNEL
warped_image(:,:,1) = warped_image(:,:,1).*maskz;%ͼ�����˴������������α��Ľ���ͼ��
warped_image(:,:,2) = warped_image(:,:,2).*maskz;
warped_image(:,:,3) = warped_image(:,:,3).*maskz;

% REVERSE THE ALPHA VALUE��ת��
if( x<2)
maskz(top:bottom,left:right) = repmat(linspace(1,0,right-left+1),bottom-top+1,1);
else
maskz(top:bottom,left:right) = repmat(linspace(0,1,right-left+1),bottom-top+1,1);
end
maskz=maskz.*mask;
newImage(:,:,1) = newImage(:,:,1).*maskz;
newImage(:,:,2) = newImage(:,:,2).*maskz;
newImage(:,:,3) = newImage(:,:,3).*maskz;

NewImage(:,:,1) = only1(:,:,1)+only2(:,:,1)+warped_image(:,:,1) + newImage(:,:,1);
NewImage(:,:,2) = only1(:,:,2)+only2(:,:,2)+warped_image(:,:,2) + newImage(:,:,2);
NewImage(:,:,3) = only1(:,:,3)+only2(:,:,3)+warped_image(:,:,3) + newImage(:,:,3);
% NewImage(bottom:en,:,1) = newImage(bottom:en,:,1);
% NewImage(bottom:en,:,2) = newImage(bottom:en,:,2);
% NewImage(bottom:en,:,3) = newImage(bottom:en,:,3);

