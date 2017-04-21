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
[ P2,R0_rect,Tr_velo_to_cam ] = readAllCalibration( calib_dir,1010 );

%% filter the data

non_zero = A(4,:)>0;
B = A(:,non_zero);

% B = A;


%% Seperate data

X = B(1,:);
Y = B(2,:);
Z = B(3,:);
N = sqrt(X.^2 + Y.^2 + Z.^2);
S = B(4,:)+0.01;

%% Plot the data

% scatter3(X,Y,Z,S)
% xlabel('x')
% ylabel('y')
% zlabel('z')

%% 
C = [X;Y;-Z;ones(1,length(Z))];C = C(:,X>0.1);
R = S(X>0.1);
D = sqrt(X.^2 + Y.^2 + Z.^2);D = D(X>0.1);

% cloud_3D = R0_rect * Tr_velo_to_cam * C;
cloud_3D = R0_rect * Tr_velo_to_cam * C;

% scatter3(cloud_3D(1,:),cloud_3D(2,:),cloud_3D(3,:),R)
% xlabel('x')
% ylabel('y')
% zlabel('z')
%%

cloud_2D = projectToImage(cloud_3D(1:3,:), P2);
color = D/max(D);
size = R/max(R)*10;

%%

cloud_2D = cloud_2D(:,cloud_2D(1,:)>0 & cloud_2D(1,:)<1300 & cloud_2D(2,:)>0);
color = color(cloud_2D(1,:)>0 & cloud_2D(1,:)<1300 & cloud_2D(2,:)>0);
color = round(color*64);
size = size(cloud_2D(1,:)>0 & cloud_2D(1,:)<1300 & cloud_2D(2,:)>0);
D = D(cloud_2D(1,:)>0 & cloud_2D(1,:)<1300 & cloud_2D(2,:)>0);

%%
temp = jet;
RGB = zeros(length(color),3);
for i=1:length(color)
    RGB(i,:) = temp(color(i));
end

%%

D_mod = D;
D_mod(D_mod>30) = 30;
D_mod(D_mod<3) = 3;

scatter(cloud_2D(1,:),cloud_2D(2,:),size,30-D_mod);
% scatter(cloud_2D(1,:),cloud_2D(2,:));
% plot(cloud_2D(1,:),cloud_2D(2,:),'o','LineWidth',1,'MarkerSize',1,'Color',RGB);