%acquisitionTime = load('/Users/marcWong/Data/ProcessedData/001A/acquisitionTime.txt');
%acquisitionTime = reshape(acquisitionTime,layer,timePoint);
%acquisitionTime = double(acquisitionTime);
threshold = 1e-5;
%CdtUpperBound = 0.515;
%CdtLowerBound=0.455;
%%
%Cdt = load('/Users/marcWong/Data/ProcessedData/001A/cdt/Cdt78.dat');
%Cdt = reshape(Cdt,30,256,256);
%roi = imread('/Users/marcWong/Data/ProcessedData/001A/roi/roicdt12.jpg');
%%
%initialization of roi
    %{
        for i = 1:256
            for j = 1:256
                if(tCdt(i,j)>CdtUpperBound || tCdt(i,j)<CdtLowerBound)
                    roi(i,j) = 255;
                else1
                    roi(i,j) = 0;
                end
            end
        end
        imshow(roi,'InitialMagnification','fit');
        imwrite(roi,['/Users/marcWong/Data/ProcessedData/001A/roi/roicdt' num2str(t) '.jpg']);
    %}
%%
for t = 1:30
    C = load(['/Users/marcWong/Data/ProcessedData/001A/concentration/time' num2str(t) '.dat']);
    C = reshape(C,256,256,114);
    C = double(C);
    for i = 1:256
        window=fspecial('gaussian',[4 2],4);
        C(i,:,:) = imfilter(C(i,:,:),window);
    end
    %display('x filter finished');
    for j = 1 : 256
        window=fspecial('gaussian',[4 2],4);
        C(:,j,:) = imfilter(C(:,j,:),window);
    end
    %display('y filter finished');
    for k = 1: 114
        window=fspecial('gaussian',[4 4],4);
        C(:,:,k) = imfilter(C(:,:,k),window);
    end
    %display('z filter finished');
    %dlmwrite('/Users/marcWong/Data/ProcessedData/001A/concentrationFiltered.txt', C, 'delimiter', ' ','precision',10);
    %{
    [Gx,Gy,Gz] = gradient(C);
    fid=fopen(['/Users/marcWong/Data/ProcessedData/001A/t' num2str(t) 'Gx.bin'],'wb');
    fwrite(fid,Gx,'float');
    fid=fopen(['/Users/marcWong/Data/ProcessedData/001A/t' num2str(t) 'Gy.bin'],'wb');
    fwrite(fid,Gy,'float');
    fid=fopen(['/Users/marcWong/Data/ProcessedData/001A/t' num2str(t) 'Gz.bin'],'wb');
    fwrite(fid,Gz,'float');
    %}
    %dlmwrite(['/Users/marcWong/Data/ProcessedData/001A/t' num2str(t) 'Gx.txt'], Gx, 'delimiter', ' ','precision',10);
    %dlmwrite(['/Users/marcWong/Data/ProcessedData/001A/t' num2str(t) 'Gy.txt'], Gy, 'delimiter', ' ','precision',10);
    %dlmwrite(['/Users/marcWong/Data/ProcessedData/001A/t' num2str(t) 'Gz.txt'], Gz, 'delimiter', ' ','precision',10);
    %for z = 6:6:114
    %{
        %loading of Cdt
        tCdt = zeros([256 256]);
        for i = 1:256
            for j =1:256
                tCdt(i,j) = Cdt(t,i,j);
            end
        end
        maxCdt = max(max(tCdt(:,:)));
        minCdt = min(min(tCdt(:,:)));
        tCdt = (tCdt - minCdt)./(maxCdt-minCdt);
    %}
        %maxGx = max(max(max(Gx(:,:,z))));
        %maxGy = max(max(max(Gy(:,:,z))));
        %maxGz = max(max(max(Gz(:,:,z))));
        %img = zeros([256 256 3]);
        %img(:,:,1) = Gx(:,:,z) / maxGx * 255. *5;
        %img(:,:,2) = Gy(:,:,z) / maxGy * 255. *5;
        %img(:,:,3) = Gz(:,:,z) / maxGz * 255.;
        %img = uint8(img);
        %imshow(img,'InitialMagnification','fit');
        %imwrite(img,['/Users/marcWong/Data/ProcessedData/001A/coloredimg/layer' num2str(z) '/' num2str(t) '.jpg']);
        
        %{
        HSV approach
        [r,theta,phi] = rec2sphere(Gx,Gy,Gz);
        h = zeros(256,256);
        s = zeros(256,256);
        v = zeros(256,256);
        maxR = max(max((r(:,:,78))));
    
        ps = 0.5;
        phi_R = 0;
        for i =1:256
            for j = 1:256
                if r(i,j,78)>threshold && roi(i,j)==255
                    %using rotational symmetry
                    h(i,j) = mod(2*(phi(i,j,78) - phi_R + 2*pi) ,2*pi);
                    s(i,j) = sin(ps*theta(i,j,78))/sin(ps*pi/2);
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
        img = uint8(img.*255);
        %imshow(img,'InitialMagnification','fit');
        imwrite(img,['/Users/marcWong/Data/ProcessedData/001A/coloredimg/layer78/' num2str(t) '.jpg']);
        %}
    
        %pause(0.01);
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
    %end
end