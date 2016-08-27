function [r,theta,phi] = rec2sphere(Gx,Gy,Gz)
r = zeros([256,256,115]);
theta = zeros([256,256,115]);
phi = zeros([256,256,115]);
r(:,:,:) = sqrt(Gx(:,:,:).^2+Gy(:,:,:).^2+Gz(:,:,:).^2);
theta(:,:,:) = acos(Gz(:,:,:)./r(:,:,:));
phi(:,:,:) = atan(Gy(:,:,:)./Gx(:,:,:));
end