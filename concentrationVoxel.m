%function T = tensorComputation(layer)
%%
%constants
timePoint = 40;
width = 256;
height = 256;
layer = 20;
threshold = 10;
%acquisitionTime = load('/Users/marcWong/Data/ProcessedData/001A/acquisitionTime.txt');
%acquisitionTime = reshape(acquisitionTime,layer,timePoint);
%acquisitionTime = double(acquisitionTime);
C = load('/Users/marcWong/Data/ProcessedData/001A/concentration.txt');
C = reshape(C,layer,timePoint,width,height);
C = double(C);
%dcmPath = '/Users/marcWong/Data/PerfusionSource/001A/PERFUSION/';
%listing = dir([dcmPath '*.dcm']);
%fileSum = length(listing); 
%mask = imread('/Users/marcWong/Data/ProcessedData/001A/roi/roi.jpg');
outputPath = '/Users/marcWong/Data/ProcessedData/001A/tensor/';
%%
%read acquisition time
%{
acquisitionTime = double([20 40]);
m = zeros([20 1]);
for imgNum=1:fileSum
    %read dicom info header
    info = dicominfo([dcmpath listing(imgNum).name]);
    %read the input img and convert in into double
    switch info.ImagePositionPatient(3)
        %for 001A
        case -33.671030050502
            m(1) = m(1) +1;
            acquisitionTime(1,m(1)) =  str2double(info.AcquisitionTime);
        case -27.69087219833
            m(2) = m(2) +1;
            acquisitionTime(2,m(2)) =  str2double(info.AcquisitionTime);
        case -21.710713392482
            m(3) = m(3) +1;
            acquisitionTime(3,m(3)) =  str2double(info.AcquisitionTime);
        case -15.730555063472
            m(4) = m(4) +1;
            acquisitionTime(4,m(4)) =  str2double(info.AcquisitionTime);
        case -9.7503967344624
            m(5) = m(5) +1;
            acquisitionTime(5,m(5)) =  str2double(info.AcquisitionTime);
        case -3.7702379286152
            m(6) = m(6) +1;
            acquisitionTime(6,m(6)) =  str2double(info.AcquisitionTime);
        case 2.2099199235577
            m(7) = m(7) +1;
            acquisitionTime(7,m(7)) =  str2double(info.AcquisitionTime);
        case 8.1900787294048
            m(8) = m(8) +1;
            acquisitionTime(8,m(8)) =  str2double(info.AcquisitionTime);
        case 14.170236581578
            m(9) = m(9) +1;
            acquisitionTime(9,m(9)) = str2double(info.AcquisitionTime);
        case 20.150396341099
            m(10) = m(10) +1;
            acquisitionTime(10,m(10)) =  str2double(info.AcquisitionTime);
        case 26.130556100621
            m(11) = m(11) +1;
            acquisitionTime(11,m(11)) =  str2double(info.AcquisitionTime);
        case 32.110712045445
            m(12) = m(12) +1;
            acquisitionTime(12,m(12)) =  str2double(info.AcquisitionTime);
        case 38.090871804966
            m(13) = m(13) +1;
            acquisitionTime(13,m(13)) =  str2double(info.AcquisitionTime);
        case 44.071031564488
            m(14) = m(14) +1;
            acquisitionTime(14,m(14)) =  str2double(info.AcquisitionTime);
        case 50.051187509312
            m(15) = m(15) +1;
            acquisitionTime(15,m(15)) =  str2double(info.AcquisitionTime);
        case 56.031343454136
            m(16) = m(16) +1;
            acquisitionTime(16,m(16)) =  str2double(info.AcquisitionTime);
        case 62.011507028355
            m(17) = m(17) +1;
            acquisitionTime(17,m(17)) =  str2double(info.AcquisitionTime);
        case 67.991662973179
            m(18) = m(18) +1;
            acquisitionTime(18,m(18)) =  str2double(info.AcquisitionTime);
        case 73.971818918003
            m(19) = m(19) +1;
            acquisitionTime(19,m(19)) =  str2double(info.AcquisitionTime);
        case 79.951982492222
            m(20) = m(20) +1;
            acquisitionTime(20,m(20)) =  str2double(info.AcquisitionTime);
        otherwise
            display(info.ImagePositionPatient(3));
    end
    if mod(imgNum,40) == 0
        display([num2str(imgNum) ' img']);
    end
end
%}
%%
%write acquisitionTime
%{
fid = fopen([actimepath actimefilename],'w');
for i=1:20
    for j=1:40
        fprintf(fid, '%.6f ', acquisitionTime(i,j));
    end
end
%}
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
%%
%calculation of max and min
%{
Max = 0;
Min = 1000;
for z = 1:layer
    for t = 1:timePoint
        for x = 1:width
            for y =1:height
                if(C(z,t,x,y) < Min)
                    Min = C(z,t,x,y);
                end
                if(C(z,t,x,y) > Max)
                    Max = C(z,t,x,y);
                end
            end
        end
    end
end
%}
%%
%C to voxel, computation of tensor
zCoordinate = [-33.671030050502,-27.69087219833,-21.710713392482,-15.730555063472...
    -9.7503967344624,-3.7702379286152,2.2099199235577,8.1900787294048...
    14.170236581578,20.150396341099,26.130556100621,32.110712045445...
    38.090871804966,44.071031564488,50.051187509312,56.031343454136...
    62.011507028355,67.991662973179,73.971818918003,79.951982492222];
zCoordinate = zCoordinate - zCoordinate(1);
cVoxel = zeros([width height int8(zCoordinate(20))]);
%set layer 1 to z = 0
for t = 1:timePoint
    for i =1:int8(zCoordinate(20))
        l = 1;
        while i > int8(zCoordinate(l))
            l = l + 1;
        end
        mSum = zCoordinate(l) - zCoordinate(l-1);
        %mSum = m1 + m2
        m1 = zCoordinate(l) - double(i);
        m2 = -zCoordinate(l-1) +double(i);
        for x = 1 : width
            for y = 1 : height
                cVoxel(x,y,i) = (C(l-1,t,x,y) * m1 + C(l,t,x,y) * m2)/mSum;
            end
        end
    end
    dlmwrite([outputPath 'time' num2str(t) '.dat'],cVoxel, 'delimiter', ' ');
end
%%
%filtering and normalization
%{
for z = 1:20
    mask = imread(['/Users/marcWong/Data/ProcessedData/001A/roi/roi' num2str(z) '.jpg']);
    for t = 1:timePoint
        for x = 1:width
            for y =1:height
                C(z,t,x,y) = double(mask(x,y)/255) .* (C(z,t,x,y)-Min) / (Max-Min);
            end
        end
    end
end
%}
%%
%rewrite concerntration
%dlmwrite('/Users/marcWong/Data/ProcessedData/001A/concentration.txt', C, 'delimiter', ' ','precision',10);
%%
%demostration of C
%{
while 1
    z = input('input layer number:');
    while z > 20 || z < 0
        z = input('wrong parameter, input layer number between 1-20, 0 is quit:');
    end
    if z==0
        break;
    end
    for t = 1:timePoint
        img = uint8([width height]);
        for x = 1:width
            for y =1:height
                img(x,y) = 255 .* (C(z,t,x,y)-Min) / (Max-Min);
            end
        end
        imshow(img,'InitialMagnification','fit');
        pause(0.15);
    end
end
%}