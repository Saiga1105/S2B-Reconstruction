function [mx, my,inlierNum, error] = F_Polyfit_RANSAC2(Cx,Cy,Px,Py,k,threshDist,dw,n)
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

 if n<2
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
    invalid=true;
    while invalid
        sample= data(randperm( length(Cx),n),:);
        dist=pdist2(sample,sample);
        b=0;
        for a=1:n-2
                if dist(a,a+1)>=DimXY/n*0.5 & dist(a,a+1)<=DimXY/n*1.5 & ...
                    dist(a,a+2)>=(dist(a,a+1)+DimXY/n*0.5) & dist(a,a+2)<=(dist(a,a+1)+DimXY/n*1.5) & ...
                    dist(a+1,a+2)>=DimXY/n*0.5 & dist(a+1,a+2)<=DimXY/n*1.5
                else
                    b=b+1;
                end
        end
        if b<1
            invalid=false;
            sampleIdx(:,:,i)=sample(:,:);
            %plot(sample(:,1),sample(:,2),'-r')
        end
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
  
 mx=  sampleIdx(:,1,index);
my= sampleIdx(:,2,index);
mx=num2cell(mx);
my=num2cell(my);
end

