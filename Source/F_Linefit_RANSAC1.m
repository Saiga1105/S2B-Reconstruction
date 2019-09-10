function [mx, my,inlierNum, error,xy ] = F_Linefit_RANSAC1( Cx,Cy,Px,Py,k,threshDist,dw,n )
%F_Arcfit_RANSAC Computes best fit 2-point line through RANSAC
 % Cx = 1 x n matrix with x coordinates of data points
 % Cy = 1 x n matrix with y coordinates of data points
 % Px = x-coordinates eval points
 % Py = y-coordinates eval points
 % k: the number of iterations
 % threshDist: the threshold of the distances between points and the fitting line
 % omega: the threshold of the number of inliers 
 % dw = width wall
  
%#function distance2curve 

pts= [Cx Cy]';
sampleNum = 2;
ptNum = size(pts,2);
thInlr = round(omega*ptNum);
inlrNum = zeros(1,k);
theta1 = zeros(1,k);
rho1 = zeros(1,k);
for p = 1:k
	% 1. fit using 2 random points
    
    sampleIdx1 = randi([1 ceil(ptNum/2*1)-1],1);
	sampleIdx2 = randi([ceil(ptNum/2*1) ceil(ptNum/2*2)],1);
    sampleIdx= [sampleIdx1 sampleIdx2 ];
    
	%sampleIdx = F_randIndex(ptNum,sampleNum);
	ptSample = pts(:,sampleIdx);
	d = ptSample(:,2)-ptSample(:,1);
	d = d/norm(d); % direction vector of the line
	
	% 2. count the inliers, if more than thInlr, refit; else iterate
	n = [-d(2),d(1)]; % unit normal vector of the line
	dist1 = n*(pts-repmat(ptSample(:,1),1,ptNum));
	inlier1 = find(abs(dist1) < threshDist);	
    
    inlrNum(p) = length(inlier1);
	if length(inlier1) < thInlr, continue; end
	ev = pca(pts(:,inlier1)');
	d1 = ev(:,1);
	theta1(p) = -atan2(d1(2),d1(1)); % save the coefs
	rho1(p) = [-d1(2),d1(1)]*mean(pts(:,inlier1),2);
end
% 3. choose the coef with the most inliers
[~,idx] = max(inlrNum);
theta = theta1(idx);
rho = rho1(idx);

k1 = -tan(theta);
b1 = rho/cos(theta);
coefficients= [k1,b1];

mx(1,:)=min(Cx);
mx(2,:)=max(Cx);
my = polyval(coefficients , mx);

inlierNum=length(inlier1);
% my(1,:)=(rho - mx(1)*cos(theta))/sin(theta);
%my(2,:)=(rho - mx(2)*cos(theta))/sin(theta);
mx=num2cell(mx);
my=num2cell(my);
end


