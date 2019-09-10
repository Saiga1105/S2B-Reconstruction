function [mx,my, inlierNum, error] = F_Polyfit_TLS(Cx,Cy,Px,Py,k,threshDist,dw,n)
%F_Polyfit_TLS Computes best fit polynomial up to maxgrade through Total Least Squares
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

mx=linspace(min(Cx),max(Cx),abs(max(Cx)-min(Cx))*10)';
my=zeros(length(mx),maxgrade);
error= zeros(maxgrade,1);
inlierNum=zeros(maxgrade,1);

for i=1:maxgrade
    modelLeastSquares = polyfit(Cx,Cy,i);
    for j = 0:i
        my(:,i) = my(:,i) + modelLeastSquares(j+1).*mx.^(i-j);

    end
%     plot(mx,my(:,i),'-r');
%     hold on
    
    % compute perpendicular distance
    mapxy=[mx my(:,i)];
    curvexy= [Px Py];
    [~,distance,~] = distance2curve(curvexy,mapxy,'linear');
    error(i,1)=mean(abs(abs(distance)-dw/2));
    
    % compute number of inliers
    inlierIdx = find(dw/2-threshDist<=abs(distance) & abs(distance)<=dw/2+threshDist);
    inlierNum(i,1) = length(inlierIdx);
end
    
score=inlierNum./error;
[~,index]=max(score);
inlierNum=inlrNum(index);
error = error(index);
my= my(:,index);
mx=num2cell(mx);
my=num2cell(my);
end

