function c1_apexspotting(dB, vid_list,  landmarkPath,ROI_3_coordinatePath,numFile, win, file)

srcPath = ['D:/Download/ELEN417/matlab/mat_files/smic/',dB,'/'];
destPath = ['D:/Download/ELEN417/biwoof/apexspotting/results/',dB,'/lbp/'];
     
addpath('D:/Download/ELEN417/biwoof/codes/apex_lbp');
compute_ROIs (srcPath,landmarkPath, ROI_3_coordinatePath, destPath, win,  file, vid_list)
compute_correlation ([destPath,file,'/'], numFile, vid_list)
diff_plot(destPath,  file, vid_list)

