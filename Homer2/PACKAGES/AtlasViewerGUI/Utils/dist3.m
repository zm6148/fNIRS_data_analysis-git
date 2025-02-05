function d = dist3(p1,p2)

d=[];
if size(p1,1)==size(p2,1)
    for i=1:size(p1,1)
        d(i,1) = sqrt((p1(i,1)-p2(i,1))^2 + (p1(i,2)-p2(i,2))^2 + (p1(i,3)-p2(i,3))^2);
    end
elseif size(p1,1)==1
    for i=1:size(p2,1)
        d(i,1) = sqrt((p1(1)-p2(i,1))^2 + (p1(2)-p2(i,2))^2 + (p1(3)-p2(i,3))^2);
    end    
elseif size(p2,1)==1
    for i=1:size(p1,1)
        d(i,1) = sqrt((p2(1)-p1(i,1))^2 + (p2(2)-p1(i,2))^2 + (p2(3)-p1(i,3))^2);
    end
end