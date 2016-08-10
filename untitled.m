z = 78;
for t = 1:39
    C = load(['/Users/marcWong/Data/ProcessedData/001A/concentration/time' num2str(t) '.dat']);
    C = reshape(C,256,256,114);
    C = double(C);
    img = C(:,:,z);
    maxC = max(max(max(C(:,:,z))));
    minC = min(min(min(C(:,:,z))));
    img = (img - minC)./(maxC-minC);
    imshow(img,'InitialMagnification','fit');
    imwrite(img,['/Users/marcWong/Data/ProcessedData/001A/img/' num2str(t) '.jpg']);
end