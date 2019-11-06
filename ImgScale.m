% 首先读入需要放大的灰度图像
I = imread('./man.jpg'); 
Img_in = im2double(I);    % 转化为double类型，并归一化
m = size(Img_in,1);  % 获取原图像大小
n = size(Img_in,2);
% 设置新图像和原图像的比例：scale（大于1时放大图像，小于1时缩小图像）
scale = 0.5;    
T = [scale,0,0;0,scale,0;0,0,1]; % 仿射矩阵T
theta = 3.14/4;%旋转变换的角度（以弧度为单位）
size_x = ceil(m*scale);%取整放大后的尺寸
size_y = ceil(n*scale);
% 定义输出图像 I_out
I_out = ones(size_x,size_y,3);
for i = 1:size_x       % 从图像的左上角开始遍历输出图像
    for j = 1:size_y		% 输出图像像素坐标反向映射得到输入图像像素坐标x和y
        z = [i,j,1]/T;
        x = z(1);
        y = z(2);% 下面判断反向映射得到的坐标(x, y)是否超出输入图像的大小，% if条件成立则没有超出，
        % 条件不成立则不进行任何操作，定义I_out时已经默认该点灰度为1
        if (x>=1 & y>=1) & (x<=m & y<=n)  
            % 然后再判断x或y是否为小数，if条件成立则是小数
        	if (rem(x,1))||(rem(y,1))
        	  % 坐标为小数则需要插值
              % 先获取该小数坐标(x, y)邻近的四个像素坐标 
                x0 = floor(x);x1 = ceil(x);y0 = floor(y);y1 = ceil(y);
              % 获取邻近坐标的灰度值
                a = Img_in(x0,y0,:);b = Img_in(x0,y1,:);c = Img_in(x1,y0,:);d = Img_in(x1,y1,:);
              % 双线性内插
                g1 = a + (x-x0) * (c - a);
                g2 = b + (x-x0) * (d - b);
                I_out(i,j,:) = g1 + (y - y0) * (g2 - g1);     
       		else    % x和y都为整数则直接赋予原图像的灰度值
                I_out(i,j,:) = Img_in(x,y,:);
            end
         end
     end
end

% 显示原图像和放大后的输出图像
figure;imshow(I);
figure;imshow(I_out);
