function drawVelodyne3D( point_cloud,R0_rect,Tr_velo_to_cam )
%DRAWVELODYNE3D Summary of this function goes here
%   Detailed explanation goes here
C = point_cloud;
C = C(:,C(1,:)>0.1);% only preserve points in front of the car
X = C(1,:);
Y = C(2,:);
Z = C(3,:);
R = C(4,:); % reflection rate

cloud_3D = R0_rect * Tr_velo_to_cam * [X;Y;Z;ones(1,length(Z))];
cloud_3D(4,:) = [];

temp = jet;
RGB = zeros(length(R),3);
RR = R*63+1; RR=round(RR);
for i=1:length(R)
    RGB(i,:) = temp(RR(i),:);
end

figure(2)
scatter3(cloud_3D(1,:),cloud_3D(2,:),cloud_3D(3,:),1,RGB,'.');
xlabel('x')
ylabel('y')
zlabel('z')
axis equal
axis([-80 80 -1 2 0 80])

end

