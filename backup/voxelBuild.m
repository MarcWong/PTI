   %%
    %path of original img for 001A
    path = '/Users/marcWong/Data/PerfusionSource/separation001A/';
    %path of computed img
    %path = '/Users/marcWong/Data/ProcessedData/001A/';
    outputpath = '/Users/marcWong/Data/ProcessedData/001A/voxel/';
    %%
    %path of original img for 002A
    %path = '/Users/marcWong/Data/PerfusionSource/separation002A/';
    %path of computed img
    %path = '/Users/marcWong/Data/ProcessedData/002A/';
    %%
    layer = 20;
    path1 = cell(layer,1);
    width = 256;
    height = 256;
    fileSum = 40;
    timePoint = 40;
    voxel = uint8([timePoint width height]);
    %%
for tag = 1:layer
    path1{tag}=strcat(path,num2str(tag));
    path1{tag}=strcat(path1{tag},'/');
end

for tag = 1:layer
    for listNum=1:fileSum
        listing = dir([path1{tag} '*.jpg']);
        img = imread(strcat(path1{tag},listing(listNum).name));
        %add a time info
        for j = 1:width
            for k = 1:height
                %voxel(tag,j,k) = j*k;
                voxel(listNum,j,k) = img(j,k);
            end
        end
    end
    filename = strcat(num2str(tag),'.txt');
    dlmwrite(strcat(outputpath,filename), voxel, 'delimiter', ' ');
    %
    %imshow(img,'InitialMagnification','fit');
        
    %
    %S = sum(sum(img)) / fileSum / 100;
    %display(num2str(S));
        
    %
    %[Gx,Gy] = gradient(double(img));
    %G = sqrt(Gx.*Gx+Gy.*Gy);
    %G = 255 - G;
    %imshow(uint8(G),'InitialMagnification','fit');
    %pause(1);
        
end