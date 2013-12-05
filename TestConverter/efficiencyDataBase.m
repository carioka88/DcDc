% --- Executes on button press in efficiencyButton.
function [msgLog voutOK effOK iinOK dropOK] = efficiency(name, model,effM, voutM, voutTested, voutValue)
% hObject    handle to efficiencyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global connection;
msgLog = [];
voutOK = 0;
effOK = 0;
dropOK = 0;
controlOK = 0;
% %[effM, voutM] = getEfficiency(handles);
% voutValue = get(handles.voutPEdit, 'String');
% voutTested = get(handles.voutTEdit, 'String');

try
    action = ['SELECT IMON, VOUT FROM DCDC_CONVERTER WHERE NAME =''' str2mat(name) ''' AND V_IN=''10'' AND I_LOAD=''0'''];
    cursor = exec(connection, action);
    cursor = fetch(cursor);
    imonZERO = cursor.Data{1};
    voutZERO = cursor.Data{2};
    
    action = ['SELECT V_INIT_MIN, V_INIT_MAX, I_INIT_MAX, V_2_MIN, V_4_MIN, EFF2, EFF4 FROM EFFICIENCY_DCDC WHERE MODEL =''' str2mat(model) ''' AND VOUT=''' voutValue ''' '];
    cursor = exec(connection, action);
    cursor = fetch(cursor);
    
    %Vout tested and real Vout
    if(cursor.Data{1} <= voutZERO && voutZERO <= cursor.Data{2})
        msgLog = [msgLog, 'Correct, the vout is correct'];
    else
        msgLog = [msgLog, 'Error, the vout is not the expected'];
        voutOK = 0;
    end
    
    if(imonZERO <= cursor.Data{3})
        msgLog = [msgLog, 'Correct, has the correct Iin, less than 50mA.'];    
    else
        msgLog = [msgLog, 'Error, the Standby Rating with 4A.'];
    end
    iinOK = imonZERO;
    
    if((effM(4,2)*100) >= cursor.Data{6})
        msgLog = [msgLog, 'Correct, the efficiency with 2A is >= than 0.7'];    
    else
        msgLog = [msgLog, 'Error, the efficiency with 2A is less than 0.7'];
        effOK = 0;
    end

    if((effM(4,4)*100) >= cursor.Data{7})
        msgLog = [msgLog, 'Correct, the efficiency with 4A is >= 0.63'];
    else
        msgLog = [msgLog, 'Error, the efficiency at 4A is less than 0.63'];
        effOK = 0;
    end
    
    %%%Calculate drop
    %use point 4, becaus Vin = 10 is the point 4
    if(voutZERO - voutM(4,2) <= cursor.Data{4})
        msgLog = [msgLog, 'Correct, the drop at 2A'];
    else
        msgLog = [msgLog, 'Error, the drop at 2A'];
        dropOK = 0;
    end
    
    if(voutZERO - voutM(4,4) <= cursor.Data{5})
        msgLog = [msgLog, 'Correct, the drop at 4A'];
    else
        msgLog = [msgLog, 'Error, the drop at 4A'];
        dropOK = 0;
    end
catch
    msgLog = [msgLog, 'Not enough data'];
end

