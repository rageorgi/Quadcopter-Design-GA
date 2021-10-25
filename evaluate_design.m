function [f] = evaluate_design(x,obj,prop_db,motor_db,battery_db,esc_db,frame_db,FC_db)

for i = 1:size(x,2)
    
    prop = prop_db(x(1,i)); motor = motor_db(x(2,i)); battery = battery_db(x(3,i));
    esc = esc_db(x(4,i)); frame = frame_db(x(5,i)); FC = FC_db(x(6,i));
    
    if obj == "cost" || obj == "Cost"
        f(i) = prop.cost + motor.cost + battery.cost + esc.cost + frame.cost + FC.cost;
    elseif obj == "perf" || obj == "Perf" || obj == "performance"
        
        n_full = motor.RPM100; 
        [~,idx]=min(abs(n_full-prop.RPM));
        Ct_full = prop.Ct(idx);
        n_full = (2*pi*n_full)/60;  %convert to rad/s
        D = prop.size*0.0254; %convert to m
        
        f(1,i) = (Ct_full*1.225*(n_full^2)*(D^4)); %Max Thrust
        
        n_half = motor.RPM50;
        [~,idx2]=min(abs(n_half-prop.RPM));
        Ct_half = prop.Ct(idx2);
        Cp_half = prop.Cp(idx2);
        n_half = n_half/60; %convert to rev/s

        T_half = Ct_half*1.225*(n_half^2)*(D^4);
        d_area = pi*((D/2)^2);
        P_out = (T_half^1.5)/sqrt(2*1.225*d_area);
        P_in = Cp_half*1.225*(n_half^3)*(D^5);
        
        f(2,i) = (P_out/P_in)*100;  % Figure of Merit
        
        f(3,i) = (battery.mAh*60)/(motor.I50*1000);  %Flight Time
        
    else
        f(i) = (prop.mass + motor.mass + battery.mass + esc.mass + frame.mass + FC.mass)*(9.8/1000);
    end
    
end

