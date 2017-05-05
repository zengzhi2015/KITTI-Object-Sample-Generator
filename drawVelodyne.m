function drawVelodyne(h,cloud_2D,distance,reflection,image_size )
%DRAWVELODYNE Overlay point cloud on the image
%   Detailed explanation goes here

% filter out those points lay outside of the image box
valid_index = cloud_2D(1,:) > 0 & ...
    cloud_2D(1,:) < image_size(2) & ...
    cloud_2D(2,:) > 0 & ...
    cloud_2D(2,:) < image_size(1);

P = cloud_2D(:,valid_index);
D = distance(1,valid_index);
R = reflection(1,valid_index);

temp = jet; % This is a color wheel
RGB = zeros(length(D),3);
DD = (D+1)*2; DD(DD>64)=64;DD=round(DD);
for i=1:length(D)
    RGB(i,:) = temp(65-DD(i),:);
end

RR = min(20,R*20) + 30.0;

% RED = D/50; RED(RED>1)=1;RED=1-RED;
% GREEN = 1-RED;%zeros(1,length(D));
% BLUE = R;
% 
% RGB = [RED',GREEN',BLUE'];


scatter(h(3).axes,P(1,:),P(2,:),RR,RGB,'.');

end

