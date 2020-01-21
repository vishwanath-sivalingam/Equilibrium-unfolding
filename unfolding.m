cddata     = xlsread('unfolding_data1.xlsx');
tCELS      = cddata(:,1); % temperature in celsius 
cdmdeg     = cddata(:,2); % cd signal in millideg

figure(1) % temperature in celsius VS cd signal in millideg
plot(tCELS, cdmdeg,'o')
xlabel('Temp(C)')
ylabel('mdeg(theta)')

inv_tKELV  = 1./(tCELS + 273.15); % inverse temperature in Kelvin
FF         = -(cdmdeg-max(cdmdeg))/(max(cdmdeg)-min(cdmdeg)); %  fraction folded
Kapp       = FF./(1-FF); % folding constant
lnKapp     = log(Kapp);  % natural log of folding constant

% CRITICAL STEPS
lnK        = lnKapp(2:end-1);     % remove INFINITY values 
invT       = inv_tKELV(2:end-1);  % remove INFINITY values
vh         = polyfit(invT,lnK,1); % polyfit, degree 1
vh2        = polyval(vh,invT);    % generate new Y 

figure(2) % vant hoff plot
plot(invT, lnK, 'O', invT, vh2) 
xlabel('1/T (x 10^-3)')
ylabel('ln(K)')

% folding parameters
fprintf('tCELS  cdmdeg  inv_tKELV   FF  Kapp    lnKapp') 
PARAM = [tCELS cdmdeg inv_tKELV FF Kapp lnKapp]
Hvh        = -vh(1)*(1.987/1000)   % vant hoff enthalpy in kcal/mol
Svh        =  vh(2)*(1.987/1000)   % vant hoff entropy in kcal/mol
tm         = (Hvh/Svh)-273.15      % temperature in Celsius
dG         = (1.987*(tCELS+273.15)).*lnKapp % dG = 0 kcal/mol at tm
%
%
