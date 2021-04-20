

img=double(rgb2gray(imread('imgs/mb1.jpg')));
[m n]=size(img);

[LL LH HL HH]=haar_dwt2D(img);  %当然dwt2(img,'haar')是一样的，我只是想明白细节
img=[LL LH;HL HH];      %一层分解

imgn=zeros(m,n);
for i=0:m/2:m/2
for j=0:n/2:n/2
        [LL LH HL HH]=haar_dwt2D(img(i+1:i+m/2,j+1:j+n/2)); %对一层分解后的四个图像分别再分解
        imgn(i+1:i+m/2,j+1:j+n/2)=[LL LH;HL HH];  
end
end

imshow(imgn)
haar_dwt2D.m

function [LL LH HL HH]=haar_dwt2D(img)
    [m n]=size(img);
for i=1:m       %每一行进行分解
        [L H]=haar_dwt(img(i,:));
        img(i,:)=[L H];
end
for j=1:n       %每一列进行分解
       [L H]=haar_dwt(img(:,j));
       img(:,j)=[L H];
end
    %本来分解不应该加mat2gray的，不过为了有好的显示效果就加上了
    LL=mat2gray(img(1:m/2,1:n/2));          %行列都是低频  
    LH=mat2gray(img(1:m/2,n/2+1:n));        %行低频列高频
    HL=mat2gray(img(m/2+1:m,1:n/2));        %行高频列低频
    HH=mat2gray(img(m/2+1:m,n/2+1:n));      %行列都是高频

end
haar_dwt.m

function [L H]=haar_dwt(f)　　%显然，我没有做边界处理，图片最好是2^n*2^n型的
    n=length(f);
    n=n/2;
    L=zeros(1,n);   %低频分量
    H=zeros(1,n);   %高频分量
for i=1:n
        L(i)=(f(2*i-1)+f(2*i))/sqrt(2);
        H(i)=(f(2*i-1)-f(2*i))/sqrt(2);
end

end