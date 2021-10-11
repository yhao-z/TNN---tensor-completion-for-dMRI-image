load('E:\Yhao\DATA\dmri\data_tmi.mat','seq');                         %load the quantitative maps
X = abs(seq);
X = double(X);
X = X./max(X(:)); % NEED to be normalized, otherwise, bad results
[n1,n2,n3] = size(X);

undersampling_ratio=0.33; 
omega = find(rand(n1*n2*n3,1)<undersampling_ratio);
sampling_mask = zeros(n1,n2,n3);
sampling_mask(omega) = 1;
%% TNN
omega = find(sampling_mask);

M = zeros(n1,n2,n3);
M(omega) = X(omega);

opts.DEBUG = 1;
Xhat = lrtc_tnn(M,omega,opts);
Xhat = max(Xhat,0);
Xhat = min(Xhat,1);
psnr = PSNR(X,Xhat,1)
snr = SNR(X,Xhat)
%% MNN
omega2 = find(reshape(sampling_mask,n1*n2,n3));
Xm = reshape(X,n1*n2,n3);
M2 = zeros(n1*n2,n3);
M2(omega2) = Xm(omega2);
Xhat2 = lrmc(M2,omega2,opts);
Xhat2 = reshape(Xhat2,n1,n2,n3);
Xhat2 = max(Xhat2,0);
Xhat2 = min(Xhat2,1);
psnr2 = PSNR(X,Xhat2,1)
snr2 = SNR(X,Xhat2)
%%
figure(1)
subplot(1,4,1)
imshow(X(:,:,15),[])
subplot(1,4,2)
imshow(M(:,:,15),[])
subplot(1,4,3)
imshow(Xhat(:,:,15),[])
subplot(1,4,4)
imshow(Xhat2(:,:,15),[])