function [ P2,R0_rect,Tr_velo_to_cam ] = readAllCalibration( calib_dir,img_idx )
%READALLCALIBRATION Read all velo2image related calibration matrix
% Coordinate Systems
% ==================
% 
% The coordinate systems are defined the following way, where directions
% are informally given from the drivers view, when looking forward onto
% the road:
% 
%   - Camera:   x: right,   y: down,  z: forward
%   - Velodyne: x: forward, y: left,  z: up
%   - GPS/IMU:  x: forward, y: left,  z: up
% 
% All coordinate systems are right-handed.
% 
% Sensor Calibration
% ==================
% 
% The sensor calibration zip archive contains files, storing matrices in
% row-aligned order, meaning that the first values correspond to the first
% row:
% 
% calib_cam_to_cam.txt: Camera-to-camera calibration
% --------------------------------------------------
% 
%   - S_xx: 1x2 size of image xx before rectification
%   - K_xx: 3x3 calibration matrix of camera xx before rectification
%   - D_xx: 1x5 distortion vector of camera xx before rectification
%   - R_xx: 3x3 rotation matrix of camera xx (extrinsic)
%   - T_xx: 3x1 translation vector of camera xx (extrinsic)
%   - S_rect_xx: 1x2 size of image xx after rectification
%   - R_rect_xx: 3x3 rectifying rotation to make image planes co-planar
%   - P_rect_xx: 3x4 projection matrix after rectification
% 
% Note: When using this dataset you will most likely need to access only
% P_rect_xx, as this matrix is valid for the rectified image sequences.
% 
% calib_velo_to_cam.txt: Velodyne-to-camera registration
% ------------------------------------------------------
% 
%   - R: 3x3 rotation matrix
%   - T: 3x1 translation vector
%   - delta_f: deprecated
%   - delta_c: deprecated
% 
% R|T takes a point in Velodyne coordinates and transforms it into the
% coordinate system of the left video camera. Likewise it serves as a
% representation of the Velodyne coordinate frame in camera coordinates.
% 
% calib_imu_to_velo.txt: GPS/IMU-to-Velodyne registration
% -------------------------------------------------------
% 
%   - R: 3x3 rotation matrix
%   - T: 3x1 translation vector
% 
% R|T takes a point in GPS/IMU coordinates and transforms it into the
% coordinate system of the Velodyne scanner. Likewise it serves as a
% representation of the GPS/IMU coordinate frame in Velodyne coordinates.
% 
% example transformations
% -----------------------
% 
% As the transformations sometimes confuse people, here we give a short
% example how points in the velodyne coordinate system can be transformed
% into the camera left coordinate system.
% 
% In order to transform a homogeneous point X = [x y z 1]' from the velodyne
% coordinate system to a homogeneous point Y = [u v 1]' on image plane of
% camera xx, the following transformation has to be applied:
% 
% Y = P_rect_xx * R_rect_00 * (R|T)_velo_to_cam * X
% 
% To transform a point X from GPS/IMU coordinates to the image plane:
% 
% Y = P_rect_xx * R_rect_00 * (R|T)_velo_to_cam * (R|T)_imu_to_velo * X
% 
% The matrices are:
% 
% - P_rect_xx (3x4):         rectfied cam 0 coordinates -> image plane
% - R_rect_00 (4x4):         cam 0 coordinates -> rectified cam 0 coord.
% - (R|T)_velo_to_cam (4x4): velodyne coordinates -> cam 0 coordinates
% - (R|T)_imu_to_velo (4x4): imu coordinates -> velodyne coordinates
% 
% Note that the (4x4) matrices above are padded with zeros and:
% R_rect_00(4,4) = (R|T)_velo_to_cam(4,4) = (R|T)_imu_to_velo(4,4) = 1.
  
  data = dlmread(sprintf('%s/%06d.txt',calib_dir,img_idx),' ',0,1);
  P2 = data(3,:); % projection matrix after rectification
  P2 = reshape(P2 ,[4,3])';
  R0_rect = data(5,1:9);
  R0_rect = reshape(R0_rect ,[3,3])';
  R0_rect = [[R0_rect;[0,0,0]],[0;0;0;1]];
  Tr_velo_to_cam = data(6,:);
  Tr_velo_to_cam = reshape(Tr_velo_to_cam ,[4,3])';
  Tr_velo_to_cam = [Tr_velo_to_cam;[0,0,0,1]];

end

