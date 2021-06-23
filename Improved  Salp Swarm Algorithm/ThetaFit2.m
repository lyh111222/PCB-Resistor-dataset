function Fitness = ThetaFit2(Theta,C)    %%一次计算一个粒子
 w0=0;
 w1=0;
 w2=0;
Theta=round(Theta);
 %   Fitness=0;
%end
%if Theta(1)>=Theta(2)
z=imhist(C);
[m n]=size(C);
N=m*n;
for i=1:256
    p(i)=z(i)/N;
end
 for k=0:255
            if k<=Theta(1)
                w0=w0+p(k+1);
              elseif k<=Theta(2)
                w1=w1+p(k+1);
            else
                w2=w2+p(k+1);
            end
        end
        q0=0;
        q1=0;
        q2=0;
        if w0*w1*w2>0
                for k=0:Theta(1)
                    q0=q0+p(k+1)/w0*(exp(1-p(k+1)/w0));
                    
                end
                 for k=Theta(1)+1:Theta(2)
                   q1=q1+p(k+1)/w1*(exp(1-p(k+1)/w1));
                 end  
                
                for k=Theta(2)+1:255
                   q2=q2+p(k+1)/w2*(exp(1-p(k+1)/w2));
                end 
               
               Fitness=q0+q1+q2;
          else
               Fitness=0;
        end 
   
        end