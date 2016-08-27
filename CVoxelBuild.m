%%
%constants
%patient   timePoint   layer      Sum       TE   width   height  zmax
%001A        40              20        800        54    256       256    115
%002A        50              24        1200      32    128       128    139
%004B        90              24        2160       23    128       128   127
%028B        60              20        1200       42    128       128   133
%033A        60              20       1200       46    128       128    128
timePoint = 60;
width = 128;
height = 128;
layer = 20;
threshold = 10;
%path = '/Users/marcWong/Data/ProcessedData/001A/';
%path = '/Users/marcWong/Data/ProcessedData/002A/';
%path = '/Users/marcWong/Data/ProcessedData/004B/';
%path = '/Users/marcWong/Data/ProcessedData/028B/';
path = '/Users/marcWong/Data/ProcessedData/033A/';

%acquisitionTime = load('/Users/marcWong/Data/ProcessedData/001A/acquisitionTime.txt');
%acquisitionTime = reshape(acquisitionTime,layer,timePoint);
%acquisitionTime = double(acquisitionTime);
C = load([path 'concentration.txt']);
C = reshape(C,layer,timePoint,width,height);
C = double(C);
%dcmPath = '/Users/marcWong/Data/PerfusionSource/001A/PERFUSION/';
%listing = dir([dcmPath '*.dcm']);
%fileSum = length(listing); 
%mask = imread('/Users/marcWong/Data/ProcessedData/001A/roi/roi.jpg');
outputPath = [path 'concentration/'];
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
 %           CderivT(layer,t,x,y) = (C(layer,t+1,x,y) - C(layer,t,x,y))/(acquisitionTime(layer,t+1)-acquisitionTime(layer,t));
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
%001A
%{
zCoordinate = [-33.671030050502,-27.69087219833,-21.710713392482,-15.730555063472...
    -9.7503967344624,-3.7702379286152,2.2099199235577,8.1900787294048...
    14.170236581578,20.150396341099,26.130556100621,32.110712045445...
    38.090871804966,44.071031564488,50.051187509312,56.031343454136...
    62.011507028355,67.991662973179,73.971818918003,79.951982492222];
%}
 
%002A
%{
zCoordinate = [-45.805432408434,-38.912625401598,-32.019810765367,-25.127003758531...
-18.234192936998,-11.341385930162,-4.448575108629,2.4442338055556,9.3370446270888...
16.229853541273,23.122662455458,30.015472084898,36.90828147592,43.80109110536...
50.693900019545,57.586708933729,64.479519755263,71.372328669447,78.26513949098...
85.157946497816,92.05075731935,98.943568140883,105.83637514772,112.72918215455];
%}

%004B
%{
zCoordinate = [7.4746298148064,12.972806389513,18.47098296422,23.969159538927...
29.467336113635,34.965512688342,40.463689263049,45.961865837756,51.460040505114...
56.958218033495,62.456393654528,67.954570467654,73.452746803942,78.950923378649...
84.449099953356,89.947276528063,95.44545310277,100.94362777013,106.44180434484...
111.93998091954,117.43815749425,122.93633406896,128.43451064366,133.93268721837];
%}

%028B
%{
zCoordinate = [-56.668674468994,-49.668674468994,-42.668674468994,-35.668674468994...
-28.668674468994,-21.668674468994,-14.668674468994,-7.6686744689941,-0.6686747074127...
6.3313255310059,13.331325531006,20.331325531006,27.331325531006,34.331325531006...
41.331325531006,48.331325531006,55.331325531006,62.331325531006,69.331321716309,76.331321716309];
%}

%033A
%{
zCoordinate = [-9.6662878,-2.9721541,3.7219778,10.416112,17.110245,23.804378,30.498512,37.192645,43.886778...
50.580911,57.275044,63.969178,70.66331,77.357443,84.051577,90.745711,97.439845,104.13397,110.82811,117.52224];
%}

zCoordinate = zCoordinate - zCoordinate(1);
cVoxel = zeros([width height ceil(zCoordinate(layer))]);
%set layer 1 to z = 0
for t = 1:timePoint
    for i =1:ceil(zCoordinate(layer))
        l = 1;
        while i > ceil(zCoordinate(l))
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
    while z > layer || z < 0
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