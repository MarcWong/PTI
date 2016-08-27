%patient      layer   timePoint  width   height  
%001A        20             40           256       256   
%002A        24             50          128       128    
%004B        24              90          128      128
%028B        20              60          128       128   
%033A        20              60         128       128

path = '/Users/marcWong/Data/ProcessedData/001A/';
%path = '/Users/marcWong/Data/ProcessedData/002A/';
%path = '/Users/marcWong/Data/ProcessedData/004B/';
%path = '/Users/marcWong/Data/ProcessedData/028B/';
%path = '/Users/marcWong/Data/ProcessedData/033A/';

for t = 15:19
    load([path 'Newt' num2str(t) 'Gx.mat']);
    load([path 'Newt' num2str(t) 'Gy.mat']);
    load([path 'Newt' num2str(t) 'Gz.mat']);
    
end