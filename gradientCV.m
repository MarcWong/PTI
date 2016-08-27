%constants
%patient   timePoint   layer      Sum       TE   width   height  zmax  tmax
%001A        40              20        800        54    256       256    115     18
%002A        50              24        1200      32    128       128    139     20
%004B        90              24        2160       23    128       128   139      21
%028B        60              20        1200       42    128       128   115      13
%033A        60              20       1200       46    128       128    115     17
%001A 16
%002A 17
%004B 20
%028B 11
%033A 14

%acquisitionTime = load('/Users/marcWong/Data/ProcessedData/001A/acquisitionTime.txt');
%acquisitionTime = reshape(acquisitionTime,layer,timePoint);
%acquisitionTime = double(acquisitionTime);

%path = '/Users/marcWong/Data/ProcessedData/001A/';
%path = '/Users/marcWong/Data/ProcessedData/002A/';
%path = '/Users/marcWong/Data/ProcessedData/004B/';
%path = '/Users/marcWong/Data/ProcessedData/028B/';
path = '/Users/marcWong/Data/ProcessedData/033A/';

%threshold = 1e-5;
width=128;
height=128;
%CdtUpperBound = 0.515;
%CdtLowerBound=0.455;
%%
%Cdt = load('/Users/marcWong/Data/ProcessedData/001A/cdt/Cdt78.dat');
%Cdt = reshape(Cdt,30,256,256);
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
%001A z = 24 42 56 76 90  102
%002A z=20, 47 75 95 110 123
%004B z = 30 48 60 84 102 108
%028B z = 24 57 72 84 102 111
%033A z = 24 42 60 84 96 102
z=96;
roi = imread([path 'roi/roi' num2str(round(z/6)) '.jpg']);
for t = 14:14
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
    
    %Gx=load([path 't' num2str(t) 'Gx.txt'],'delimiter',' ');
    %Gy=load([path 't' num2str(t) 'Gy.txt'],'delimiter',' ');
    %Gz=load([path 't' num2str(t) 'Gz.txt'],'delimiter',' ');
    
    load([path 't' num2str(t) 'Gx.mat'],'Gx');
    load([path 't' num2str(t) 'Gy.mat'],'Gy');
    load([path 't' num2str(t) 'Gz.mat'],'Gz');
    
    Gx0= Gx;
    Gy0= Gy;
    Gz0= Gz;
    
    load([path 't' num2str(t+1) 'Gx.mat'],'Gx');
    load([path 't' num2str(t+1) 'Gy.mat'],'Gy');
    load([path 't' num2str(t+1) 'Gz.mat'],'Gz');
    
    Gx1= Gx;
    Gy1= Gy;
    Gz1= Gz;
    
    k = 1;
    GG0 = sqrt(Gx0(:,:,:).*Gx0(:,:,:)+Gy0(:,:,:).*Gy0(:,:,:)+Gz0(:,:,:).*Gz0(:,:,:));
    GG1 = sqrt(Gx1(:,:,:).*Gx1(:,:,:)+Gy1(:,:,:).*Gy1(:,:,:)+Gz1(:,:,:).*Gz1(:,:,:));
    
    
    img = (GG1(:,:,z) - GG0(:,:,z));
    img = img ./k  .* 255.;
    for i = 1:width
        for j = 1:height
            if roi(i,j) < 200
                img(i,j) = 0;
            end
        end
    end
   
    img = uint8(img);
    %imshow(img,'InitialMagnification','fit');
    imagesc(img);
    colormap(jet);
    %imwrite(img, [path '/coloredimg/layer' num2str(z) '/newMagnPositive' num2str(t) '.jpg']);
    
    img = abs(GG1(:,:,z) - GG0(:,:,z));
    img = img ./k  .* 255.;
    for i = 1:width
        for j = 1:height
            if roi(i,j) < 200
                img(i,j) = 0;
            end
        end
    end
    img = uint8(img);
    %imshow(img,'InitialMagnification','fit');
    imagesc(img);
    %imwrite(img, [path '/coloredimg/layer' num2str(z) '/newMagnSum' num2str(t) '.jpg']);
    %xx = Gx1(:,:,:) - Gx0(:,:,:);
    %yy = Gy1(:,:,:) - Gy0(:,:,:);
    %zz = Gz1(:,:,:) - Gz0(:,:,:);

    GxNew = Gx1 .* (GG1-GG0);
    GyNew = Gy1 .* (GG1-GG0);
    GzNew = Gz1 .* (GG1-GG0);
    %save([path 'Newt' num2str(t) 'Gx.mat'],'Gx');
    %save([path 'Newt' num2str(t) 'Gy.mat'],'Gy');
    %save([path 'Newt' num2str(t) 'Gz.mat'],'Gz');
    
    
    img1 = zeros([width height 3]);
    img1(:,:,1) = GxNew(:,:,z);
    img1(:,:,2) = GyNew(:,:,z);
    img1(:,:,3) = GzNew(:,:,z);
    maxGx = max(max(GxNew(:,:,z)));
    maxGy = max(max(GyNew(:,:,z)));
    maxGz = max(max(GzNew(:,:,z)));
    
    img1(:,:,1) = img1(:,:,1) / maxGx * 16 * 255.;
    img1(:,:,2) = img1(:,:,2) / maxGy * 16 * 255.;
    img1(:,:,3) = img1(:,:,3) / maxGz * 8 * 255.;
    
    for i = 1:width
        for j = 1:height
            if roi(i,j) < 200
                img1(i,j,:) = 0;
            end
        end
    end
    %img1 = 255 - img1;
    %}
    img1 = uint8(img1);
    %imshow(img1,'InitialMagnification','fit');
    imwrite(img1,['/Users/marcWong/Data/figure/033A' num2str(z) '.jpg']);
    
    
    
    %{
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
    %}

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
        sumGx = sum(sum(Gx(:,:,z)));
        miuGx = sumGx / 500;
        sumGy = sum(sum(Gy(:,:,z)));
        miuGy = sumGy / 500;
        sumGz = sum(sum(Gz(:,:,z)));
        miuGz = sumGz / 300;
        %}
    %{
        maxGx = max(max(Gx(:,:,z)));
        maxGy = max(max(Gy(:,:,z)));
        maxGz = max(max(Gz(:,:,z)));
        img(:,:,1) = Gx(:,:,z) / maxGx * 255. *kx;
        img(:,:,2) = Gy(:,:,z) / maxGy * 255. *ky;
        img(:,:,3) = Gz(:,:,z) / maxGz * 255. *kz;
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
    %{
%}
end