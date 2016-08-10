function PlotEllipse(Xcenter,Ycenter,LongAxis,ShortAxis,Angle,red,green,blue)
t1=0:.02:pi;
t2=pi:.02:2*pi;
z1=exp(1i*t1);
z2=exp(1i*t2);
z1=(LongAxis*real(z1)+1i*ShortAxis*imag(z1))*exp(1i*Angle);
z2=(LongAxis*real(z2)+1i*ShortAxis*imag(z2))*exp(1i*Angle);
z1=z1+Xcenter+Ycenter*1i;
z2=z2+Xcenter+Ycenter*1i;
%hold on
%plot(z1,'color',[red green blue]);
%hold on
%plot(z2,'color',[red green blue]);
x = [real(z1) real(z2)];
y = [imag(z1) imag(z2)];
hold on
fill(x,y,[red,green,blue]);