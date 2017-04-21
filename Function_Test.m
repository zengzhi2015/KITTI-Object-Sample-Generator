clear
clc


%%

file_path = '/home/zhi/Downloads/KITTI/data_object_velodyne/training/velodyne/001010.bin';

fileID = fopen(file_path);
A = fread(fileID,[4,inf],'single');
fclose(fileID);

%%

image_dir = '/home/zhi/Downloads/KITTI/data_object_image_2/training/image_2';
label_dir = '/home/zhi/Downloads/KITTI/data_object_label_2/training/label_2';
calib_dir = '/home/zhi/Downloads/KITTI/data_object_calib/training/calib';
velodyne_dir = '/home/zhi/Downloads/KITTI/data_object_velodyne/training/velodyne';


%%
img_idx = 1010;
sz = [370,1224,3];
point_cloud = readVelodyne( velodyne_dir, img_idx ); % OK
[ P2,R0_rect,Tr_velo_to_cam ] = readAllCalibration( calib_dir,img_idx );%OK
[ cloud_2D,D,R ] = computeVelodyne3D( point_cloud, P2,R0_rect,Tr_velo_to_cam );%OK
drawVelodyne(cloud_2D,D,R*100,sz )
%%

scatter3(point_cloud(1,:),point_cloud(2,:),point_cloud(3,:),1)
xlabel('x')
ylabel('y')
zlabel('z')

%%
scatter(cloud_2D(1,:),cloud_2D(2,:),1);


%%
[ P2,R0_rect,Tr_velo_to_cam ] = readAllCalibration( calib_dir,1010 );

%% filter the data

non_zero = A(4,:)>0;
B = A(:,non_zero);

% B = A;


%% Seperate data

X = B(1,:);
Y = B(2,:);
Z = B(3,:);
S = B(4,:);%+0.01;

%% Plot the data

% scatter3(X,Y,Z,S)
% xlabel('x')
% ylabel('y')
% zlabel('z')

%% 
C = [X;Y;Z;ones(1,length(Z))];C = C(:,X>0.1);
R = S(X>0.1);
% D = sqrt(X.^2 + Y.^2 + Z.^2);D = D(X>0.1);


% cloud_3D = R0_rect * Tr_velo_to_cam * C;
cloud_3D = R0_rect * Tr_velo_to_cam * C;
D = cloud_3D(3,:);

%%

% scatter3(cloud_3D(1,:),cloud_3D(2,:),cloud_3D(3,:),R)
% xlabel('x')
% ylabel('y')
% zlabel('z')
%%

cloud_2D = projectToImage(cloud_3D(1:3,:), P2);
size = R/max(R)*10;

%%

index = cloud_2D(1,:)>0 & cloud_2D(1,:)<1300 & cloud_2D(2,:)>0;

cloud_2D = cloud_2D(:,index);
%size = size(index);
D = D(index);

%%
temp = jet;
RGB = zeros(length(D),3);
DD = (D+1)*4; DD(DD>64)=64;DD=round(DD);
for i=1:length(D)
    % RGB(i,:) = temp(color(i));
    RGB(i,:) = temp(65-DD(i),:);
end

%%

scatter(cloud_2D(1,:),cloud_2D(2,:),1,RGB);
