function [ dcdcVoutZero ImonZero ] = checkVoutZero()
    k7001_preset_AMIS5MP();
    hp6051_set_current(3, 15, 0);
    tti_set(2, 10, 6);  % set vin 
    tti_out(2, 1);          % turn on
    pause(1);
    [~, ImonZero] = tti_get(2); % read Vin and Iin at LVPS

    k7001_select_channel(7, CHN_Vout);
    pause(WAITSCAN);
    dcdcVoutZero = k2000_get_volt(1);
    k7001_disconnect(7);

    tti_out(2, 0);          % turn off
    pause(1);
end

