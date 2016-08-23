%function C = concentrationComputation(layer)
%%
%constants
%patient   timePoint   layer      Sum       TE   width   height
%001A        40              20        800        54    256       256
%002A        50              24        1200      32    128       128
%004B        90              24        2160       23    128       128
%028B        60              20        1200       42    128       128
%033A        60              20       1200       46    128       128
k = 100;
timePoint = 60;
layer = 20;
TE = 42;
width = 128;
height = 128;
ypsl = 1e-5;
C = double([layer timePoint width height]);
%path = '/Users/marcWong/Data/ProcessedData/001A/';
%path = '/Users/marcWong/Data/ProcessedData/002A/';
%path = '/Users/marcWong/Data/ProcessedData/004B/';
%path = '/Users/marcWong/Data/ProcessedData/028B/';
path = '/Users/marcWong/Data/ProcessedData/033A/';
avgpath = [path 'average/'];

%%
%voxel = load('/Users/marcWong/Data/ProcessedData/001A/voxel.txt');
%voxel = load('/Users/marcWong/Data/ProcessedData/002A/voxel.txt');
%voxel = load('/Users/marcWong/Data/ProcessedData/004B/voxel.txt');
%voxel = load('/Users/marcWong/Data/ProcessedData/028B/voxel.txt');
voxel = load('/Users/marcWong/Data/ProcessedData/033A/voxel.txt');

voxel = reshape(voxel,layer,timePoint,width,height);
voxel = double(voxel);
for currentLayer = 1:layer
    filename = strcat(num2str(currentLayer),'.txt');
    S0 = load(strcat(avgpath,filename));
    S0 = double(S0);
    for currentTime = 1:timePoint
        for xIndex = 1:width
            for yIndex = 1:height
                if voxel(currentLayer,currentTime,xIndex,yIndex)/(S0(xIndex,yIndex)+ypsl) <= 0
                    C(currentLayer,currentTime,xIndex,yIndex) = 0;
                else
                    C(currentLayer,currentTime,xIndex,yIndex) = -k / TE *log(voxel(currentLayer,currentTime,xIndex,yIndex)/(S0(xIndex,yIndex)+ypsl));
                end
            end
        end
    end
    display([num2str(currentLayer) ' processed']);
end 
dlmwrite([path 'concentration.txt'], C, 'delimiter', ' ','precision',10);