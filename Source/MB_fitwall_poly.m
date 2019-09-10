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
% maxgrade= max grade of fitted polynomial function
% n= number of control points on fitted polynomial

clear;close;
addpath(genpath('D:\Google Drive\Research\Grasshopper Plugin Scan-to-BIM\WallReconstruction\Matlab'));
%addpath(genpath('D:\Google Drive\Research\Grasshopper Plugin Scan-to-BIM\WallReconstruction\Matlab\AGSM_toolkit_v2.3'));

%% Load/set model parameters
load('poly.mat'); % C
sampleSize=2;
k=100;
maxgrade=3;
threshDist=0.15;
omega=0.7;
n=4;
%[Cx,Cy] = F_sortpoints(Cx,Cy);

%% fit poly (least squares)
tic
[mx1,my1, inlierNum1,error1] = F_Polyfit_TLS(Cx,Cy,Px,Py,threshDist,dw,maxgrade);
toc
figure
plot(Cx,Cy,'o');
hold on
plot(Px(:),Py(:),'o');
hold on
plot(mx1,my1,'r-');

grid on;

%% fit poly (conditioned Ransac) sensitive to point order
tic
[ mx2,my2, inlierNum2,error2]=F_Polyfit_RANSAC1(Cx,Cy,Px,Py,k,threshDist,dw,n);
toc
figure
plot(Cx,Cy,'o');
hold on
plot(Px(:),Py(:),'o');
hold on
plot(mx2,my2,'r-');
%plot(sampleIdx(:,1,i),sampleIdx(:,2,i),'-r');
grid on;

%% fit poly (random Ransac)
tic
[ mx3,my3, inlierNum3,error3]=F_Polyfit_RANSAC2(Cx,Cy,Px,Py,k,threshDist,dw,n);
toc
figure
plot(Cx,Cy,'o');
hold on
plot(Px(:),Py(:),'o');
hold on
%plot(sampleIdx(:,1,i),sampleIdx(:,2,i),'o');
plot(mx3,my3,'r-');

%plot(sample(:,1),sample(:,2),'-r');
grid on;
%end
