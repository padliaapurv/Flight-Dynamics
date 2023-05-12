num = [28.17 85.379 -3735.1 -61.685];
den = [1 5.0552 13.238 0.6754 0.595 0];

tf_h_e = tf(num,den);

numc = [1 -1];
denc = [1 10];

control = tf(numc,denc);
auto = control*tf_h_e;

hold;

plot([-0.5],[0.87],'x',Color = 'black');
plot([-0.5],[0.87],'o',Color = 'black');
plot([-0.5],[-0.87],'x',Color = 'black');
plot([-0.5],[-0.87],'o',Color = 'black');

numc = [1 0.15];
denc = [1 2];

control = tf(numc,denc);
auto = control*tf_h_e;

rlocus(-auto);
legend("Desired root","Desired root","Desired root","Desired root","Root Locus")
hold;

step(-0.0048*auto/(1-0.0048*auto));
hold;
plot([0,450],[1,1],'--',Color = 'black');
hold;

