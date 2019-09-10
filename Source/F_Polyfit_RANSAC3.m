function [mx, my,inlierNum, error] = F_Polyfit_RANSAC3(Cx,Cy,Px,Py,k,threshDist,dw,n)
%F_Polyfit_RANSAC Computes best fit spline with n controlpoints through RANSAC
 % Cx = 1 x n matrix with x coordinates of data points
 % Cy = 1 x n matrix with y coordinates of data points
 % Px = x-coordinates eval points
 % Py = y-coordinates eval points
 % k: the number of iterations
 % threshDist: the threshold of the distances between points and the fitting line
 % dw = width wall 
 % maxgrade= max grade of fitted polynomial function
 % n= number of control points on fitted polynomial
  
%#function distance2curve 

 if n<3
     msgbox('Error: n should be >2')
     return
 end
 
data= [Cx Cy];
mapxy=[Px Py];

sampleIdx=zeros(n,2,k);
error=zeros(k,1);
inlrNum=zeros(k,1);
DimXY=sqrt((max(Cx)-min(Cx)).^2+(max(Cy)-min(Cy)).^2);

 for i = 1:k
    % 1. conditioned sample n controlpoints from [Cx Cy] > dw
    
    
    % pick first sample 2n furthest points from centre of data
    try
    dataset=data;
    dataset1=data;
    [Idx_remove,~]=knnsearch(data,mean(data),'K',ceil(length(Cx)/n*(n-2)));
    dataset1(Idx_remove,:)=[];
    sample= dataset1(randperm( size(dataset1,1),1),:);
    
    % pick second sample on reduced dataset DimXY/n*0.5
    [Idx_remove,~] = rangesearch(dataset,sample(1,:),DimXY/n*0.5);
    dataset(cell2mat(Idx_remove),:)=[];
    [Idx_pick,~] = rangesearch(dataset,sample(1,:),DimXY/n*1.5);
    Idx_pick=cell2mat(Idx_pick);
    sample(2,:)=dataset(Idx_pick(randi( length(Idx_pick),1)),:);
    
    % pick other samples based on reduced dataset by distance n-1 and n-2
        for j=3:n
            [Idx_remove,~] = rangesearch(dataset,sample(j-1,:),DimXY/n*0.5);
            dataset(cell2mat(Idx_remove),:)=[];
            [Idx_remove,~] = rangesearch(dataset,sample(j-2,:),DimXY/n*0.5+pdist(sample(j-2:j-1,:)));
            dataset(cell2mat(Idx_remove),:)=[];

            [Idx_pick,~] = rangesearch(dataset,sample(j-1,:),DimXY/n*1.5);
            Idx_pick=cell2mat(Idx_pick);
            sample(j,:)=dataset(Idx_pick(randi( length(Idx_pick),1)),:);
        end
    sampleIdx(:,:,i)=sample;    
    catch
        continue
    end

    % compute perpendicular distance
    curvexy=sampleIdx(:,:,i);
    [~,distance,~] = distance2curve(curvexy,mapxy,'linear');
    error(i,1)=mean(abs(abs(distance)-dw/2));

    % compute number of inliers
    inlierIdx = find(dw/2-threshDist<=abs(distance) & abs(distance)<=dw/2+threshDist);
    inlrNum(i,1) = length(inlierIdx);
  
 end
score=inlrNum./(2*error);
[~,index]=max(score);
inlierNum=inlrNum(index);
error = error(index);

sample=sampleIdx(:,:,index);
%sample2=sample;
% for i=1:n
%     [Idx_adjust,~] = rangesearch(mapxy,sample(i,:),dw);
%     %sample(i,:)=mean(mapxy(cell2mat(Idx_adjust),:));
%     A=mapxy(cell2mat(Idx_adjust),:)-sample(i,:);
%     signal=mean(A)./abs(mean(A));
%     %A=A.^2;
%     b=zeros(size(A,1),1);
%     b(:)=(dw/2)^2;
%     %b=[dw/2 ;dw/2];
%     X = linsolve(A,b);
%     %X=sqrt(X)'.*signal;
%     sample(i,:)=sample(i,:)+X';
% end
  
mx= sample(:,1);
my= sample(:,2);
mx=num2cell(mx);
my=num2cell(my);
end

