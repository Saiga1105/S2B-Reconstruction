function [mx,my, inlierNum, error] = F_Arcfit_TLS(Cx,Cy,Px,Py,k,threshDist,dw,n)
%F_Arcfit_TLS Computes best fit 3-point arc through Total Least Squares
 % Cx = 1 x n matrix with x coordinates of data points
 % Cy = 1 x n matrix with y coordinates of data points
 % Px = x-coordinates eval points
 % Py = y-coordinates eval points
 % k: the number of iterations
 % threshDist: the threshold of the distances between points and the fitting line
 % dw = width wall 
 
%#function distance2curve 

% compute model
modelLeastSquares = polyfit(Cx,Cy,2);
mx=linspace(min(Cx),max(Cx),abs(max(Cx)-min(Cx))*10)';
my = modelLeastSquares(1)*mx.^2 + modelLeastSquares(2)*mx+ modelLeastSquares(3);

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

