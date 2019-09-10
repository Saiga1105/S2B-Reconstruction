function [Cx,Cy] = F_sortpoints(Cx,Cy)
%F_SORTPOINTS Summary of this function goes here
%   Detailed explanation goes here

data=[Cx Cy];
dist = pdist2(data,data);

N = size(data,1);
result = NaN(1,N);
result(1) = 1; % first point is first row in data matrix

for ii=2:N
    dist(:,result(ii-1)) = Inf;
    [~, closest_idx] = min(dist(result(ii-1),:));
    result(ii) = closest_idx;
end
Cxtemp= zeros(length(Cx),1);
Cytemp= zeros(length(Cy),1);

for i=1:length(Cx)
    Cxtemp(i)=Cx(result(i));
    Cytemp(i)=Cy(result(i));
end
Cx=Cxtemp;
Cy=Cytemp;
    
end

