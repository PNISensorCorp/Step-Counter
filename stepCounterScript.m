% Function to process a matlab data file and run it through the walking
% algorithm
clear all;close all

addpath('Data')

% choose and open data file
dataBaseDir = 'Data/';
[FileName,PathName] = uigetfile([dataBaseDir '*.mat'],'Choose Sentral Log File');
disp(FileName)
load([PathName FileName])

resultData = data_rec.dataSimRec.data_result_ay;

timeAy = resultData(:,1); % in seconds
accelAy = resultData(:,5:7);
listValues = zeros(size(timeAy));
j = 1;
listValues(j) = 1;
% remove repeated samples
for i = 2:length(listValues)
    if all(accelAy(i,:) == accelAy(i-1,:))
        
    else
        listValues(j) = i;
        j = j + 1;
    end
end

listValues = listValues(1:(j-1));
time = timeAy(listValues)*1000; % scale to milliseconds
acal = accelAy(listValues,:);% scaled in g's
aR = sqrt(acal(:,1).^2 + acal(:,2).^2 + acal(:,3).^2); %accel radius in g's

walkStruct = stepCounter_struct_init;
walkStruct.LIthrW = single(1.05); % change important threshold if needed

for k = 1:length(time)
    % run with accel data
    walkStruct = walkAlg3(walkStruct,acal(k,:),[0 0 0],time(k),1);
    
    % run with accel radius
%     walkStruct = walkAlg3(walkStruct,aR(k,:),0,time(k),1); 
end

disp('Total number of steps detected')
disp(walkStruct.HLI)

figure;plot(acal);title('accel data')



figure;plot(aR);title('accel radius')