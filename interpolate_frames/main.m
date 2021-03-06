img1 = rgb2gray(im2double(imread('../start.jpeg')));
img2 = rgb2gray(im2double(imread('../end.jpeg')));

%img1=imread('IMG_0730.jpeg');
%img2=imread('IMG_0731.jpeg');

%{
img1 = zeros(400,400);
img2 = zeros(400,400);
img1(50:100,50:100) = 1;
img2(70:120,70:120) = 1;
%}

imshow(img1)
frames = interpolate_frames_OF(4,img1,img2);

%{
opticFlow = opticalFlowLK();

randsquare = zeros(50,50);
for i=1:50
    for j=1:50
        randsquare(i,j) = rand;
    end
end

for i=0:30:100

    frame = zeros(400,400);
    frame(51 + i:100 + i,51 + i:100 + i) = randsquare;
    flow = estimateFlow(opticFlow,frame); 

    imshow(frame) 
    hold on
    plot(flow,'DecimationFactor',[5 5],'ScaleFactor',10)
    hold off 
end
%}


