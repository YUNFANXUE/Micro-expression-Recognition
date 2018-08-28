function c3_compute_Flow_apex_tvl1_1vsapex(dB, vid_list, fName)

addpath(genpath('/Download/ELEN417/matlab/code'))  % for tvl1flow_3     
descriptor = 'lbp_DC';
lbp_apex = ['/Download/ELEN417/biwoof/apexspotting/results/',dB,'/',descriptor,'/',fName,'/'];

load([lbp_apex,'maxROI_Frame']);
apex = maxROI_Frame(:,3); %[maxRoI, 0, maxFrame, 0]

type = [descriptor,'_1vsapex_',fName,];
srcPath = ['D:/Download/ELEN417/db/smic/',dB,'/'];
codePath = 'D:/Download/ELEN417/matlab/code/tvl1flow_3';
destPath = ['D:/Download/ELEN417/biwoof/apexspotting/results/',dB,'/apex_tvl1/',type,'/flo/'];

for v =1 : length(vid_list)
    sub_path = vid_list{v};

    if ~exist([destPath, sub_path])
        mkdir([destPath, sub_path]);            
    end
    tmp=dir([srcPath, sub_path,'/','*.png']);
    if apex(v) ==0
        apex(v) =1;
    end
    if apex(v)>length(tmp)
        apex(v) = length(tmp);
    end
        i1 = [srcPath, sub_path,'/',tmp(1).name];
        i2 = [srcPath, sub_path,'/',tmp(apex(v)).name];

         if ~exist([destPath,sub_path , '/1vs' , num2str(apex(v)), '.flo'])
            cmd = [codePath,'/tvl1flow ' , i1 ,' ', i2 ,' ', destPath , sub_path , '/1vs' , num2str(apex(v)), '.flo'];
            % To run tvl1flow
            [status, cmout] = system(['D:\Download\ELEN417\cygwin\bin\bash --login -c ','"',cmd,'"']); 
            close all;
         end
end
   
srcPath = ['/Download/ELEN417/biwoof/apexspotting/results/',dB,'/apex_tvl1/',type,'/flo/'];
magPath = ['/Download/ELEN417/biwoof/apexspotting/results/',dB,'/apex_tvl1/',type,'/magnitude/'];
orientPath = ['/Download/ELEN417/biwoof/apexspotting/results/',dB,'/apex_tvl1/',type,'/orientation/'];
uPath = ['/Download/ELEN417/biwoof/apexspotting/results/',dB,'/apex_tvl1/',type,'/of_u/'];
vPath = ['/Download/ELEN417/biwoof/apexspotting/results/',dB,'/apex_tvl1/',type,'/of_v/'];
osPath = ['/Download/ELEN417/biwoof/apexspotting/results/',dB,'/apex_tvl1/',type,'/os/'];

% Compute u, v, optical strain, magnitude, orientation
for ind =1 : length(vid_list)
    sub_path = vid_list{ind};
    subName = strsplit(sub_path,'/');
    if ~exist([magPath, subName{1}])
        mkdir([magPath, subName{1}]);    
        mkdir([orientPath, subName{1}]);
        mkdir([uPath, subName{1}]);
        mkdir([vPath, subName{1}]);
        mkdir([osPath, subName{1}]);
    end
    tmpdir = dir([srcPath,sub_path,'/*.flo']);
    tmp = readFlowFile([srcPath,sub_path,'/',tmpdir(1).name]);
    u = tmp(:,:,1);
    v = tmp(:,:,2);

    [x,y]=size(u);
    u_x=u(:,1:y)-u(:,[1,1:y-1]);
    v_y=v(1:x,:)-v([1,1:x-1],:);
    u_y=u(1:x,:)-u([1,1:x-1],:);
    v_x=v(:,1:y)-v(:,[1,1:y-1]);

    mat = sqrt((u_x.^2)+v_y.^2+1/2*(u_y+v_x).^2);   %optical strain
    mat_u = u;
    mat_v = v;
    magnitude = sqrt(u.^2 + v.^2);
    orientation = atan2(v,u)*180/pi;

    save ([uPath , vid_list{ind}, '.mat'], 'mat_u') 
    save ([vPath , vid_list{ind}, '.mat'], 'mat_v') 
    save ([osPath , vid_list{ind}, '.mat'], 'mat')  %optical strain
    save ([magPath , vid_list{ind}, '.mat'], 'magnitude') 
    save ([orientPath , vid_list{ind}, '.mat'], 'orientation') 
end
