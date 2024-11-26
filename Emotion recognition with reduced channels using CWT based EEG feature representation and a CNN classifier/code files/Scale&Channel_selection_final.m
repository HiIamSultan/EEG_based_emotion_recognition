%% clear all/ close figs
close all
clear all
clc

%% default paramters
Participant = 32;
Video = 40;
Channel = 32;
Fs = 128;
Time = 63;
addpath('G:\Study\L-3, T-2\OneDrive - BUET\EEG datasets\DEAP dataset\data_preprocessed_matlab') 
%G:\Study\L-3, T-2\OneDrive - BUET\124 Thesis\DREAMER

%% set parameters
frameNum = 10;
totalScale = 64;
wname = 'db4';

%%
allsumEER = zeros(totalScale,32);
for participant = 1:Participant
fprintf('\nworking on file number %d:\n', participant);
if(participant<10)
myfilename = sprintf('s0%d.mat', participant);
else
myfilename = sprintf('s%d.mat', participant);
end
load(myfilename);
for video=1:Video
%fprintf(filename);
sumEER = zeros(totalScale,32);
datastart=128*3;
datalength=8064-128*3;

for channel = 1:Channel
data1=zeros(1,8064-datastart);
for ii =1:datalength
data1(1,ii)=data(video,channel,ii+datastart); %(7680)
end
% decompose into wavelets
% set scales
f = 1:totalScale;
f = Fs/totalScale * f;
wcf = centfrq(wname);
scal = Fs * wcf./ f;
coefs = cwt(data1, 1:64, wname);%(64,7680)
% Figures
% 3d Figure
%surf(coefs);shading interp;
energy = abs(coefs.*coefs);%(64,7680)
scaleEnergy = sum(energy,2);%(64)
s = repmat(scaleEnergy,1,datalength);%(64,7680)
p = energy./s;%(64,7680)
entropy = -p.*log(p);%(64,7680)
scaleEntropy = sum(entropy,2);%(64)
EER = scaleEnergy./scaleEntropy;%(64)
sumEER(:,channel) = EER;%(64,7680)
end
allsumEER = allsumEER + sumEER;%(64,7680)
% figure
%plot(mean(sumEER,2),'*');
%xlabel('Energy/Entropy');
%ylabel('Scales')
%title('Average EER over All EEG Channels');
fprintf('.');
end 
end 
%allsumEER_norm = normalize(allsumEER,'norm');  ####normalize(allsumEER,2,'range');
figure
surf(allsumEER)