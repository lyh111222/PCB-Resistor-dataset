function x=tenttest3(a,b,n)
%n=20;
%b=0.4
%n=20; %序列长度clear;clc;
%w=20; %chebyshev 的分形参数
%u=4; %logistic 的分形参数
%a=2; %改进型logistic 的分形参数
%b=0.3; %Tent 的分形参数

p(1)=a;
%p(1)=a;
%以上所给的初值和分形参数满足各自的混沌条件

for i=1:n
if (p(i)>0 & p(i)<b) %不能写成0<x(i)<b
p(i+1)=(p(i)+rand()*0.01)/b;
%p(i+1)=p(i)/b+rand()*0.01;
%p(i+1)=p(i)/b;
else
p(i+1)=(1-p(i)-rand()*0.01)/(1-b);
%p(i+1)=(1-p(i))/(1-b)-rand()*0.01;
%p(i+1)=(1-p(i))/(1-b);
end

p(i+1)=max(p(i+1),0);
p(i+1)=min(p(i+1),1);
end

%{
for i=1:n
p(i+1)=1-a*p(i)^2;%改进型logistic 的映射关系
end
%}



x=p;
%x=double(p+1)/2.0;
%plot(x,'y'); title('量化的二值Tent 序列');
%axis([0 20 0 1.5]);
end
