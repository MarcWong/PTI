img = imread('/Users/marcWong/Data/ProcessedData/001A/coloredimg/layer78/17.jpg');
roi = imread('/Users/marcWong/Data/ProcessedData/001A/roi/roi13.jpg');
%Gx = load('/Users/marcWong/Data/ProcessedData/001A/t17Gx.txt');
%Gy = load('/Users/marcWong/Data/ProcessedData/001A/t17Gy.txt');
%Gz = load('/Users/marcWong/Data/ProcessedData/001A/t17Gz.txt');
%Gx = reshape(Gx,256,256,114);
%Gy = reshape(Gy,256,256,114);
%Gz = reshape(Gz,256,256,114);
r = sqrt(double(img(:,:,1)).^2+double(img(:,:,2)).^2 + double(img(:,:,3)).^2) .* 0.008;
rxy = sqrt(double(img(:,:,1)).^2+double(img(:,:,2)).^2).*0.008;
for x = 1:2:256
    for y = 1:2:256
        if (rxy(x,y) < 0.3)
            rxy(x,y) = 0.3;
            lamda(x,y) = 0.3;
        else
            lamda(x,y) = 0.3;
        end
    end
end
%window=fspecial('gaussian',[4 4],16);
%bg = imfilter(img,window);
%bg = imresize(img);
figure;
%imshow(img);
for x = 1:2:256
    for y = 1:2:256
        if roi(x,y)==255
            PlotEllipse(y,x,rxy(x,y),lamda(x,y),atan(double(img(x,y,1))/double(img(x,y,2))),double(img(x,y,1))/255,double(img(x,y,2))/255,double(img(x,y,3))/255);
        end
    end
end
%saveas(gcf,'myfig.jpg');