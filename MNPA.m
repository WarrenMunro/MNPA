%{
KCL Equations:
0 = Iin + (V1 - VN2)/R1 + C(d(V1 - VN2)/dt)
0 = (V1 - VN2)/R1 + C(d(V1 - VN2)/dt) + VN2/R2 + IL
0 = IL + VN3/R3
0 = (VN4 - VN5)/R4 + alpha*(VN3/R3)
0 = (VN4 - VN5)/R4 + VN5/Ro = VN4*G4 + VN5*(Go - G4)
%}

g1 = 1/1;
g2 = 1/2;
g3 = 1/10;
g4 = 1/0.1;
go = 1/1000;

c = 0.25;
l = 0.2;
alpha = 100;

G = [1 0 0 0 0 0;
    -g1 g1+g2 1 0 0 0;
    0 -1 0 1 0 0;
    0 0 -1 g3 0 0;
    0 0 0 alpha*g3 1 0;
    0 0 0 0 -g4 g4+go];

C = [0 0 0 0 0 0;
    -c c 0 0 0 0;
    0 0 l 0 0 0;
    0 0 0 0 0 0;
    0 0 0 0 0 0;
    0 0 0 0 0 0];

F = [1; 0; 0; 0; 0; 0];

V3 = zeros(1, 20);
Vin = zeros(1, 20);
Vo = zeros(1, 20);

F = F.*-10;

for i = 1:21
    V = G\F;
    F(1) = F(1) + 1;
    Vin(i) = V(1);
    V3(i) = V(4);
    Vo(i) = V(6);
end

figure(1)
plot(Vin, Vo)
title('Output Voltage vs Input Voltage Sweep')
xlabel('Vin (V)')
ylabel('Vo (V)')

figure(2)
plot(Vin, V3)
title('Voltage at Node 3 vs Input Voltage Sweep')
xlabel('Vin (V)')
ylabel('V3 (V)')

F = F./-10;
Av = zeros(1, 1000);
Vo = zeros(1, 1000);

for w = 1:1001
    V = (G+1i*w*C)\F;
    Vo(w) = V(6);
    Av(w) = 20*log(V(6)/V(1));
end

figure(3)
plot(real(Vo));
title('Output Voltage vs Frequency')
ylabel('Vo (V)')
xlabel('frequency (radians/s)')

figure(4)
semilogx(real(Av))
title('Ouput Gain vs Frequency')
ylabel('Gain (dB)')
xlabel('frequency (radians/s)')

w = pi;
for i = 1:1001
    C(2, 1) = normrnd(-c, 0.05);
    C(2, 2) = normrnd(c, 0.05);
    V = (G+1i*w*C)\F;
    Av(i) = 20*log(V(6)/V(1));
end

figure(5)
hist(real(Av))
title('Gain Distribution for Random Peturbations of C Value')
ylabel('Count')
xlabel('Gain (dB)')
