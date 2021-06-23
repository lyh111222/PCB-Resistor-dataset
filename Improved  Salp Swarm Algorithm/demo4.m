
clc;
clear;
RootDir = pwd;

gtPath = fullfile(RootDir,'image');

%resPath = fullfile(RootDir,'result');
resPath1 = fullfile(RootDir,'result14');
resPath2 = fullfile(RootDir,'result24');
%if ~exist(resPath,'dir')
 %   mkdir(resPath);
%end
if ~exist(resPath1,'dir')
    mkdir(resPath1);
end
if ~exist(resPath2,'dir')
    mkdir(resPath2);
end

gtFiles = dir(fullfile(gtPath,'*.jpg'));
for k = 1:length(gtFiles)

[m,map1]= imread(fullfile(gtPath,gtFiles(k).name));    
%C=m(:,:,2);
%C=m;
C=rgb2gray(m);
Wmax = 0.9;             %最大惯性因子
Wmin = 0.1;             %最小惯性因子

costfunction=@(x,C)ThetaFit4(x,C);

vdix=4;
vall=12;
varsize=[1,vdix];
vmin=2;
vmax=254;
intermax=50;

empy.position=[];
empy.cost=[];
empy.best.position=[];
empy.best.position=[];
food.cost=-inf;
bestint=1;
slaps=repmat(empy,vall,1);

xyz=zeros(vdix,vall);
b=0.15/vdix;%initial sequence value
a=0.3;
for i=1:vdix
xx=0.5;
xx1=tenttest3(a,xx,vall);%initial population
a=a+b;

for j=1:vall
xyz(i,j)=xx1(j);
end
end
%}
for i=1:vall    
  % 0 64 128 192 255
  
 a11=xyz(1,i)*(64-vmin)+vmin;
 b11=xyz(2,i)*64+64;
 c11=xyz(3,i)*64+128;
 d11=xyz(3,i)*64+192;
slaps(i).position=[a11,b11,c11,d11];%mapping to range space
 
  slaps(i).cost=costfunction(slaps(i).position,C);
  slaps(i).best.position= slaps(i).position;
  slaps(i).best.cost=slaps(i).cost;
    
if  slaps(i).best.cost>food.cost
food=slaps(i).best;
 end
end

bestcosts=zeros(intermax,1);
start_time=cputime;
 for j=1:intermax 
     %inertia weight
     w2=0.5*exp(-(4*j/intermax)^2)+0.1+sin(j)/(j+1);
     w0=(exp(-1/10*j)*(sin(pi*(j))+cos(pi*(j ))+pi/2))/2.95*0.5;
    w3=(exp(-1/10*j)*(sin(pi*j)+cos(pi*j)))/pi
      w1=w3;
       if j>2  
   jsd=bestcosts(j-1)- bestcosts(j-2);%slope of fitness function
  if jsd<0.1 
   if w1<0.7 &&w1>0   
   w1=w1+0.2;
   elseif w1>-0.7 &&w1<0 
   w1=w1-0.2;
   end
  end
    for i=1:vall
    if i<vall/2
        a2=rand()
        if a2>0.5 %divide the leaders
        slaps(i).position =food.position*(1-w0)+slaps(i).position*w0;
        else      
          slaps(i).position =(1-w0)*(food.position*(1-w1)+w1*((vmax-vmin)*a2+vmin))+slaps(i).position*w0; %random move   
        end
    elseif i > vall/2-1&& i < vall+1
      slaps(i).position=(slaps(i).position+ w3*slaps(i-1).position)/2;%update the location of followers
     
     
    end    
    end
    
  
   for i=1:vall
    if i > vall/2&& i < vall+1
         a3=rand();
         if a3>0.7
       slaps(i).position= slaps(i).position+w3*((vmax-vmin)*a2+vmin); %random move
         end
    end    
    end
    end
    %}
    
   
    for i=1:vall
      slaps(i).position=max(slaps(i).position,vmin);
        slaps(i).position=min(slaps(i).position,vmax);
        slaps(i).cost=costfunction(slaps(i).position,C);
      if slaps(i).cost>slaps(i).best.cost
          slaps(i).best= slaps(i);
         
      %slaps(i).best.position= slaps(i).position;
      %slaps(i).best.cost=slaps(i).cost;
      end
      if slaps(i).best.cost>food.cost
          food=slaps(i).best;
           bestint=j;
      end
    end
   bestcosts(j)=food.cost;  
   if j>2
   if (bestcosts(j)-bestcosts(j-1)==0)&&(bestcosts(j)~=0);
       t=j-1;
       bb=bestcosts(j);
      % break;
   end
   jsd=bestcosts(j)-2*bestcosts(j-1)+ bestcosts(j-2);
   end
 end
 


 
figure(1);
semilogy(bestcosts,'LineWidth',2);
xlabel('Iterations');
ylabel('Best Cost');
grid on;
title('Improved Algorithm(K=4) ')

   [m,n]=size(C);
   z=zeros(m,n); 
% percentege=0;
 % 0 64 128 192 255
 
    for i=1:m
        for j=1:n
          if C(i,j)<=round(food.position(1))-1
           z(i,j)=0; 
          elseif C(i,j)<=round(food.position(2))-1
              z(i,j)=64;
          elseif C(i,j)<=round(food.position(3))-1
              z(i,j)=128;
          elseif C(i,j)<=round(food.position(4))-1
              z(i,j)=192;
          else
              z(i,j)=255;
    %           percentege=percentege+1;
          end
      end
    end
 
    z=z/255;
resName1 = sprintf([gtFiles(k).name(1:end-4),'_',num2str(bestcosts(intermax)),'_gj',num2str(vdix) ,'.jpg']);
imwrite(z,fullfile(resPath1,resName1));%image with fitness value in the name
resName2 = sprintf([gtFiles(k).name(1:end-4),'_',num2str(bestint),'_gj',num2str(vdix) ,'.jpg']);
imwrite(z,fullfile(resPath2,resName2));%image with number of iterations in the name

end