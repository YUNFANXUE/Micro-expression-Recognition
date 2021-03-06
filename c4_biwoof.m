function c4_biwoof(blockNum, dB, vid_list, fName)

addpath(genpath('D:/Download/ELEN417/biwoof/codes')); %  weightedhistc, f_recog_LOS, micro_f_r_p
descriptor = 'lbp_DC';
type=[descriptor,'_1vsapex_',fName];

magPath = ['D:/Download/ELEN417/biwoof/apexspotting/results/',dB,'/apex_tvl1/',type,'/magnitude/'];
orientPath = ['D:/Download/ELEN417/biwoof/apexspotting/results/',dB,'/apex_tvl1/',type,'/orientation/'];    
osPath = ['D:/Download/ELEN417/biwoof/apexspotting/results/',dB,'/apex_tvl1/',type,'/os/']; 

lamda = 0.4; 
nBin = 8;       
nW = blockNum;

% blockNum: roi divide into blockNum^2 blocks
% 
blockSize = 2;
blockStep = 1;
featureBlock = (blockNum - blockSize)/ blockStep + 1;

useslidewin = 1;

nH = nW;
file = ['biwoof_',num2str(nBin),'bin'];
dest = ['D:/Download/ELEN417/biwoof/EmotionRecognition/',dB,'/Histogram/'];
if ~exist([dest,file])
    mkdir([dest,file]);            
end

data_mat = [];

for vid = 1:size(vid_list,1)

    sub_path = vid_list{vid};
    mag = load([magPath,sub_path]); % magnitude
    mag = cell2mat(struct2cell(mag));

    orient = load([orientPath,sub_path]);   % orientation
    orient = cell2mat(struct2cell(orient));

    os = load([osPath,sub_path]);   % optical strain
    os = cell2mat(struct2cell(os));

    Hist = [];
    histtt = [];
    histt = [];
    sumMag = [];
    % 5 x 5 block BiWOOF feature extraction
    [nheight nwidth] = size(orient);
    
    if useslidewin == 1   %use sliding window
        
    h=floor(nheight/10); w=floor(nwidth/2);
    ah=0;bh=0;aw=0;bw=0;
    
    for fh=1:featureBlock
        for fw=1:2
            if fh==1
                ah=1;
                bh=ah + h * blockSize - 1;
            else
                ah=  (fh - 1) * h + 1 ;
                bh= ah + h * blockSize - 1 ;
            end

            if fw==1
                aw=1;
                bw= aw + w * 1 -1 ;
            else
                aw= (fw - 1) * w + 1;
                bw= aw + w * 1 - 1 ;
            end
    
            % reshape to 1 row 
            orientRow = reshape(orient([ah:bh], [aw:bw],:) , [] ,1);    
            magRow = reshape(mag([ah:bh], [aw:bw],:) , [] ,1);
            osRow = reshape(os([ah:bh], [aw:bw],:) , [] ,1);        
            
            % get global weight (each block) pf optical strain 
            sumMag = [sumMag,sum(osRow)]; 
            
            
            % weight magnitude locally (each bin) 
            histt = weightedhistc(orientRow,magRow,[-180:360/nBin:179.999999]);
            histt = histt/sum(histt);
            
            
           % %feature alignment
           % histt_sto = zeros(1, nBin)
           % for blonum = 1:nBin
           %     if blonum < nBin
           %     histt_sto(blonum) = histt(blonum) + histt(blonum + 1);
           %     else
           %      histt_sto(blonum) = histt(blonum) + histt(1); 
           %     end
           % end
           %[mx_value,IX] = sort(histt_sto, 'descend');
            
            [mx_value,IX] = sort(histt, 'descend');
            %direction_index = [pi/8, 3* pi/8, 5* pi/8, 7* pi/8, 9* pi/8, 11* pi/8, 13* pi/8, 15* pi/8];
            %if IX(1) == 8
            %   IX_up = 1;
            %else
            %    IX_up = IX(1) + 1;
            %end
            %if IX(1) == 1
            %    IX_down = 8;
            %else
            %    IX_down = IX(1) - 1;
            %end
            %mx_up = histt(IX_up)
            %mx_down = histt(IX_down)
            
            histt = zeros(1, nBin);
            histt(IX(1)) = lamda * mx_value(1);
            histt(IX(2)) = (1 - lamda) * mx_value(2);
            histt(IX(3)) = (1 - lamda) * mx_value(3);
            histt(IX(4)) = (1 - lamda) * mx_value(4);
            histt(IX(5)) = (1 - lamda) * mx_value(5);
            %histt(IX(6)) = (1 - lamda) * mx_value(6);
            %histt(IX(7)) = (1 - lamda) * mx_value(7);
            %histt(IX(8)) = (1 - lamda) * mx_value(8);
            %histt(IX_up) = mx_up;
            %histt(IX_down) = mx_down;
            
            %histt = zeros(1,2);
            %histt(1) = lamda * mx_value(1);
            %histt(2) = (1- lamda) * IX(1) / 8;
            %histtt = [histtt,histt];
            %histt(1) = lamda * mx_value(2);
            %histt(2) = (1- lamda) * IX(2) / 8;
            %histtt = [histtt,histt];

            Hist = [Hist,histt];
            

            
        end
    end
    else   % not using sliding window
        
        h=floor(nheight/nH); w=floor(nwidth/nW);
        ah=0;bh=0;aw=0;bw=0;
        
        for hh=1:nH
        for ww=1:nW
            if hh==1
                ah=1;
                bh=hh*h ;
            %elseif hh==nH
            %    ah=(hh-1)*h + 1;
            %    bh=nheight;
            else
                ah=(hh-1)*h + 1;
                bh=hh*h ;
            end

            if ww==1
                aw=1;
                bw=ww*w ;
            %elseif ww==nW
            %    aw=(ww-1)*w + 1;
            %    bw=nwidth;
            else
                aw=(ww-1)*w + 1;
                bw=ww*w ;
            end
    
            % reshape to 1 row 
            orientRow = reshape(orient([ah:bh], [aw:bw],:) , [] ,1);    
            magRow = reshape(mag([ah:bh], [aw:bw],:) , [] ,1);
            osRow = reshape(os([ah:bh], [aw:bw],:) , [] ,1);        
            
            % get global weight (each block) pf optical strain 
            sumMag = [sumMag,sum(osRow)]; 
            
            
            % weight magnitude locally (each bin) 
            histt = weightedhistc(orientRow,magRow,[-180:360/nBin:179.999999]);
            histt = histt/sum(histt);            
            
            [mx_value,IX] = sort(histt, 'descend');
          
            histt = zeros(1, nBin);
            histt(IX(1)) = lamda * mx_value(1);
            histt(IX(2)) = (1 - lamda) * mx_value(2);
            histt(IX(3)) = (1 - lamda) * mx_value(3);
            histt(IX(4)) = (1 - lamda) * mx_value(4);
            %histt(IX(5)) = (1 - lamda) * mx_value(5);
            %histt(IX(6)) = (1 - lamda) * mx_value(6);
            %histt(IX(7)) = (1 - lamda) * mx_value(7);
            %histt(IX(8)) = (1 - lamda) * mx_value(8);
           
            Hist = [Hist,histt];
        end
    end
        
    end

    %weight optical strain globally (each block) 
    for loop = 1:length(sumMag)
         Hist((loop-1)* 8+1 : loop*8) = Hist((loop-1)*8+1 : loop*8) * sumMag(loop);
    end
    
    Hist = Hist/norm(Hist); 
    if ~exist([dest,file,'/',vid_list{vid}])
        mkdir([dest,file,'/',vid_list{vid}])
    end
    save([dest,file,'/',vid_list{vid},'/Hist.mat'] , 'Hist');
    fclose('all');
end

for vid =  1:size(vid_list,1)
    temp = load([dest,file,'/',vid_list{vid},'/Hist.mat']);        
    data_mat(vid,:) = temp.Hist;
end
rmdir([dest,file],'s');
mkdir([dest,file]);
save([dest,file,'/',file,'.mat'],'data_mat');   

% Performance accuracy, Leave one subject out 
f_recog_LOS(file, dB) % accuracy