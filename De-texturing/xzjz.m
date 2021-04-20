

img=double(rgb2gray(imread('imgs/mb1.jpg')));
[m n]=size(img);

[LL LH HL HH]=haar_dwt2D(img);  %��Ȼdwt2(img,'haar')��һ���ģ���ֻ��������ϸ��
img=[LL LH;HL HH];      %һ��ֽ�

imgn=zeros(m,n);
for i=0:m/2:m/2
for j=0:n/2:n/2
        [LL LH HL HH]=haar_dwt2D(img(i+1:i+m/2,j+1:j+n/2)); %��һ��ֽ����ĸ�ͼ��ֱ��ٷֽ�
        imgn(i+1:i+m/2,j+1:j+n/2)=[LL LH;HL HH];  
end
end

imshow(imgn)
haar_dwt2D.m

function [LL LH HL HH]=haar_dwt2D(img)
    [m n]=size(img);
for i=1:m       %ÿһ�н��зֽ�
        [L H]=haar_dwt(img(i,:));
        img(i,:)=[L H];
end
for j=1:n       %ÿһ�н��зֽ�
       [L H]=haar_dwt(img(:,j));
       img(:,j)=[L H];
end
    %�����ֽⲻӦ�ü�mat2gray�ģ�����Ϊ���кõ���ʾЧ���ͼ�����
    LL=mat2gray(img(1:m/2,1:n/2));          %���ж��ǵ�Ƶ  
    LH=mat2gray(img(1:m/2,n/2+1:n));        %�е�Ƶ�и�Ƶ
    HL=mat2gray(img(m/2+1:m,1:n/2));        %�и�Ƶ�е�Ƶ
    HH=mat2gray(img(m/2+1:m,n/2+1:n));      %���ж��Ǹ�Ƶ

end
haar_dwt.m

function [L H]=haar_dwt(f)����%��Ȼ����û�����߽紦��ͼƬ�����2^n*2^n�͵�
    n=length(f);
    n=n/2;
    L=zeros(1,n);   %��Ƶ����
    H=zeros(1,n);   %��Ƶ����
for i=1:n
        L(i)=(f(2*i-1)+f(2*i))/sqrt(2);
        H(i)=(f(2*i-1)-f(2*i))/sqrt(2);
end

end