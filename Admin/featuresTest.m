% --- Executes on button press in efficiencyButton.
function [vInitMin vInitMax iInitMax v2Min v4Min eff2 eff4] = featuresTest(effM, voutScan, voutZero, imonZero, voutM)
% hObject    handle to efficiencyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    vInitMin = voutScan*0.97;
    vInitMax = voutScan*1.03;
    iInitMax = imonZero*1000 + 10;
    %v2Min = 0.01;
    %v4Min = 0.02;
    v2Min = (voutZero - voutM(2,4))*1.3; % +30%
    v4Min = (voutZero - voutM(4,4))*1.3; % +30%
    eff2 = (effM(4,2)*100) - 3; % -3% 
    eff4 = (effM(4,4)*100) - 3; % -3%

