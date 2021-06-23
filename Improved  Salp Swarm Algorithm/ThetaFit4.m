function Fitness = ThetaFit4(Theta,C)    %%一次计算一个粒子
 w0=0;
 w1=0;
 w2=0;
 w3=0;
 w4=0;
Theta=round(Theta);%四舍五入函数
z=imhist(C);
[m n]=size(C);
N=m*n;
for i=1:256
    p(i)=z(i)/N;
end
if (Theta(1)<=Theta(2))&(Theta(2)<=Theta(3))
 for k=0:255
      if k<=Theta(1)
                w0=w0+p(k+1);%该阶段总灰度占比例
            elseif k<=Theta(2)
                w1=w1+p(k+1);
             elseif k<=Theta(3)
                 w2=w2+p(k+1);
             elseif k<=Theta(4)
                 w3=w3+p(k+1);
            else
                w4=w4+p(k+1);
      end
   end      
        q0=0;
        q1=0;
        q2=0;
        q3=0;
        q4=0;
        if w0*w1*w2*w3*w4>1e-10
                for k=1:Theta(1)
                    q0=q0+p(k+1)/w0*(exp(1-p(k+1)/w0));%
                    
                end
                for k=Theta(1)+1:Theta(2)
                   q1=q1+p(k+1)/w1*(exp(1-p(k+1)/w1));
                 end  
                for k=Theta(2)+1:Theta(3)
                    q2=q2+p(k+1)/w2*(exp(1-p(k+1)/w2));
                end
                for k=Theta(3)+1:Theta(4)
                    q3=q3+p(k+1)/w3*(exp(1-p(k+1)/w3));
                end
                for k=Theta(4)+1:255
                    q4=q4+p(k+1)/w4*(exp(1-p(k+1)/w4));
                end
               Fitness=q0+q1+q2+q3+q4;
        else
       Fitness=0; 
        end
  else
      Fitness=0;     
  end 


             
                
      