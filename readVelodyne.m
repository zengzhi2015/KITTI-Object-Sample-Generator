function [cloud,S] = readVelodyne( velodyne_dir, img_idx )
%READVELODYNE Read the point-cloud recorded in the bin files
%   Detailed explanation goes here
file_path = sprintf('%s/%06d.bin',velodyne_dir,img_idx);
fileID = fopen(file_path);
A = fread(fileID,[4,inf],'single');
fclose(fileID);

non_zero = A(4,:)>0;
B = A(:,non_zero);

% X = B(1,:);
% Y = B(2,:);
% Z = B(3,:);
cloud = B(1:3,:);
% D = sqrt(X.^2 + Y.^2 + Z.^2);
S = B(4,:);

end