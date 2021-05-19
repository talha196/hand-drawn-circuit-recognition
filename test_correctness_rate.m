clc; clear all;
warning off;

img_num = 30;
component_num = 3;
dir_name = cell(1,3);
cell{1} = 'amplifier';
cell{2} = 'diode';
cell{3} = 'resistor';
for nComponent = 1:component_num
    correct_num = 0;
    for nImage = 1:img_num
        component = sketchrec(sprintf('../TestComponent/test/%s/%s_test_rename/%d.jpg', ...
            cell{nComponent},cell{nComponent},nImage));
        if component == nComponent
            correct_num = correct_num + 1;
        end
    end
    correct_rate = double(correct_num) / img_num;
    fprintf('component is %s', cell{nComponent});
    display(correct_rate);
end



