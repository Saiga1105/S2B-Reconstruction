%function [Mx,My,inlrNum,error] = G_wallfit( Cx,Cy,Cz,Px,Py,Pz,k,threshDist,dw,omega,n)
%#function distance2curve,F_Linefit_TLS, F_Linefit_RANSAC2, F_Arcfit_TLS, F_Arcfit_RANSAC, F_Polyfit_RANSAC2, F_Polyfit_RANSAC3

% parameters
% Cx = x-coordinates candidates
% Cy = y-coordinates candidates
% Px = x-coordinates eval points
% Py = y-coordinates eval points
% dw = width wall
% k = number of ransac iterations
% threshDist = max distance for inliers
% omega = theoretical ratio of inliers
% n= number of control points on fitted polynomial

clear;close;
addpath(genpath('D:\Google Drive\Research\Grasshopper Plugin Scan-to-BIM\WallReconstruction\Matlab'));
%addpath(genpath('D:\Google Drive\Research\Grasshopper Plugin Scan-to-BIM\WallReconstruction\Matlab\AGSM_toolkit_v2.3'));

%% Load/set model parameters
load('poly.mat'); % C
k=100;
threshDist=0.15;
omega=0.7;
n=4;

funct={@(Cx,Cy,Px,Py,k,threshDist,dw,n)F_Linefit_TLS(Cx,Cy,Px,Py,k,threshDist,dw,n),...
    @(Cx,Cy,Px,Py,k,threshDist,dw,n)F_Linefit_RANSAC2(Cx,Cy,Px,Py,k,threshDist,dw,n),...
    @(Cx,Cy,Px,Py,k,threshDist,dw,n)F_Arcfit_TLS(Cx,Cy,Px,Py,k,threshDist,dw,n),...
    @(Cx,Cy,Px,Py,k,threshDist,dw,n)F_Arcfit_RANSAC(Cx,Cy,Px,Py,k,threshDist,dw,n),...
    @(Cx,Cy,Px,Py,k,threshDist,dw,n)F_Polyfit_RANSAC2(Cx,Cy,Px,Py,k,threshDist,dw,n),...
    @(Cx,Cy,Px,Py,k,threshDist,dw,n)F_Polyfit_RANSAC3(Cx,Cy,Px,Py,k,threshDist,dw,n)};

expectedscore= omega*length(Px)/(threshDist*2);
error=zeros(length(funct),1);
inlrNum=zeros(length(funct),1);
score=zeros(length(funct),1);
i=1;
tic
while i<=length(funct)
    [mx{i},my{i}, inlrNum(i),error(i)]=funct{i}(Cx,Cy,Px,Py,k,threshDist,dw,n);
    %[mx{:,1,i},my{:,1,i}, inlrNum(i),error(i)]=funct{i}(Cx,Cy,Px,Py,k,threshDist,dw,n);
    score(i)= inlrNum(i)/(error(i)*2);
    if score(i) >= expectedscore  
        break
    end
    i=i+1;
end
[~,i]=max(score);
error=error(i);
inlrNum=inlrNum(i);

switch i
    case {1,2}
        mx=cell2mat(mx{i});
        my=cell2mat(my{i});
        Mx(1)=mx(1);Mx(2)=mx(end);
        My(1)=my(1);My(2)=my(end);
    case {3,4}
        mx=cell2mat(mx{i});
        my=cell2mat(my{i});
        Mx(1)=mx(1);Mx(2)=mx(ceil(end/2));Mx(3)=mx(end);
        My(1)=my(1);My(2)=my(ceil(end/2));My(3)=my(end);
    case {5,6}
        Mx= cell2mat(mx{i});
        My= cell2mat(my{i});
end

toc

figure
plot(Cx,Cy,'o');
hold on
plot(Px(:),Py(:),'o');
hold on
plot(Mx,My,'r-');
title('Fit wall function');

%end

