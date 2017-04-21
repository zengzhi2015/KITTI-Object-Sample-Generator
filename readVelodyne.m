function point_cloud = readVelodyne( velodyne_dir, img_idx )
%READVELODYNE Read the point-cloud recorded in the bin files
%   Detailed explanation goes here

file_path = sprintf('%s/%06d.bin',velodyne_dir,img_idx);
fileID = fopen(file_path);
A = fread(fileID,[4,inf],'single');
fclose(fileID);

non_zero = A(4,:)>0;

point_cloud = A(:,non_zero);

end