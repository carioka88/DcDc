% --- Executes on button press in efficiencyButton.
function [vInitMin vInitMax iInitMax v2Min v4Min eff2 eff4] = featuresTest(effM, voutScan, voutZero, imonZero, voutM, avgVin, avgIload_1, avgIload_2)
% hObject    handle to efficiencyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    vInitMin = voutScan*0.97;
    vInitMax = voutScan*1.03;
    iInitMax = imonZero*1000 + 10;
    %v2Min = 0.01;
    %v4Min = 0.02;
    
    v2Min = (voutZero - voutM(avgIload_1,avgVin))*1.3; % +30%
    v4Min = (voutZero - voutM(avgIload_2,avgVin))*1.3; % +30%
    eff2 = (effM(avgVin,avgIload_1)*100) - 3; % -3% 
    eff4 = (effM(avgVin,avgIload_2)*100) - 3; % -3%

