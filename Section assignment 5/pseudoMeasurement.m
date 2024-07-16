function [x_p, y_p] = pseudoMeasurement(Y, s1, s2)

x_1 = s1(1);
y_1 = s1(2);
x_2 = s2(1);
y_2 = s2(2);

phi_1 = Y(1,:);
phi_2 = Y(2,:);

x_p =  (x_1.*tan(phi_1) - x_2.*tan(phi_2) - y_1 + y_2)./(tan(phi_1) - tan(phi_2));
y_p = (x_1.*tan(phi_1).*tan(phi_2) - x_2*tan(phi_1).*tan(phi_2) - y_1.*tan(phi_2) + y_2*tan(phi_1))./(tan(phi_1) - tan(phi_2));