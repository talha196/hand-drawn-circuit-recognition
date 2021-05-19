%load database images.
clear;clc;close all;
db = {'amplifier','diode','resistor','capacitor','power'};
numofdbimage = length(db);
image_std = cell(1,numofdbimage);

for idx = 1:numofdbimage
    image_std{idx} = im2double(imread(['../template/' db{idx} '_std.png']));
    figure;imshow(image_std{idx});
end

save ('stdelem.mat', 'image_std');

db_conn = {'amplifier','diode','resistor'};
numofconn = length(db_conn);
numperconn = 55;
img_conn = cell(numofconn, numperconn);

for idx = 1:numofconn
    elem = list_dir(['../TestComponent/train/' db_conn{idx}], '.png');
    for imageidx = 1:numperconn
        img_elem = imread(elem{imageidx});
        img_conn{idx,imageidx} = img_elem;
    end
end

nd = 16;
fourier_d = cell(numofconn, numperconn);
for idx = 1:numofconn
    for imageidx =1:numperconn
        imgbw = img_conn{idx,imageidx};
        [B,L] = bwboundaries(imgbw,'noholes');
        s=[];
        for k = 1:length(B)
            boundary = B{k};
            s =[s;boundary];
        end
        z=frdescp(s);
        zmag = abs(z);
        %Normalize using 1st element
        zmag = zmag/zmag(2);
        zsel = zmag(3:nd);
        fourier_d{idx,imageidx} = zsel;     
    end
end

TrainingSet = [];
GroupTrain = [];
for idx = 1:numofconn
    for imageidx =1:numperconn
        TrainingSet = [TrainingSet;fourier_d{idx,imageidx}'];
        GroupTrain = [GroupTrain;idx];
    end
end

models = multisvmtrain(TrainingSet,GroupTrain);
save ('svmmodels.mat','models');

