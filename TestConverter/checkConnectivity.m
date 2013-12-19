function [ dcdcConnectivity ] = checkConnectivity()
%CHECKCONNECTIVITY Summary of this function goes here
%   Detailed explanation goes here
    k7001_preset_AMIS5MP();
    hp6051_set_current(3, 15, 1);
    tti_set(2,10,6);
    tti_out(2,1);
    k7001_select_channel(7,CHN_Vout);
    pause(WAITSCAN);
    dcdcConnectivity = k2000_get_volt(1);
    k7001_disconnect(7);
    tti_out(2, 0);
end