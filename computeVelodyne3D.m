function [ cloud_2D,D,R ] = computeVelodyne3D( point_cloud, P2,R0_rect,Tr_velo_to_cam )
%COMPUTEVELODYNE3D Summary of this function goes here
%   Detailed explanation goes here

C = point_cloud;
% only preserve points in front of the car
%   - Velodyne: x: forward, y: left,  z: up
C = C(:,C(1,:)>0.1);
X = C(1,:);
Y = C(2,:);
Z = C(3,:);
D = sqrt(X.^2 + Y.^2 + Z.^2); % distances
R = C(4,:); % reflection rate

% Project the point from the Velodyne coord to the rectified camara coord
cloud_3D = R0_rect * Tr_velo_to_cam * [X;Y;Z;ones(1,length(Z))];
% Project the point from the rectified camara coord to the image coord
cloud_2D = projectToImage(cloud_3D(1:3,:), P2);

end

