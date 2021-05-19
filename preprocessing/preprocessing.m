clc; clear all;
warning off;
dbImageFiles = dir('../../TestComponent/train/sketch2/diode/*.jpg');
for nImage = 1:length(dbImageFiles)
    fprintf('%d: %s \n', nImage, dbImageFiles(nImage).name);
    img = im2double(imread(['../../TestComponent/train/sketch2/diode/' dbImageFiles(nImage).name]));
    new_img = generateTrain(img);
    new_img = imdilate(new_img, ones(5,5));
    imwrite(new_img, sprintf('../../TestComponent/train/sketch2/diode2/%d.png', nImage));
end % nImage

