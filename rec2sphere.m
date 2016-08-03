function [r,theta,phi] = rec2sphere(Gx,Gy,Gz)
r = zeros([256,256,114]);
theta = zeros([256,256,114]);
phi = zeros([256,256,114]);
for x = 1: 256
    for y = 1:256
        for z = 1:114
            r(x,y,z) = sqrt(Gx(x,y,z)^2+Gy(x,y,z)^2+Gz(x,y,z)^2);
            theta(x,y,z) = acos(Gz(x,y,z)/r(x,y,z));
            phi(x,y,z) = atan(Gy(x,y,z)/Gx(x,y,z));
        end
    end
end
end