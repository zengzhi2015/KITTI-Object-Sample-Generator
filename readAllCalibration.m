function [ P2,R0_rect,Tr_velo_to_cam ] = readAllCalibration( calib_dir,img_idx )
%READALLCALIBRATION Read all velo2image related calibration matrix
%   Detailed explanation goes here
  % load 3x4 projection matrix
  
  data = dlmread(sprintf('%s/%06d.txt',calib_dir,img_idx),' ',0,1);
  P2 = data(3,:);
  P2 = reshape(P2 ,[4,3])';
  R0_rect = data(5,1:9);
  R0_rect = reshape(R0_rect ,[3,3])';
  R0_rect = [[R0_rect;[0,0,0]],[0;0;0;1]];
  Tr_velo_to_cam = data(6,:);
  Tr_velo_to_cam = reshape(Tr_velo_to_cam ,[4,3])';
  Tr_velo_to_cam = [Tr_velo_to_cam;[0,0,0,1]];

end

