function x=tenttest3(a,b,n)
%n=20;
%b=0.4
%n=20; %���г���clear;clc;
%w=20; %chebyshev �ķ��β���
%u=4; %logistic �ķ��β���
%a=2; %�Ľ���logistic �ķ��β���
%b=0.3; %Tent �ķ��β���

p(1)=a;
%p(1)=a;
%���������ĳ�ֵ�ͷ��β���������ԵĻ�������

for i=1:n
if (p(i)>0 & p(i)<b) %����д��0<x(i)<b
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
p(i+1)=1-a*p(i)^2;%�Ľ���logistic ��ӳ���ϵ
end
%}



x=p;
%x=double(p+1)/2.0;
%plot(x,'y'); title('�����Ķ�ֵTent ����');
%axis([0 20 0 1.5]);
end
