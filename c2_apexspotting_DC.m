function c2_apexspotting_DC(dB, vid_list,  srcFile, destFile)
descriptor = 'lbp';

addpath('D:/Download/ELEN417/biwoof/codes/apex_lbp_DC');

srcPath = ['D:/Download/ELEN417/biwoof/apexspotting/results/',dB,'/',descriptor,'/'];
destPath = ['D:/Download/ELEN417/biwoof/apexspotting/results/',dB,'/',descriptor,'_DC/'];

lbp_DC(srcPath,destPath,srcFile, destFile, vid_list)
