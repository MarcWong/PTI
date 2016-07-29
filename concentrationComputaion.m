%function C = concentrationComputation(layer)
%%
%constants
TE = 54;
k = 100;
layer = 20;
timePoint = 40;
width = 256;
height = 256;
C = double([20 timePoint width height]);
avgpath = '/Users/marcWong/Data/ProcessedData/001A/average/';
%%
voxel = load('/Users/marcWong/Data/ProcessedData/001A/voxel.txt');
voxel = reshape(voxel,layer,timePoint,width,height);
voxel = double(voxel);
for currentLayer = 1:20
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
dlmwrite('/Users/marcWong/Data/ProcessedData/001A/concentration.txt', C, 'delimiter', ' ','precision',10);