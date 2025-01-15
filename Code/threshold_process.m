function I_thresholded = threshold_process(I_filtered)
% 输入：
% I_filtered : 滤波后的图像（大小 H x W, 可能有负值）
%
% 输出：
% I_thresholded : 阈值处理后的二值图像
% 使用大津法自动确定阈值

% 1. 将图像归一化到[0,1]范围
I_normalized = I_filtered - min(I_filtered(:));
I_normalized = I_normalized / max(I_normalized(:));

% 2. 将图像值映射到[0,255]的整数范围用于计算直方图
I_scaled = uint8(I_normalized * 255);

% 3. 计算直方图
histogramCounts = zeros(256, 1);
for i = 0:255
   histogramCounts(i+1) = sum(I_scaled(:) == i);
end

% 4. 使用大津法计算最佳阈值
total = sum(histogramCounts);
level = otsu(histogramCounts, total);

% 5. 根据计算出的阈值进行二值化
% 将阈值转换回原始图像的值域
threshold = (level/255) * (max(I_filtered(:)) - min(I_filtered(:))) + min(I_filtered(:));
I_thresholded = I_filtered >= threshold;

end