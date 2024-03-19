frames = 251641; %number of frames in video recording
b = []; %placeholder variable for center positions
c = []; %placeholder variable for radii measurements
Angle = []; %placeholder variable for angle measurements
Counter = 1; %indexing counter throughout the for loop
strFile = 'C:\Users\shoan\Desktop\'; %file directory
imageFile = '2019-10-25-112825-'; %common name associated with images
for i = 1:30:frames %a 30 frame interval was used due to irrelevant changes from one frame to the next
    a = imread(sprintf('%s%s%d.jpg', strFile, imageFile, i)); %extracting pertinent information from the image frame
    [centers,radii] = imfindcircles(a,[10 50], 'ObjectPolarity','bright', 'Sensitivity',0.8); %built-in MATLAB function used to detect round features
    imshow(a)
    h = viscircles(centers,radii); %built-in function used to highlight round features detected
    for j = 1:2
        for k = 1:2
            b(Counter,k) = centers(j,k); %storing x and y coordinates of centers of round features; with two features to detect, there are two columns of data
            c(Counter,k) = radii(k); %storing radiis of detected round features to filter out any radiis differing from the norm
        end
        Counter = Counter + 1;
    end
    Count = i %visual counter for progress of the for loop
end

%% Decoupling Positions

X_Position_1 = zeros(size(b,1)/2,1); %placeholder variable for x coordinates of the centers of the first detected round feature
X_Position_2 = zeros(size(b,1)/2,1); %placeholder variable for x coordinates of the centers of the second detected round feature
Y_Position_1 = zeros(size(b,1)/2,1); %placeholder variable for y coordinates of the centers of the first detected round feature
Y_Position_2 = zeros(size(b,1)/2,1); %placeholder variable for x coordinates of the centers of the second detected round feature

for l = 1:size(b,1)        
    if b(l,1) < 1000
        X_Position_1(l) = b(l,1); %extracting the x coordinates of the first detected round feature
        Y_Position_1(l) = b(l,2); %extracting the y coordinates of the first detected round feature
    else
        X_Position_2(l) = b(l,1); %extracting the x coordinates of the second detected round feature
        Y_Position_2(l) = b(l,2); %extracting the y coordinates of the second detected round feature
    end
end

X_Position_1 = X_Position_1(find(X_Position_1>0)); %filtering out any detected features outside the range of the expected round features
X_Position_2 = X_Position_2(find(X_Position_2>0));
Y_Position_1 = Y_Position_1(find(Y_Position_1>0));
Y_Position_2 = Y_Position_2(find(Y_Position_2>0));

%% Angle Calculation
for m = 1:length(X_Position_1) %using the x and y coordinates to calculate the angle (in degrees) between the round features with trigonometry
    if Y_Position_2(m) - Y_Position_1(m) < 0
        Center_Distance(m) = sqrt((X_Position_2(m) - X_Position_1(m))^2 + (Y_Position_2(m) - Y_Position_1(m))^2);
        X_Distance(m) = X_Position_2(m) - X_Position_1(m);
        Angle(m) = asin(X_Distance(m)/Center_Distance(m));
        Angle_Degrees(m) = (Angle*180)/pi();
    else
        Center_Distance(m) = sqrt((X_Position_2(m) - X_Position_1(m))^2 + (Y_Position_2(m) - Y_Position_1(m))^2);
        Y_Distance(m) = Y_Position_2(m) - Y_Position_1(m);
        Angle(m) = asin(Y_Distance(m)/Center_Distance(m));
        Angle_Degrees(m) = (Angle(m)*180)/pi() + 90;
    end
end

%% Plot
Time = (1:length(Angle_Degrees))/60;
plot(Time, Angle_Degrees)