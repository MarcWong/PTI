y = zeros([40 1]);
z = 78;
for t =1 : 40
    C = load(['/Users/marcWong/Data/ProcessedData/001A/concentration/time' num2str(t) '.dat']);
    C = reshape(C,256,256,114);
    y(t) = C(113,160,z);
end
x = (1:1:40)';
ylabel('Concentration');
xlabel('Time');
%y = y - 0.3;
scatter(x,y);