%%
%initialization
path = '/Users/marcWong/Data/PerfusionSource/001A/PERFUSION/';
outputPath = '/Users/marcWong/Data/ProcessedData/001A/';
listing = dir([path '*.dcm']);
imgSum = length(listing); 
info = dicominfo(strcat(path,listing(1).name));
width = info.Width;
height = info.Height;
layer = 20;
m = zeros([layer 1]);
imgin = zeros([layer width height]);
imgout = uint8([width height]);
average = zeros([10 width height]);
maxValue = 777;
minValue = 0;
%%
%load average img
for i = 1:layer
    filename = strcat(num2str(i),'.jpg');
    average(i,:,:)=imread(strcat('/Users/marcWong/Data/average/',filename));
end
display('average images loaded');
%%
%substraction
for imgNum=1:imgSum
    %construct the filename
    info = dicominfo(strcat(path,listing(imgNum).name));
    %read the input img and convert in into double
    imgin = dicomread(info);
    
    %10 imgs produced for each time point, so saparate the imgs into 
    %10 classes
    switch info.ImagePositionPatient(3)
        case -33.671030050502
            tag=1;
        case -27.69087219833
            tag=2;
        case -21.710713392482
            tag=3;
        case -15.730555063472
            tag=4;
        case -9.7503967344624
            tag=5;
        case -3.7702379286152
            tag=6;
        case 2.2099199235577
            tag=7;
        case 8.1900787294048
            tag=8;
        case 14.170236581578
            tag=9;
        case 20.150396341099
            tag=10;
        case 26.130556100621
            tag=11;
        case 32.110712045445
            tag=12;
        case 38.090871804966
            tag=13;
        case 44.071031564488
            tag=14;
        case 50.051187509312
            tag=15;
        case 56.031343454136
            tag=16;
        case 62.011507028355
            tag=17;
        case 67.991662973179
            tag=18;
        case 73.971818918003
            tag=19;
        case 79.951982492222
            tag=20;
        otherwise
            display(info.ImagePositionPatient(3));
    end
    imgin = (double(imgin) - minValue) ./ (maxValue-minValue);
    imgin = uint8(imgin .* 255.);
    for i = 1:width
        for j = 1:height
            if(double(imgin(i,j)) - average(tag,i,j) >= 0)
                imgout(i,j) = double(imgin(i,j)) - average(tag,i,j);
            else
                imgout(i,j) = 0;
            end
        end
    end
    minValue2 = min(imgout(:));
    maxValue2 = max(imgout(:));
    imgout = (double(imgout) - double(minValue2)) ./ double(maxValue2-minValue2);
    imgout = uint8(imgout .* 255.);
    filename = strcat(num2str(imgNum),'.jpg');
    outputPathTmp=strcat(outputPath,num2str(tag));
    outputPathTmp=strcat(outputPathTmp,'/');
    imwrite(imgout,strcat(outputPathTmp,filename));
    if(mod(imgNum,80)==0)
        display(strcat(num2str(imgNum),' processed'));
    end
end