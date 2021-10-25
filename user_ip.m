function [prop,motor,battery,esc,frame,FC,num_opt] = user_ip(prop_swc,prop_perf,motor_wc,motor_perf,battery_data,...
    esc_data,frame_data,FC_data)

prop_num = size(prop_swc,1);

for i = prop_num:-1:1  %Backwards for memory preallocation
    prop(i).size = prop_swc(i,1);  %Inches
    prop(i).mass = prop_swc(i,2);   %Grams
    prop(i).cost = prop_swc(i,3);
    prop(i).RPM = prop_perf{i}(:,1);  %Need to convert to rad/s
    prop(i).Ct = prop_perf{i}(:,2);
    prop(i).Cp = prop_perf{i}(:,3);
end

motor_num = size(motor_wc,1);

for i = motor_num:-1:1  
    motor(i).mass = motor_wc(i,1);  %grams
    motor(i).cost = motor_wc(i,2);
    
    motor(i).I50 = motor_perf(i,1);
    motor(i).V50 = motor_perf(i,2);
    motor(i).RPM50 = motor_perf(i,3);
    
    motor(i).I100 = motor_perf(i,4);
    motor(i).V100 = motor_perf(i,5);
    motor(i).RPM100 = motor_perf(i,6);
end


battery_num = size(battery_data,1);

for i = battery_num:-1:1  
    battery(i).mass = battery_data(i,1); %grams
    battery(i).cost = battery_data(i,2);
    battery(i).mAh = battery_data(i,3);  %mAh
    battery(i).Crate = battery_data(i,4);
    battery(i).Volt = battery_data(i,5);
end


esc_num = size(esc_data,1);

for i = esc_num:-1:1  
    esc(i).mass = esc_data(i,1);  %grams
    esc(i).cost = esc_data(i,2);
    esc(i).CR = esc_data(i,3);
    esc(i).maxV = esc_data(i,4);
end


frame_num = size(frame_data,1);

for i = frame_num:-1:1  
    frame(i).size = frame_data(i,1);  %Inches
    frame(i).mass = frame_data(i,2);   %Grams
    frame(i).cost = frame_data(i,3);
end

FC_num = size(FC_data,1);

for i = FC_num:-1:1  
    FC(i).mass = FC_data(i,1);  %Grams
    FC(i).cost = FC_data(i,2);
end

num_opt = [prop_num,motor_num,battery_num,esc_num,frame_num,FC_num];

