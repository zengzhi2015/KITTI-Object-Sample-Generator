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

temp = jet;
RGB = zeros(length(D),3);
DD = (D+1)*4; DD(DD>64)=64;DD=round(DD);
for i=1:length(D)
    RGB(i,:) = temp(65-DD(i),:);
end

scatter(h(3).axes,P(1,:),P(2,:),R,RGB,'.');

end

