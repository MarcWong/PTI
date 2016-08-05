width = 256;
height = 256;
acquisitionTime = load('/Users/marcWong/Data/ProcessedData/001A/acquisitionTime.txt');
acquisitionTime = reshape(acquisitionTime,20,40);
acquisitionTime = double(acquisitionTime);
Cdt = double([40,256,256,114]);
z = 78;
layer = ceil(z ./ 5.908); 
startt = 1;
endt = 39;
%%
C = load(['/Users/marcWong/Data/ProcessedData/001A/concentration/time' num2str(startt) '.dat']);
for t =startt : endt
    C1 = load(['/Users/marcWong/Data/ProcessedData/001A/concentration/time' num2str(t+1) '.dat']);
    C = reshape(C,256,256,114);
    C = double(C);
    C1 = reshape(C1,256,256,114);
    C1 = double(C1);
    
    %computation of derivC
    for x = 1:width
        for y = 1:height
            Cdt(t,x,y,z) = (C1(x,y,z) - C(x,y,z))/(acquisitionTime(layer,t+1)-acquisitionTime(layer,t));
        end
    end
    display(t);
    C = C1;
end

window=fspecial('gaussian',[3 1],12);
Cdt(:,x,y,:) = imfilter(Cdt(:,x,y,:),window);
display('t gaussian filter finished');

for t=startt : endt
    tmp = Cdt(t,:,:,z);
    img = zeros([256 256]);
    for i = 1:256
        for j =1:256
            img(i,j) = tmp(1,i,j);
        end
    end
    maxCdt = max(max(max(Cdt(t,:,:,z))));
    minCdt = min(min(min(Cdt(t,:,:,z))));
    img = (img - minCdt)./(maxCdt-minCdt);
    display(t);
    imshow(img,'InitialMagnification','fit');
    pause(0.25);
end