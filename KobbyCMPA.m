%kwabena Gyasi Bawuah
%101048814

Is = 0.01E-12; %A
Ib = 0.1E-12; %A
Vb = 1.3; %V
Gp = 0.1; %ohm^-1

%Get current and V vector
V = linspace(-1.95,0.7,200);
I = (Is*(exp(1.2*V/0.025)-1)) + (Gp*V) - (Ib*(exp(-1.2*(V+Vb)/0.025)-1));

%Get noisy current vector by getting variation percent
for i = 1:200
    I2(i) = V(i)-0.2*V(i) + ((V(i)+0.2*V(i)) - (V(i)-0.2*V(i)))*rand;
end 

figure(1)
subplot(3,2,1)
plot(V,I,V,I2,'r-')
legend('data', 'I');
title(' Voltage versus Current - linear');
xlabel('V');
ylabel('I');

subplot(3,2,2)
semilogy(V,abs(I),V,abs(I2),'r-')
legend('data', 'I');
title('Voltage versus Current semilog');
xlabel('V');
ylabel('abs(I)');

%-----------------------------------------------------
poly4 = polyval(polyfit(V,I,4),V); 
poly8 = polyval(polyfit(V,I,8),V);

%plot 
subplot(3,2,3)
plot(V,I,'r',V,poly4,'g',V,poly8,'b');
legend('data','poly 4','poly8');
xlabel('V');
ylabel('I');
title('poly4 and poly8 plots');

polyI24 = polyval(polyfit(V,I2,4),V);
polyI28 = polyval(polyfit(V,I2,8),V);

subplot(3,2,4)
semilogy(V,abs(I2),'r',V,abs(polyI24),'g',V,abs(polyI28),'b');
legend('data','poly 4','poly8');
xlabel('V');
ylabel('abs(I)');
title('poly 4 and poly8 plots');
%-----------------------------------------------------
%using two fitted paramaters A and C
fo = fittype('A.*(exp(1.2*x/25e-3)-1) + 0.1.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
fofit = fit(V.',I.',fo);
If1 = fofit(V);
%Using three fitted paramaters A, B and C
f1 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
f1fit = fit(V.',I.',f1);
If2 = f1fit(V);
%Fitting all four paramaters A, B, C and D
f2 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1)');
f2fit = fit(V.',I.',f2);
If3 = f2fit(V);

%might have to run it a couple of time to get a good version of this graph
subplot(3,2,5)
plot(V,I,'r',V,If1,'g',V,If2,'b',V,If3,'y');
legend('data','fit 2','fit3','fit4');
xlabel('V');
ylabel('I');
title('fit2 , fit3 and fit4 plots');

subplot(3,2,6)
semilogy(V,abs(I2),'r',V,abs(If1),'g',V,abs(If2),'b',V,abs(If3),'y');
legend('data','fit 2','fit3','fit4');
xlabel('V');
ylabel('abs(I)');
title('fit2 , fit3 and fit4 plots');

%-----------------------------------------------------
inputs = V.';
targets = I.';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs)
view(net)
Inn = outputs
figure(2)
subplot(2,1,1)
plot(inputs,Inn,'b',inputs,I2,'r')
subplot(2,1,2)
semilogy(inputs,abs(Inn),'b',inputs,abs(I2),'r')

