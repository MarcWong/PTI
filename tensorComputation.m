
%acquisitionTime = load('/Users/marcWong/Data/ProcessedData/001A/acquisitionTime.txt');
%acquisitionTime = reshape(acquisitionTime,layer,timePoint);
%acquisitionTime = double(acquisitionTime);
%%
%for t = 1 : 40
for t = 6:30
threshold = 1e-5;
    C = load(['/Users/marcWong/Data/ProcessedData/001A/concentration/time' num2str(t) '.dat']);
    C1 = load(['/Users/marcWong/Data/ProcessedData/001A/concentration/time' num2str(t+1) '.dat']);
    C = reshape(C,256,256,114);
    C = double(C);
    for x = 1:256
        window=fspecial('gaussian',[8 5],4);
        C(x,:,:) = imfilter(C(x,:,:),window);
    end
    display('x filter finished');
    for y = 1 : 256
        window=fspecial('gaussian',[8 5],4);
        C(:,y,:) = imfilter(C(:,y,:),window);
    end
    display('y filter finished');
    for z = 1: 114
        window=fspecial('gaussian',[8 8],4);
        C(:,:,z) = imfilter(C(:,:,z),window);
    end
    display('z filter finished');
    dlmwrite('/Users/marcWong/Data/ProcessedData/001A/concentrationFiltered.txt', C, 'delimiter', ' ','precision',10);
    [Gx,Gy,Gz] = gradient(C);
    [r,theta,phi] = rec2sphere(Gx,Gy,Gz);
    z = 50;
    h = zeros(256,256);
    s = zeros(256,256);
    v = zeros(256,256);
    
    maxR = max(max((r(:,:,80))));
    
    ps = 0.5;
    phi_R = 0;
    
    for i =1:256
        for j = 1:256
            if(r(i,j,80)>threshold)
                h(i,j) = mod(2*(phi(i,j,80) - phi_R + 2*pi) ,2*pi);
                s(i,j) = sin(ps*theta(i,j,80))/sin(ps*pi/2);
                v(i,j) = 1;
            else
                continue;
            end
        end
    end
    
    img = zeros([256 256 3]);
    for i =1:256
        for j = 1:256
            img(i,j,1) = h(i,j);
            img(i,j,2) = s(i,j);
            img(i,j,3) = v(i,j);
        end
    end
    %compute hsv from sphere coordinate
    
    %convert hsv2rgb
    
    %save it in rgbimg
    img = hsv2rgb(img);
    imshow(img,'InitialMagnification','fit');
    pause(0.01);
    %visualization
    %{
    
        subplot(2,2,1);
        imshow(uint8(255.*C(:,:,z)),'InitialMagnification','fit');
        xlabel('Origin');
        subplot(2,2,2);
        imshow(uint8(255*2./max(max(Gx(:,:,z))).*Gx(:,:,z)),'InitialMagnification','fit');
        xlabel('Gz');
        subplot(2,2,3);
        imshow(uint8(255*2./max(max(Gy(:,:,z))).*Gy(:,:,z)),'InitialMagnification','fit');
        xlabel('Gy');
        subplot(2,2,4);
        imshow(uint8(255*1.5./max(max(Gz(:,:,z))).*Gz(:,:,z)),'InitialMagnification','fit');
        xlabel('Gz');
        pause(0.01);
    %}
end

%%
%computation of derivC
%{
%CderivT = double(layer,timePoint,width,height);
%for layer = 1:layer
 %   for t = 1:timePoint-1
 %       for x = 1:width
 %           for y = 1:height
 %           CderivT(layer,t,x,y) = (C(layer,t+1,x,y) - C(layer,t,x,y))/(acquisitionTime(layer,t+1)-acquisitionTime(layer,t+1));
 %           end
 %       end
 %   end
%end
%}