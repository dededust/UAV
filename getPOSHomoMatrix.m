function [H]=getPOSHomoMatrix(para)
%���룺λ�˲������������Ӧ���任������
%output:homography 
dx=13.2/5472;dy=8.8/3648;%camera intrinsic matrix
u0=2736;v0=1824;f=8.8;

a=para(1,:);
b=para(2,:);
c=para(3,:);
d=para(5,:);
t=para(6:8,:);
n=para(9:11,:)';

%�����ڲξ���K
    K=[ 0    f/dy  u0;%camera intrinsic matrix
      -f/dx  0     v0;
       0     0     1];
%������ת����R
    Rx=[1 0 0;
       0 cos(a) sin(a);
       0 -sin(a) cos(a)];
    Ry=[cos(b) 0 -sin(b);
       0 1 0;
       sin(b) 0 cos(b)];
    Rz=[cos(c) sin(c) 0;
        -sin(c) cos(c) 0;
        0 0 1];  
     R=Rx*Ry*Rz;
%���㵥Ӧ����H
    H1=K*R/K;
    H2=(1/d)*K*R*t*n/K;
    H=H1-H2;