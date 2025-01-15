function I_filtered = butterworth_filter(I, D0, n)
    % 输入：
    %   I   : 双精度灰度图像，大小为 (H, W)
    %   D0  : 截止频率
    %   n   : 巴特沃斯滤波器阶数
    %
    % 输出：
    %   I_filtered : 高通滤波后的图像（与原图同大小）

    % 1. 获取原图像大小
    [H, W] = size(I);

    % 2.零填充尺寸取原图像的2倍
    %M = 2 * H;
    %N = 2 * W;

    % 2. 改进为镜像填充
    pad_h = floor(H/2);
    pad_w = floor(W/2);
    padded_image = padarray(I, [pad_h pad_w], 'symmetric', 'both');
    [M, N] = size(padded_image);

    % 3. 构建频率网格 (u, v)
    % u和v都是从 -M/2 ~ (M/2 - 1), -N/2 ~ (N/2 - 1)
    u = -floor(M/2) : (ceil(M/2)-1);
    v = -floor(N/2) : (ceil(N/2)-1);
    [U, V] = meshgrid(v, u); 

    % 4. 距离矩阵 D(u, v)
    D = sqrt(U.^2 + V.^2);

    % 5. 构建巴特沃斯**高通**滤波器 H(u,v)
    %    巴特沃斯**低通**滤波器为:  H_lp = 1 ./ (1 + (D/D0).^(2n))
    %    高通滤波器则为:           H_hp = 1 - H_lp
    H_low  = 1 ./ (1 + (D ./ D0).^(2*n));  
    H_high = 1 - H_low;                 

    % 6. 对图像做FFT并中心化
    %F = fft2(I, M, N);       % 先将原图像零填充为 M x N 大小再FFT

    F = fft2(padded_image); % 对镜像填充后的图像做FFT
    F_shifted = fftshift(F); % 将零频移到频谱中心

    % 7. 频域滤波
    G = F_shifted .* H_high;

    % 8. 滤波结果逆中心化、逆傅里叶变换
    G_unshift = ifftshift(G);
    iG = ifft2(G_unshift);

    % 9. 截取回原图像大小
    I_filtered_full = real(iG);
    % 镜像填充优化
    start_row = H/2 + 1;
    start_col = W/2 + 1;
    I_filtered = I_filtered_full(start_row:start_row+H-1, start_col:start_col+W-1);
end
