% KITTI OBJECT DETECTION AND ORIENTATION ESTIMATION BENCHMARK DEMONSTRATION
% 
% This tool displays the images and the object labels for the benchmark and
% provides an entry point for writing your own interface to the data set.
% Before running this tool, set root_dir to the directory where you have
% downloaded the dataset. 'root_dir' must contain the subdirectory
% 'training', which in turn contains 'image_2', 'label_2' and 'calib'.
% For more information about the data format, please look into readme.txt.
%
% Usage:
%   SPACE: next frame
%   '-':   last frame
%   'x':   +10 frames
%   'y':   -10 frames
%   q:     quit
%
% Occlusion Coding:
%   green:  not occluded
%   yellow: partly occluded
%   red:    fully occluded
%   white:  unknown
%
% Truncation Coding:
%   solid:  not truncated
%   dashed: truncated

% clear and close everything
clear
close all
clc
disp('======= KITTI DevKit Demo =======');

% options
% root_dir = '/media/data/kitti/2012_object';
data_set = 'training';

% get sub-directories
cam = 2; % 2 = left color camera
% image_dir = fullfile(root_dir,[data_set '/image_' num2str(cam)]);
% label_dir = fullfile(root_dir,[data_set '/label_' num2str(cam)]);
% calib_dir = fullfile(root_dir,[data_set '/calib']);

image_dir = '/home/zhi/Downloads/KITTI/data_object_image_2/training/image_2';
label_dir = '/home/zhi/Downloads/KITTI/data_object_label_2/training/label_2';
calib_dir = '/home/zhi/Downloads/KITTI/data_object_calib/training/calib';
velodyne_dir = '/home/zhi/Downloads/KITTI/data_object_velodyne/training/velodyne';

% get number of images for this dataset
nimages = length(dir(fullfile(image_dir, '*.png')));

% set up figure
[h,sz] = visualization('init',image_dir);

%%

% main loop
img_idx=1010;
while 1

  % load projection matrix
  P = readCalibration(calib_dir,img_idx,cam);
  
  % load labels
  objects = readLabels(label_dir,img_idx);
  
  % visualization update for next frame
  sz = visualization('update',image_dir,h,img_idx,nimages,data_set);
 
  % for all annotated objects do
  for obj_idx=1:numel(objects)
   
    % plot 2D bounding box
    drawBox2D(h,objects(obj_idx));
    
    % plot 3D bounding box
    [corners,face_idx] = computeBox3D(objects(obj_idx),P);
    orientation = computeOrientation3D(objects(obj_idx),P);
    drawBox3D(h, objects(obj_idx),corners,face_idx,orientation);
    
  end
  
  % Draw Velodyne points
  point_cloud = readVelodyne( velodyne_dir, img_idx );
  [ P2,R0_rect,Tr_velo_to_cam ] = readAllCalibration( calib_dir,img_idx );
  [ cloud_2D,D,R ] = computeVelodyne3D( point_cloud, P2,R0_rect,Tr_velo_to_cam );
  drawVelodyne( h, cloud_2D,D,R*200+0.0002,sz )
  
  % force drawing and tiny user interface
  waitforbuttonpress; 
  key = get(gcf,'CurrentCharacter');
  switch lower(key)                         
    case 'q',  break;                                 % quit
    case '-',  img_idx = max(img_idx-1,  0);          % previous frame
    case 'x',  img_idx = min(img_idx+1000,nimages-1); % +100 frames
    case 'y',  img_idx = max(img_idx-1000,0);         % -100 frames
    otherwise, img_idx = min(img_idx+1,  nimages-1);  % next frame
  end

end

% clean up
close all;
