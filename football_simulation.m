clear all
clc

%% constants

m = 0.411;
Ia = 0.0019;
It = 0.0032;
g = 9.81;
omega = 63;
Mthetav = 0.325;
Lthetav = 3;
t_span = [0,5];

%% initial condition

initial_condition = [0;0;0;25*cos(pi/6);0;-25*sin(pi/6);0;40*pi/180;0;0;0;0];
I = [Ia 0 0;0 It 0;0 0 It];
invI = inv(I);

%% call the function

[time, States ] = ode45(@(tcurr,x_state) football_sim(m, I,invI, g, omega, Mthetav, Lthetav,x_state, tcurr, t_span), t_span,initial_condition);

%% plots

figure(1);
plot3(States(:,10),States(:,11),-States(:,12));
grid on;
title('X,Y,X of football');
xlabel('X');
xlabel('Y');
xlabel('Z');

figure(2);
plot(time, States(:,8));
title('Theta vs time');
xlabel('time');
ylabel('theta')

alpha = zeros(length(time),1);
beta = zeros(length(time),1);

for i = 1:length(time)

    phi = States(i,7);
    theta = States(i,8);
    psi = States(i,9);

    T_psi = [cos(psi) sin(psi) 0; -sin(psi) cos(psi) 0; 0 0 1];
    T_theta = [cos(theta) 0 -sin(theta); 0 1 0; sin(theta) 0 cos(theta)];
    T_phi = [1 0 0; 0 cos(phi) sin(phi); 0 -sin(phi) cos(phi)];

    vi = [States(i,4);States(i,5);States(i,6)];
    vb = T_phi*T_theta*T_psi*vi;

    alpha(i) = vb(3)/norm(vb);
    beta(i) = vb(2)/norm(vb);

end

figure(3);
plot(alpha,beta);
title('Alpha vs Beta');
xlabel('alpha');
ylabel('beta');

figure(4);
plot3(alpha,beta,time);
grid on;
title('Alpha vs Beta vs Time');
xlabel('alpha');
ylabel('beta');
zlabel('time');

%% function

function [x_state_dot] = football_sim(m, I,invI, g, omega, Mthetav, Lthetav, x_state, tcurr, t_span)

pqr = x_state(1:3);
uvw = x_state(4:6);
eul = x_state(7:9);
pos = x_state(10:12);

T_psi = [cos(eul(3)) sin(eul(3)) 0; -sin(eul(3)) cos(eul(3)) 0; 0 0 1];
T_theta = [cos(eul(2)) 0 -sin(eul(2)); 0 1 0; sin(eul(2)) 0 cos(eul(2))];
T_phi = [1 0 0; 0 cos(eul(1)) sin(eul(1)); 0 -sin(eul(1)) cos(eul(1))];

R = T_phi*T_theta*T_psi;
pqr_dot = -invI*(cross(pqr,I*(pqr+[omega;0;0])));
uvw_f = R*uvw;

thetav = acos(dot(uvw_f,[1;0;0])/(norm(uvw_f)));

Mf = Mthetav*thetav*cross(uvw_f,[1;0;0])/(norm(cross(uvw_f,[1;0;0])));

pqr_dot = pqr_dot + invI*Mf;

Mw = R'*Mf;

uvw_dot = [0;0;g] + (Lthetav*thetav*cross(Mw,uvw)/(m*norm(cross(Mw,uvw))));

eul_dot = [cos(eul(2)) sin(eul(1)).*sin(eul(2)) cos(eul(1)).*sin(eul(2));0 cos(eul(1)).*cos(eul(2)) -cos(eul(2)).*sin(eul(1));0 sin(eul(1)) cos(eul(1))]*(pqr)/cos(eul(2));

pos_dot = uvw;

x_state_dot = [pqr_dot;uvw_dot;eul_dot;pos_dot];

end

%%
