while 1
    z = input('input layer number:');
    if z == 0
        break;
    end
   %%
    %path of original img for 001A
    path = '/Users/marcWong/Data/PerfusionSource/separation001A/';
    %path of computed img
    %path = '/Users/marcWong/Data/ProcessedData/001A/';
    
    %%
    %path of original img for 002A
    %path = '/Users/marcWong/Data/PerfusionSource/separation002A/';
    %path of computed img
    %path = '/Users/marcWong/Data/ProcessedData/002A/';
    %%
    path=strcat(path,num2str(z));
    path=strcat(path,'/');
    listing = dir([path '*.jpg']);
    fileSum = length(listing); 
    
    for listNum=1:fileSum
        img = imread(strcat(path,listing(listNum).name));
        
        %
        %imshow(img,'InitialMagnification','fit');
        
        %
        %S = sum(sum(img)) / fileSum / 100;
        %display(num2str(S));
        %{
        subplot(2,3,1);
        imshow(img,'InitialMagnification','fit');
        title('origin');
        
        BW_sobel = edge(img,'sobel');
        BW_prewitt = edge(img,'prewitt');
        BW_roberts = edge(img,'roberts');
        BW_laplace = edge(img,'log');
        BW_canny = edge(img,'canny');
        
        subplot(2,3,2);
        imshow(BW_sobel,'InitialMagnification','fit');
        title('sobel');
        
        subplot(2,3,3);
        imshow(BW_prewitt,'InitialMagnification','fit');
        title('prewitt');
        
        subplot(2,3,4);
        imshow(BW_roberts,'InitialMagnification','fit');
        title('roberts');
        
        subplot(2,3,5);
        imshow(BW_laplace,'InitialMagnification','fit');
        title('log');
        
        subplot(2,3,6);
        imshow(BW_canny,'InitialMagnification','fit');
        title('canny');
        
        %
        %[Gx,Gy] = gradient(double(img));
        %G = sqrt(Gx.*Gx+Gy.*Gy);
        %G = 255 - G;
        
        %imshow(uint8(G),'InitialMagnification','fit');
        pause(0.15);
        %}
    end
end