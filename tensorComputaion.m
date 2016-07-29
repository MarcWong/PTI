%function T = tensorComputation(layer)
%%
%constants
timePoint = 40;
width = 256;
height = 256;
layer = 20;

%acquisitionTime = load('/Users/marcWong/Data/ProcessedData/001A/acquisitionTime.txt');
%acquisitionTime = reshape(acquisitionTime,layer,timePoint);
%acquisitionTime = double(acquisitionTime);

C = load('/Users/marcWong/Data/ProcessedData/001A/concentration.txt');
C = reshape(C,layer,timePoint,width,height);
C = double(C);

%dcmPath = '/Users/marcWong/Data/PerfusionSource/001A/PERFUSION/';
%listing = dir([dcmPath '*.dcm']);
%fileSum = length(listing); 

outputPath = '/Users/marcWong/Data/ProcessedData/001A/tensor/';
%%
%compute acquisition time
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
%write acquisition time
%{
fid = fopen([actimepath actimefilename],'w');
for i=1:20
    for j=1:40
        fprintf(fid, '%.6f ', acquisitionTime(i,j));
    end
end
%}
%%
%conputation of derivC
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
Max = 0;
Min = 1000;
for z = 1:20
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


while 1
    z = input('input layer number:');
    if z == 0
        break;
    end
    for t = 1:timePoint
        img = double(zeros([width height]));
        for x = 1:width
            for y =1:height
                img(x,y) = 255. * (C(z,t,x,y)-Min) / (Max-Min);
            end
        end
        imshow(uint8(img),'InitialMagnification','fit');
        pause(0.2);
    end
end