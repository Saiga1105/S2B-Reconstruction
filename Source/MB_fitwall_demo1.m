%function Decoding = G_wallfit( Cx,Cy,Cz,Px,Py,Pz,dw,k,maxDistance,omega)
%#function UGM_Decode_ICM UGM_makeEdgeStruct

% dependencies

% parameters
% Cx = x-coordinates candidates
% Cy = y-coordinates candidates
% Px = x-coordinates eval points
% Py = y-coordinates eval points
% dw = width wall
% k = number of ransac iterations
% threshDist = max distance for inliers
% omega = theoretical ratio of inliers
% maxgrade= max grade of fitted polynomial function
% n= number of control points on fitted polynomial

clear;close;
addpath(genpath('D:\Google Drive\Research\Grasshopper Plugin Scan-to-BIM\WallReconstruction\Matlab'));
%addpath(genpath('D:\Google Drive\Research\Grasshopper Plugin Scan-to-BIM\WallReconstruction\Matlab\AGSM_toolkit_v2.3'));

%% Load/set model parameters
load('line.mat'); % C
k=100;
threshDist=0.15;
omega=0.7;
n=4;
expectedscore= omega*length(Px)/(threshDist*2)
error=zeros(6,1);
inlrNum=zeros(6,1);

figure
plot(Cx,Cy,'o');
hold on
plot(Px(:),Py(:),'o');
hold on
grid on;
%% fit line (least squares)
tic
[mxl1,myl1, inlrNum(1),error(1)] = F_Linefit_TLS(Cx,Cy,Px,Py,k,threshDist,dw,n);
toc
subplot(2,3,1)
plot(Cx,Cy,'o');
hold on
plot(Px(:),Py(:),'o');
hold on
plot(cell2mat(mxl1),cell2mat(myl1),'r-');
title('Fit Line (TLS)');

%% fit line (Ransac)  ax + b 
tic
[mxl2,myl2, inlrNum(2),error(2)] = F_Linefit_RANSAC2(Cx,Cy,Px,Py,k,threshDist,dw,n);
toc
subplot(2,3,2)
plot(Cx,Cy,'o');
hold on
plot(Px(:),Py(:),'o');
hold on
plot(cell2mat(mxl2),cell2mat(myl2),'r-');
title('Fit Line (RANSAC) ');

%% fit arc (least squares)
tic
[mxa1,mya1, inlrNum(3),error(3)] = F_Arcfit_TLS(Cx,Cy,Px,Py,k,threshDist,dw,n);
toc
subplot(2,3,3)
plot(Cx,Cy,'o');
hold on
plot(Px(:),Py(:),'o');
hold on
plot(cell2mat(mxa1),cell2mat(mya1),'r-');
title('Fit Arc (TLS)');

%% fit arc (Ransac)
tic
[ mxa2, mya2,inlrNum(4),error(4)]=F_Arcfit_RANSAC(Cx,Cy,Px,Py,k,threshDist,dw,n);
toc
subplot(2,3,4)
plot(Cx,Cy,'o');
hold on
plot(Px(:),Py(:),'o');
hold on
plot(cell2mat(mxa2),cell2mat(mya2),'r-');
title('Fit Arc (RANSAC)');

%% fit poly (Ransac bruteforce)
tic
[ mxp2,myp2, inlrNum(5),error(5)]=F_Polyfit_RANSAC2(Cx,Cy,Px,Py,k,threshDist,dw,n);
toc
subplot(2,3,5)
plot(Cx,Cy,'o');
hold on
plot(Px(:),Py(:),'o');
hold on
plot(cell2mat(mxp2),cell2mat(myp2),'r-');
title('Fit Poly (RANSAC bruteforce)');

%% fit poly (Ransac conditioned)
tic
[ mxp3,myp3, inlrNum(6),error(6)]=F_Polyfit_RANSAC3(Cx,Cy,Px,Py,k,threshDist,dw,n);
toc
subplot(2,3,6)
plot(Cx,Cy,'o');
hold on
plot(Px(:),Py(:),'o');
hold on
plot(cell2mat(mxp3),cell2mat(myp3),'r-');
title('Fit Poly (RANSAC conditioned)');

%% compute score
expectedscore
score=inlrNum./(2*error)
[~,index]=max(score);

%end

