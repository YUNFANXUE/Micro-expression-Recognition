clc
clear all
dB = 'smic_resized';

load(['D:/Download/ELEN417/matlab/mat_files/smic/',dB,'/vid_list.mat'])
landmarkPath = ['D:/Download/ELEN417/matlab/mat_files/smic/full_landmarks_resized_small/'];                      % all 66 landmark locations
ROI_3_coordinatePath = ['D:/Download/ELEN417/matlab/mat_files/smic/landmark_coordinate_resized_small/'];         % boundary of ROI
        
numFile = 3;            % 3 sub regions
win = 10;                  % add margin 10 pixels

file = [num2str(numFile),'ROI_win',num2str(win)];   % 3ROI_win10

c1_apexspotting(dB, vid_list, landmarkPath,ROI_3_coordinatePath, numFile, win, file);   % apex = peak 
c2_apexspotting_DC(dB, vid_list, file, ['DCmag_',file]);                                % use Divide & Conquer spot apex

c3_compute_Flow_apex_tvl1_1vsapex(dB, vid_list, ['DCmag_',file]);       %   Compute Optical Flow using TVL1
%%
nblockNum = 10;       % 5x5 BiWOOF feature extractio
c4_biwoof(nblockNum, dB, vid_list, ['DCmag_',file]);                                                                         % BiWOOF feature extraction