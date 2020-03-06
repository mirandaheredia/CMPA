clear
clc
%1
Is = 0.01e-12;
Ib= 0.1e-12;
Vb = 1.3;
gp = 0.1;

V = linspace(-1.95,0.7,200);
Vx = V + Vb;


I = Is.*((exp(1.2/0.25).*V)-1);+ gp.*V + Ib.*(exp((-1.2/0.025).*Vx));

randv = rand(1,200).*0.4+0.8;

I2 = I.*randv;
figure(1)
plot(I2)
figure(2)
semilogy(I2)