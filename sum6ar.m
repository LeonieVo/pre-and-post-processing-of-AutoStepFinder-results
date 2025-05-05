function y = sum6ar(x,a,b,c,d,e,g,parsum,DOL)
% sum2ar:
% y= a*arry1 + b*arry2
% length(x) muss gleich length(ar1) muss gleich length(ar2) 
n1=1;
n2=2;
n3=3;
n4=4;
n5=5;
n6=6;

f1=binopdf(x,n1,DOL);
f2=binopdf(x,n2,DOL);
f3=binopdf(x,n3,DOL);
f4=binopdf(x,n4,DOL);
f5=binopdf(x,n5,DOL);
f6=binopdf(x,n6,DOL);

f1trun= f1./(1-f1(1));
f1trun(1)=0;
f2trun= f2./(1-f2(1));
f2trun(1)=0;
f3trun= f3./(1-f3(1));
f3trun(1)=0;
f4trun= f4./(1-f4(1));
f4trun(1)=0;
f5trun= f5./(1-f5(1));
f5trun(1)=0;
f6trun= f6./(1-f6(1));
f6trun(1)=0;

y = zeros(size(x));

    for i = 1:length(x)
            y(i) = a.*f1trun(i) + b.*f2trun(i)+ c.*f3trun(i) + d.*f4trun(i)+ e.*f5trun(i) + g.*f6trun(i);
            
    end
parsum=a+b+c+d+e+g;
end