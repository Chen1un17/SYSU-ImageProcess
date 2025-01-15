function main()
    % 1. 读入并预处理图像
    Icolor = imread('test.jpg');
    Igray  = rgb2gray(Icolor);              % 转成灰度图
    I      = im2double(Igray);             % 转成 [0,1] 的双精度型

    % 2. 设置滤波器参数
    D0 = 50;  % 截止频率
    n  = 2;   % 阶数

    % 3. 调用巴特沃斯高通滤波器函数进行滤波
    I_filtered = butterworth_filter(I, D0, n);

    % 4. 调用阈值函数进行二值化
    I_thresholded = threshold_process(I_filtered);

    % 5. 显示结果
    figure;
    subplot(1,3,1), imshow(I, []), title('原图');
    subplot(1,3,2), imshow(I_filtered, []), title('高通滤波结果');
    subplot(1,3,3), imshow(I_thresholded, []), title('阈值处理结果');

    % 6. 保存结果
    imwrite(I_filtered, 'filtered_result.png');
    imwrite(I_thresholded, 'threshold_result.png');
end
