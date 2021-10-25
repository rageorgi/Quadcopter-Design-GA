function f = objfunc(x,prop,motor,battery,esc,frame,FC,consts)


prop = prop(x(1)); motor = motor(x(2)); battery = battery(x(3));
esc = esc(x(4)); frame = frame(x(5)); FC = FC(x(6));

%% Constraint 1 (T>2W)

weight_tot = ((4*prop.mass) + (4*motor.mass) + battery.mass + (4*esc.mass) + frame.mass + FC.mass)*(9.8/1000);  %Newton

n_full = motor.RPM100; 
[~,idx]=min(abs(n_full-prop.RPM));
Ct_full = prop.Ct(idx);
n_full = (2*pi*n_full)/60;  %convert to rad/s

D = prop.size*0.0254; %convert to m

g(1) =( (2*weight_tot)/(4*Ct_full*1.225*(n_full^2)*(D^4)) ) - 1  ;  % Constraint 1


%% Constraint 2 (Figure of Merit)

M = consts(1); 
n_half = motor.RPM50;
[~,idx2]=min(abs(n_half-prop.RPM));
Ct_half = prop.Ct(idx2);
Cp_half = prop.Cp(idx2);
n_half = (2*pi*n_half)/60; %convert to rad/s

T_half = Ct_half*1.225*(n_half^2)*(D^4);
d_area = pi*((D/2)^2);
P_out = (T_half^1.5)/sqrt(2*1.225*d_area);
P_in = Cp_half*1.225*(n_half^3)*(D^5);
FOM = P_out/P_in;

g(2)= (M/FOM) -1;   % Constraint 2

%% Constraints 3-7
g(3) = ( (4*motor.I100)/(battery.mAh*battery.Crate) ) -1 ;
g(4) =  (motor.I100/esc.CR) - 1;

T_min = consts(2);
flight_time = (battery.mAh*60)/(4*motor.I50*1000);  %Minutes at hover
g(5) =  (T_min/flight_time) - 1;

g(6) = (motor.V100/battery.Volt) - 1;
g(7) =  (motor.V100/esc.maxV) - 1;

%% Constraints 8,9 (Frame size)
coeff = [consts(3), consts(4)];
f_estimate = polyval(coeff,prop.size);
fsize_mm = frame.size*25.4;
g(8)= (fsize_mm/(f_estimate+25))-1;
g(9) = ((f_estimate-25)/fsize_mm)-1;
%%
cost_tot = ((4*prop.cost) + (4*motor.cost) + battery.cost + (4*esc.cost) + frame.cost + FC.cost);
cost_min = consts(5); weight_min = consts(6);

if cost_min == 0 || weight_min == 0
    phi_1 = cost_tot; 
    phi_2 = weight_tot;
else 
    phi_1 = (cost_tot - cost_min)/abs(cost_min);
    phi_2 = (weight_tot - weight_min)/abs(weight_min);
end

a1 = consts(7); a2 = consts(8); 

phi = (a1*phi_1)+(a2*phi_2);

P = 0.0;    % initialize penalty function

for i = 1:size(g)
    if g(i)<=0
        P = P+0;
    else 
        P = P + (1+g(i));
    end
end 

rp=10;
f= phi+(rp*P);   % penalty function used is exterior step linear


end