function drawVelodyne( h,cloud, reflection, P )
%DRAWVELODYNE Overlay point cloud on the map
%   Detailed explanation goes here

C = cloud(:,cloud(3,:)>0.1);
R = reflection(cloud(3,:)>0.1);
D = sqrt(C(1,:).^2 + C(2,:).^2 + C(3,:).^2);

cloud_2D = projectToImage(C, P);

color = D/max(D);
size = R/max(R);
scatter(h(1).axes,cloud_2D(1,:),cloud_2D(2,:),size,color);

end

