function Rect2D = computeBox3Dto2DRect( object,P )
%COMPUTEBOX3DTO2DRECT Summary of this function goes here
%   Find the 2D bounding box that contains all corners of the projected 3D
%   box.
[corners_2D,~] = computeBox3D(object,P);
x = min(corners_2D(1,:));
y = min(corners_2D(2,:));
w = max(corners_2D(1,:))-x;
h = max(corners_2D(2,:))-y;
Rect2D = [x,y,w,h];

end

