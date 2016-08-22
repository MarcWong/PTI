%{
for z = 24:6:60
    Cdt = load(['/Users/marcWong/Data/ProcessedData/001A/cdt/Cdt' num2str(z) '.dat']);
    Cdt = reshape(Cdt,30,256,256);
    Cdt = double(Cdt);
    for t = 10:22
        tmp = Cdt(t,:,:);
        maxC = max(max(Cdt(t,:,:)));
        minC = min(min(Cdt(t,:,:)));
        tmp = (tmp - minC)./(maxC-minC);
        img = zeros([256 256]);
        tmp = tmp.*255;
        for i = 1 :256
            for j = 1 :256
                if tmp(1,i,j)>125 || tmp(1,i,j) < 115
                    img(i,j) = 255;
                end
            end
        end
        %imshow(uint8(img),'InitialMagnification','fit');
        imwrite(uint8(img),['/Users/marcWong/Data/ProcessedData/001A/roi/z' num2str(z) 't' num2str(t) '.jpg']);
    end
end
%}
%%

img = imread('/Users/marcWong/Data/z24t11.jpg');
for i = 1:256
    for j = 1:256
        if img(i,j) < 128
            img(i,j)=255;
        else
            img(i,j)=0;
        end
    end
end
imwrite(img,'/Users/marcWong/Data/z24t11.jpg');

img = imread('/Users/marcWong/Data/z30t14.jpg');
for i = 1:256
    for j = 1:256
        if img(i,j) <128
            img(i,j)=255;
        else
            img(i,j)=0;
        end
    end
end
imwrite(img,'/Users/marcWong/Data/z30t14.jpg');

img = imread('/Users/marcWong/Data/z42t14.jpg');
for i = 1:256
    for j = 1:256
        if img(i,j) <128
            img(i,j)=255;
        else
            img(i,j)=0;
        end
    end
end
imwrite(img,'/Users/marcWong/Data/z42t14.jpg');

img = imread('/Users/marcWong/Data/z48t21.jpg');
for i = 1:256
    for j = 1:256
        if img(i,j) <128
            img(i,j)=255;
        else
            img(i,j)=0;
        end
    end
end
imwrite(img,'/Users/marcWong/Data/z48t21.jpg');

img = imread('/Users/marcWong/Data/z60t18.jpg');
for i = 1:256
    for j = 1:256
        if img(i,j) <128
            img(i,j)=255;
        else
            img(i,j)=0;
        end
    end
end
imwrite(img,'/Users/marcWong/Data/z60t18.jpg');
