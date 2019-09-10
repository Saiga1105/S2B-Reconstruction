%function Decoding = G_wallfit( Cx,Cy,Px,Py,dw,k,threshDist,omega)
%#function UGM_Decode_ICM UGM_makeEdgeStruct

% dependencies
% Active geometric shape models (https://sites.google.com/site/agsmwiki/)(Wang et al., 2012)

% parameters
% Cx = x-coordinates candidates
% Cy = y-coordinates candidates
% Px = x-coordinates eval points
% Py = y-coordinates eval points
% dw = width wall
% k = number of ransac iterations
% threshDist = max distance for inliers
% omega = theoretical ratio of inliers

clear;close;
addpath(genpath('D:\Google Drive\Research\Grasshopper Plugin Scan-to-BIM\WallReconstruction\Matlab'));
%addpath(genpath('D:\Google Drive\Research\Grasshopper Plugin Scan-to-BIM\WallReconstruction\Matlab\AGSM_toolkit_v2.3'));

%% Load/set model parameters
load('arc.mat'); % C
sampleSize=3;
k=100;
threshDist=0.15;
omega=0.7;

%% fit arc (least squares)
[mx1,my1, inlierNum1,error1] = F_Arcfit_TLS(Cx,Cy,Px,Py,threshDist,dw);

figure
plot(Cx,Cy,'o');
hold on
plot(Px(:),Py(:),'o');
hold on
plot(mx1,my1,'r-');
hold on
grid on;

%% fit arc (Ransac)
[mxa2, mya2,inlierNum2,error2]=F_Arcfit_RANSAC(Cx, Cy, Px,Py, k, threshDist,dw);
figure
plot(Cx,Cy,'o');
hold on
plot(Px(:),Py(:),'o');
hold on
plot(mx, my,'r-');
grid on;

%end
