clear
clc
load('point_cloud_sample.mat')

X = point_cloud(1:2,:)';
y = point_cloud(3,:)';

b = robustfit(X,y,'bisquare',1);

[XX,YY] = meshgrid(-20:1:20,-20:1:20);

ZZ = XX*b(2)+YY*b(3)+b(1);

scatter3(point_cloud(1,:),point_cloud(2,:),point_cloud(3,:),1,'.')
axis equal
xlabel('x')
ylabel('y')
zlabel('z')
axis([-20 20 -20 20 -3 3])

hold on

s = surf(XX,YY,ZZ,'FaceAlpha',0.3);
s.EdgeColor = 'none';