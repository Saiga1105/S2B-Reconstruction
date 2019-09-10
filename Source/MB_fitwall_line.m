%function Decoding = G_wallfit( Cx,Cy,Cz,Px,Py,Pz,dw,k,maxDistance,omega)
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

% take line if within LOA30
% if not, compute arc and poly. a reduction of at least error*inliers >2 is
% mandatory to upgrade the model

%% Load/set model parameters
load('line.mat'); % C
sampleSize=2;
k=100;
threshDist=0.15;
omega=0.7;

%% fit line (least squares)
tic
[mx1,my1, inlierNum1,error1] = F_Linefit_TLS(Cx,Cy,Px,Py,threshDist,dw);
toc
figure
plot(Cx,Cy,'o');
hold on
plot(Px(:),Py(:),'o');
hold on
plot(mx1,my1,'r-');
grid on;

%% fit line (Ransac) rho & theta
% rho en theta (this is the better one)
% tic
% [ mx2,my2, inlierNum2,error2]=F_Linefit_RANSAC1(Cx,Cy,Px,Py,k,threshDist,omega,dw);
% toc
% figure
% plot(Cx,Cy,'o');
% hold on
% plot(Px(:),Py(:),'o');
% hold on
% plot(mx,my,'r-');
% grid on;

%% fit line (Ransac)  ax + b 
tic
[mx3,my3, inlierNum3,error3] = F_Linefit_RANSAC2(Cx,Cy,Px,Py,k,threshDist,dw);
toc
figure
plot(Cx,Cy,'o');
hold on
plot(Px(:),Py(:),'o');
hold on
plot(mx3,my3,'r-');
grid on;
% fit line Automated Driving System Toolbox
% [P, inlierIdx] = fitPolynomialRANSAC([Cx,Cy],N,maxDistance);

%end
