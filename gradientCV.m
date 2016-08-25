%constants
%patient   timePoint   layer      Sum       TE   width   height  zmax
%001A        40              20        800        54    256       256    114
%002A        50              24        1200      32    128       128    159
%004B        90              24        2160       23    128       128   127
%028B        60              20        1200       42    128       128   133
%033A        60              20       1200       46    128       128    128

%acquisitionTime = load('/Users/marcWong/Data/ProcessedData/001A/acquisitionTime.txt');
%acquisitionTime = reshape(acquisitionTime,layer,timePoint);
%acquisitionTime = double(acquisitionTime);

%path = '/Users/marcWong/Data/ProcessedData/001A/';
%path = '/Users/marcWong/Data/ProcessedData/002A/';
path = '/Users/marcWong/Data/ProcessedData/004B/';
%path = '/Users/marcWong/Data/ProcessedData/028B/';
%path = '/Users/marcWong/Data/ProcessedData/033A/';

%threshold = 1e-5;
width=128;
height=128;
timePoint=90;
zmax=127;
layer = 24;
%kx = 2.8;
%ky = 2.8;
%kz = 1.1;

%CdtUpperBound = 0.515;
%CdtLowerBound=0.455;
%%
%Cdt = load('/Users/marcWong/Data/ProcessedData/001A/cdt/Cdt78.dat');
%Cdt = reshape(Cdt,30,256,256);
%001A
%002A 4 8 12 15 17 19
%roi = imread([path 'roi/roi  .jpg']);
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
%001A
%002A z=20, 47 75 95 110 123
%z = 123;
for t = 1:timePoint
    %from Concentration to gradient
    %{
    C = load([path 'concentration/time' num2str(t) '.dat']);
    C = reshape(C,width,height,zmax);
    C = double(C);
    for k = 1: zmax
        window=fspecial('gaussian',[4 4],4);
        C(:,:,k) = imfilter(C(:,:,k),window);
    end
    %display('gaussian filter finished');
    [Gx,Gy,Gz] = gradient(C);
    %fid=fopen([path 't' num2str(t) 'Gx.bin'],'wb');
    %fwrite(fid,Gx,'float');
    %fid=fopen([path 't' num2str(t) 'Gy.bin'],'wb');
    %fwrite(fid,Gy,'float');
    %fid=fopen([path 't' num2str(t) 'Gz.bin'],'wb');
    %fwrite(fid,Gz,'float');
    dlmwrite([path 't' num2str(t) 'Gx.txt'], Gx, 'delimiter', ' ','precision',10);
    dlmwrite([path 't' num2str(t) 'Gy.txt'], Gy, 'delimiter', ' ','precision',10);
    dlmwrite([path 't' num2str(t) 'Gz.txt'], Gz, 'delimiter', ' ','precision',10);
    %}
    
    Gx=load([path 't' num2str(t) 'Gx.txt'],'delimiter',' ');
    Gy=load([path 't' num2str(t) 'Gy.txt'],'delimiter',' ');
    Gz=load([path 't' num2str(t) 'Gz.txt'],'delimiter',' ');
    
    %load([path 't' num2str(t) 'Gx.mat'],'Gx');
    %load([path 't' num2str(t) 'Gy.mat'],'Gy');
    %load([path 't' num2str(t) 'Gz.mat'],'Gz');
    
    Gx = reshape(Gx,width,height,zmax);
    Gy = reshape(Gy,width,height,zmax);
    Gz = reshape(Gz,width,height,zmax);
    
    for z = 1:zmax
        l = round(z / zmax * layer);
        if l < 1
            l=1;
        elseif l > layer
            l=layer;
        end
        roi = imread([path 'roi/roi' num2str(l) '.jpg']);
        for i = 1:width
            for j = 1:height
                if roi(i,j)<128
                    Gx(i,j,z)=0;
                    Gy(i,j,z)=0;
                    Gz(i,j,z)=0;
                end
            end
        end
    %{
        %loading of Cdt
        tCdt = zeros([256 256]);
        for i = 1:width
            for j =1:height
                tCdt(i,j) = Cdt(t,i,j);
            end
        end
        maxCdt = max(max(tCdt(:,:)));
        minCdt = min(min(tCdt(:,:)));
        tCdt = (tCdt - minCdt)./(maxCdt-minCdt);
    %}
        %{
        maxGx = max(max(max(Gx(:,:,z))));
        maxGy = max(max(max(Gy(:,:,z))));
        maxGz = max(max(max(Gz(:,:,z))));
        img = zeros([width height 3]);
        img(:,:,1) = Gx(:,:,z) / maxGx * 255. *kx;
        img(:,:,2) = Gy(:,:,z) / maxGy * 255. *ky;
        img(:,:,3) = Gz(:,:,z) / maxGz * 255. *kz;
        for x = 1:width
            for y = 1:height
                if roi(x,y) <128
                    img(x,y,1) = 0;
                    img(x,y,2) = 0;
                    img(x,y,3) = 0;
                end
            end
        end
        img = uint8(img);
        %imshow(img,'InitialMagnification','fit');
        imwrite(img,[path '/coloredimg/layer' num2str(z) '/' num2str(t) '.jpg']);
        %}
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
    end
    save([path 't' num2str(t) 'Gx.mat'],'Gx');
    save([path 't' num2str(t) 'Gy.mat'],'Gy');
    save([path 't' num2str(t) 'Gz.mat'],'Gz');
end