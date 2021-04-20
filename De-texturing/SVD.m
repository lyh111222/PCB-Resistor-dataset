clear,clc;
close all;

%img0 = double(imread('imgs/3.jpg')); %[256,256]
%img=rgb2gray(img0);

a=imread('imgs/mb4.jpg');
%a=imread('imgs/4.jpg');

imshow(mat2gray(a))
[m n]=size(a);
a=double(a);
%r=rank(a);
[s v d]=svd(a(:,:,1)); %取一个分量

%re=s*v*d';



re=s(:,:)*v(:,1:5)*d(:,1:5)';
figure;
imshow(mat2gray(re));
imwrite(mat2gray(re),'imgs/cgqwl4.jpg')
%imwrite(mat2gray(re),'imgs/cg4.jpg')
