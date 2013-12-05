function [ Vmon Imon Vout Iout ] = reg_vin_AMIS5MP( Vin, Iload, handles )

% Voltage regulation curve
% Vin = vector containing the input voltages to apply
% Iload = vector containing the load currents to test
% Vout = matrix containing Vout for each Vin and Iin pairs
% This function assumes the use of teh following instruments:
% TTI power supply on GPIB address 2
% Agilent load on address 3
% Keithley DVM on address 1

% Load preset channels

k7001_preset_AMIS5MP();


% Scan accross load currents
%Iload = [0,1,2,3,4,5]
for i=1:numel(Iload)
    
    hp6051_set_current(3, 15, Iload(i));
    
    % Loop for different input voltages
    % current is limited to 6A
    
    for v = 1:numel(Vin)
       
        tti_set(2, Vin(v), 6);  % set vin 
        tti_out(2, 1);          % turn on
        pause(1);
        [Vmon(v,i), Imon(v, i)] = tti_get(2); % read Vin and Iin at LVPS

        % measure through DVM
        
        k7001_select_channel(7, CHN_Vin);
        pause(WAITSCAN);
        Vmon(v,i) = k2000_get_volt(1);
        
        k7001_select_channel(7, CHN_Vout);
        pause(WAITSCAN);
        Vout(v,i) = k2000_get_volt(1);
        
        k7001_disconnect(7);
        
        % Vout(v,i) = hp6051_get_volt(3);       % read load voltage
        Iout(v,i) = hp6051_get_current(3);    % read load current
        
        tti_out(2, 0);          % turn off
        pause(1);
    end
    if(numel(Iload) == 5)
        if(i == 1)
            set(handles.load1, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.load2, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.textporcent, 'String', '20%'); %Change to dark
        elseif (i==2)
            set(handles.load3, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.load4, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.textporcent, 'String', '40%'); %Change to dark
        elseif (i==3)
            set(handles.load5, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.load6, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.textporcent, 'String', '60%'); %Change to dark
        elseif (i==4)
            set(handles.load7, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.load8, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.textporcent, 'String', '80%'); %Change to dark
        elseif (i==5)
            set(handles.load9, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.load10, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.textporcent, 'String', '100%'); %Change to dark
        end
    elseif(numel(Iload) == 4)
        if(i == 1)
            set(handles.load1, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.load2, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.textporcent, 'String', '25%'); %Change to dark
        elseif (i==2)
            set(handles.load3, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.load4, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.load5, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.textporcent, 'String', '50%'); %Change to dark
        elseif (i==3)
            set(handles.load6, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.load7, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.textporcent, 'String', '75%'); %Change to dark
        elseif (i==4)
            set(handles.load8, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.load9, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.load10, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.textporcent, 'String', '100%'); %Change to dark
        end
    end

end

hp6051_set_current(3, 0, 0);   % Reset the load  

end


