function [mx,my, inlierNum, error] = F_Linefit_TLS(Cx,Cy,Px,Py,k,threshDist,dw,n)
%F_Linefit Computes best fit line through Total Least squares
 % Cx = 1 x n matrix with x coordinates of data points
 % Cy = 1 x n matrix with y coordinates of data points
 % Px = x-coordinates eval points
 % Py = y-coordinates eval points
 % threshDist: the threshold of the distances between points and the fitting line
 % dw = width wall 
  
%#function distance2curve 

% compute model
modelLeastSquares = polyfit(Cx,Cy,1);
mx=linspace(min(Cx),max(Cx),abs(max(Cx)-min(Cx))*10)';
my = modelLeastSquares(1)*mx + modelLeastSquares(2);

% compute perpendicular distance
curvexy=[mx my];
mapxy= [Px Py];
[~,distance,~] = distance2curve(curvexy,mapxy,'linear');

% compute number of inliers
inlierIdx = find(dw/2-threshDist<=abs(distance) & abs(distance)<=dw/2+threshDist);
inlierNum = length(inlierIdx);

% compute error
error=mean(abs(abs(distance)-dw/2));
mx=num2cell(mx);
my=num2cell(my);
end


