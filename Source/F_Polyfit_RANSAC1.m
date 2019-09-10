function [mx, my,inlierNum, error] = F_Polyfit_RANSAC1(Cx,Cy,Px,Py,k,threshDist,dw,n)
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

 [Cx,Cy] = F_sortpoints(Cx,Cy);
 data= [Cx Cy];
 PxPy=[Px Py];
 totalerror=zeros(k,1);
 totalilrNum=zeros(k,1);
 sampleIdx=zeros(n,2,k);
  
 for i = 1:k
     % 1. conditioned sample n controlpoints from [Cx Cy]

     sampleIdx(1,:,i)=data(randi([1 ceil(length(Cx)/n)],1),:);
     for j = 2:n-1
         sampleIdx(j,:,i)=data(randi([ ceil(length(Cx)/n)*(j-1)-5  ceil(length(Cx)/n)*(j)+5],1),:);
     end
     sampleIdx(n,:,i)=data(randi([ceil(length(Cx)/n)*(n-1) length(Cx)],1),:);

     error=zeros(n-1,1);
     inlrNum=zeros(n-1,1);
     for m=1:n-1
         % compute model
        modelLeastSquares = polyfit(sampleIdx(m:m+1,1,i),sampleIdx(m:m+1,2,i),1);
        mx=sampleIdx(m:m+1,1,i);
        my = modelLeastSquares(1)*mx + modelLeastSquares(2);
    
        % compute perpendicular distance
        curvexy=[mx my];
        mapxy=PxPy(ceil(length(Cx)/(n-1)*(m-1))+1: ceil(length(Cx)/(n-1)*(m)),:);
        [~,distance,~] = distance2curve(curvexy,mapxy,'linear');
        error(m)=mean(abs(abs(distance)-dw/2));

        % compute number of inliers
        inlierIdx = find(dw/2-threshDist<=abs(distance) & abs(distance)<=dw/2+threshDist);
        inlrNum(m) = length(inlierIdx);
     end
     totalerror(i)=mean(error);
     totalilrNum(i)=sum(inlrNum);
    
 end
score=totalilrNum./totalerror;
[~,index]=max(score);
inlierNum=totalilrNum(index);
error = totalerror(index);

     
mx=  sampleIdx(:,1,index);
my= sampleIdx(:,2,index);
     mx=num2cell(mx);
my=num2cell(my);
 
end

