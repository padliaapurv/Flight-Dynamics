A = [-0.045 0.036 0 -0.18;
    -0.369 -2.026 0.99 0;
    0.328 -6.907 -2.9311 0
    0 0 1 0];

B = [0 0.000068;
    -0.162 0;
    -11.006 0;
    0 0];

C = [1 0 0 0;
    0 0 0 1;
    0 0 176 0];

D = [0 0;
    0 0;
    0 0];

[num_e,den_e] = ss2tf(A,B,C,D,1);
[num_t,den_t] = ss2tf(A,B,C,D,2);

tf_u_e = tf(num_e(1,:),den_e)
tf_th_e = tf(num_e(2,:),den_e)
tf_h_e = tf(num_e(3,:),den_e)

tf_u_t = tf(num_t(1,:),den_t)
tf_th_t = tf(num_t(2,:),den_t)
tf_h_t = tf(num_t(3,:),den_t)