img = imread('/Users/marcWong/Data/ProcessedData/001A/coloredimg/layer78/17.jpg');
roi = imread('/Users/marcWong/Data/ProcessedData/001A/roi/roi12.jpg');
Gx = load('/Users/marcWong/Data/ProcessedData/001A/t17Gx.txt');
Gy = load('/Users/marcWong/Data/ProcessedData/001A/t17Gy.txt');
Gz = load('/Users/marcWong/Data/ProcessedData/001A/t17Gz.txt');
Gx = reshape(Gx,256,256,114);
Gy = reshape(Gy,256,256,114);
Gz = reshape(Gz,256,256,114);
C = 4;
rmax = sqrt(Gx(:,:,78).^2+Gy(:,:,78).^2) .* 600;
rmin = C./rmax;
for x = 1:256
    for y = 1:256
        if rmax(x,y)<rmin(x,y)
            rmin(x,y) = rmax(x,y);
        end
    end
end
window=fspecial('gaussian',[4 4],16);
bg = imfilter(img,window);
bg = imresize(bg,4);
imshow(bg,'InitialMagnification','fit');
for x = 80:1:120
    for y = 80:1:120 
        if roi(x,y)==255
            PlotEllipse(4*x,4*y,rmax(x,y),rmin(x,y),atan(y/x),img(x,y,1),img(x,y,2),img(x,y,3));
        end
    end
end
saveas(gcf,'myfig.jpg');