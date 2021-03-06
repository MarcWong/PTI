%%
%initialization
%path = '/Users/marcWong/Data/PerfusionSource/001A/PERFUSION/';
%outputPath = '/Users/marcWong/Data/ProcessedData/001A/';
%path = '/Users/marcWong/Data/PerfusionSource/002A/ep2d_perf_p2/';
%outputPath = '/Users/marcWong/Data/ProcessedData/002A/';
%path = '/Users/marcWong/Data/PerfusionSource/003D/ep2d_Perf_Post/';
%outputPath = '/Users/marcWong/Data/ProcessedData/003D/';
%path = '/Users/marcWong/Data/PerfusionSource/004B/ep2d_Perfusion/';
%outputPath = '/Users/marcWong/Data/ProcessedData/004B/';
%path = '/Users/marcWong/Data/PerfusionSource/005C/ep2d_perf_p2/';
%outputPath = '/Users/marcWong/Data/ProcessedData/005C/';
%path = '/Users/marcWong/Data/PerfusionSource/028B/PERFUSION-THROM/';
%outputPath = '/Users/marcWong/Data/ProcessedData/028B/';
path = '/Users/marcWong/Data/PerfusionSource/033A/PERFUSION-DEDAS-ONO-THROM/';
outputPath = '/Users/marcWong/Data/ProcessedData/033A/';
listing = dir([path '*.dcm']);
fileSum = length(listing); 
info = dicominfo(strcat(path,listing(1).name));
width = info.Width;
height = info.Height;
%%%%
%patient   timePoint   layer      Sum
%001A        40              20        800
%002A        50              24        1200
%004B        90              24        2160
%028B        60              20        1200
%033A        60              20       1200
timePoint = 90;
layer = 24;
m = zeros([layer 1]);
imgin = zeros([layer width height]);
savedPic = uint16([width height]);
voxel = uint16([layer timePoint width height]);
%%
for imgNum=1:fileSum
    %read dicom info header
    info = dicominfo(strcat(path,listing(imgNum).name));
    %read the input img and convert in into double
    imgin = double(dicomread(info));
    
    %figure;
    %imshow(imgin,'DisplayRange',[]);

    %tag calibration by its z coordinate
    switch info.ImagePositionPatient(3)
        %for 001A
        %{
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
        %}
        %for 002A
        %{
        case -45.805432408434
            tag=1;
        case -38.912625401598
            tag=2;
        case -32.019810765367
            tag=3;
        case -25.127003758531
            tag=4;
        case -18.234192936998
            tag=5;
        case -11.341385930162
            tag=6;
        case -4.448575108629
            tag=7;
        case 2.4442338055556 
            tag=8;
        case 9.3370446270888
            tag=9;
        case 16.229853541273 
            tag=10;
        case 23.122662455458
            tag=11;
        case 30.015472084898
            tag=12;
        case 36.90828147592
            tag=13;
        case 43.80109110536
            tag=14; 
        case 50.693900019545
            tag=15;
        case 57.586708933729
            tag=16;
        case 64.479519755263
            tag=17;
        case 71.372328669447
            tag=18;
        case 78.26513949098
            tag=19;
        case 85.157946497816
            tag=20;
        case 92.05075731935
            tag=21;
        case 98.943568140883
            tag=22;
        case 105.83637514772
            tag=23;
        case 112.72918215455
            tag=24;
            %}
        %for 003D
        %{
        case -142.77616119385
            tag=1;
        case -136.77616119385
            tag=2;
        case -130.77616119385
            tag=3;
        case  -118.77616119385
            tag=4;
        case -112.77616119385
            tag=5;
        case -106.77616119385
            tag=6;
        case -100.77616119385
            tag=7;
        case -94.776161193848
            tag=8;
        case -88.776161193848
            tag=9;
        case -82.776161193848
            tag=10;
        case -76.776161193848
            tag=11;
        case  -70.77616071701
            tag=12;
        case -64.77616071701
            tag=13;
        case -52.776161193848
            tag=14; 
        case -46.776161193848
            tag=15;
        case -40.776161193848
            tag=16;
        case -34.776161193848
            tag=17;
        case -28.776161193848
            tag=18;
        case -22.776161193848
            tag=19;
        case -16.7762
            tag=20;
        case -10.776161193848
            tag=21;
        case -4.7761611938477
            tag=22;
        case 1.2238388061523
            tag=23;
        case 7.2238388061523
            tag=24;
        case 112.72918215455
            tag=25;
        case -124.7762
            tag=26;
            %}
        %for004B
        %{
       case 7.4746298148064
            tag=1;
        case 12.972806389513
            tag=2;
        case 18.47098296422
            tag=3;
        case 23.969159538927
            tag=4;
        case 29.467336113635
            tag=5;
        case 34.965512688342
            tag=6;
        case 40.463689263049
            tag=7;
        case 45.961865837756
            tag=8;
        case 51.460040505114
            tag=9;
        case 56.958218033495
            tag=10;
        case 62.456393654528
            tag=11;
        case 67.954570467654
            tag=12;
        case 73.452746803942
            tag=13;
        case 78.950923378649
            tag=14;
        case 84.449099953356
            tag=15;
        case 89.947276528063
            tag=16;
        case 95.44545310277
            tag=17;
        case 100.94362777013
            tag=18;
        case 106.44180434484
            tag=19;
        case 111.93998091954
            tag=20;
        case 117.43815749425
            tag=21;
        case 122.93633406896
            tag=22;
        case 128.43451064366
            tag=23;
        case 133.93268721837
            tag=24;
        %}
        %for 028B
        %{
        case -56.668674468994
            tag=1;
        case -49.668674468994
            tag=2;
        case -42.668674468994
            tag=3;
        case -35.668674468994
            tag=4;
        case -28.668674468994
            tag=5;
        case -21.668674468994
            tag=6;
        case -14.668674468994
            tag=7;
        case -7.6686744689941
            tag=8;
        case -0.6686747074127
            tag=9;
        case 6.3313255310059
            tag=10;
        case 13.331325531006
            tag=11;
        case 20.331325531006
            tag=12;
        case 27.331325531006
            tag=13;
        case 34.331325531006
            tag=14;
        case 41.331325531006
            tag=15;
        case 48.331325531006
            tag=16;
        case 55.331325531006
            tag=17;
        case 62.331325531006
            tag=18;
        case 69.331321716309
            tag=19;
        case 76.331321716309
            tag=20;
            %}
        %033A
        %{
        case  -9.6662878
            tag=1;
        case -2.9721541
            tag=2;
        case 3.7219778
            tag=3;
        case 10.416112
            tag=4;
        case 17.110245
            tag=5;
        case 23.804378
            tag=6;
        case 30.498512
            tag=7;
        case 37.192645
            tag=8;
        case 43.886778
            tag=9;
        case 50.580911
            tag=10;
        case 57.275044
            tag=11;
        case 63.969178
            tag=12;
        case 70.66331
            tag=13;
        case 77.357443
            tag=14;
        case 84.051577
            tag=15;
        case 90.745711
            tag=16;
        case 97.439845
            tag=17;
        case 104.13397
            tag=18;
        case 110.82811
            tag=19;
        case 117.52224
            tag=20;  
        %}
        otherwise
            display(info.ImagePositionPatient(3));
    end
    m(tag) = m(tag) + 1;
    for x = 1:width
        for y = 1:height
            voxel(tag,m(tag),x,y) = imgin(x,y);
        end
    end
    if(mod(imgNum,60)==0)
        display(strcat(num2str(imgNum),' processed'));
    end
end

dlmwrite([outputPath 'voxel.txt'], voxel, 'delimiter', ' ');