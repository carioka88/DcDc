% --- Executes on button press in efficiencyButton.
function [msgLog voutOK effOK iinOK dropOK] = efficiency(name, model,effM, voutM, voutTested, voutValue, avgVIN, avgILOAD_1, avgILOAD_2)
% hObject    handle to efficiencyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global connection;
global imonZERO;
global voutZERO;
msgLog = [];
voutOK = 0;
effOK = 0;
dropOK = 0;
controlOK = 0;
iinOK = 0;
% %[effM, voutM] = getEfficiency(handles);
% voutValue = get(handles.voutPEdit, 'String');
% voutTested = get(handles.voutTEdit, 'String');

try
    action = ['SELECT V_INIT_MIN, V_INIT_MAX, I_INIT_MAX, V_2_MIN, V_4_MIN, EFF2, EFF4 FROM EFFICIENCY_DCDC WHERE MODEL =''' char(model) ''' AND VOUT=''' mat2str(voutValue) ''' '];
    cursor = exec(connection, action);
    cursor = fetch(cursor);
    
    %Vout tested and real Vout
    if(voutZERO == -1)
        msgLog = [msgLog, 'No data of Vout at 0A.'];
    else
        if(abs(cursor.Data{1}) <= abs(voutZERO) && abs(voutZERO) <= abs(cursor.Data{2}))
            msgLog = [msgLog, 'Correct, the vout is correct'];
            voutOK = 1;
        else
            msgLog = [msgLog, 'Error, the vout is not the expected'];
        end
        
        %%%Calculate drop
        %use point 4, because Vin = 10 is the point 4
        if(abs(voutZERO) - abs(voutM(avgVIN,avgILOAD_1)) <= abs(cursor.Data{4}))
            msgLog = [msgLog, 'Correct, the drop at 2A'];
            dropOK = 1;
        else
            msgLog = [msgLog, 'Error, the drop at 2A'];
        end

        if(abs(voutZERO) - abs(voutM(avgVIN,avgILOAD_2)) <= abs(cursor.Data{5}))
            msgLog = [msgLog, 'Correct, the drop at 4A'];
            dropOK = 1;
        else
            msgLog = [msgLog, 'Error, the drop at 4A'];
        end
    end
    
    if(imonZERO == -1)
        msgLog = [msgLog, 'No data of Imon at 0A.'];
    else
        if(imonZERO <= cursor.Data{3})
            msgLog = [msgLog, 'Correct, has the correct Iin, less than 50mA.'];    
        else
            msgLog = [msgLog, 'Error, the Standby Rating with 4A.'];
        end
        iinOK = imonZERO;
    end
    
    if(abs((effM(avgVIN,avgILOAD_1)*100)) >= abs(cursor.Data{6}))
        msgLog = [msgLog, 'Correct, the efficiency with 2A is >= than 0.7'];
        effOK = 1;
    else
        msgLog = [msgLog, 'Error, the efficiency with 2A is less than 0.7'];
    end

    if(abs((effM(avgVIN,avgILOAD_2)*100)) >= abs(cursor.Data{7}))
        msgLog = [msgLog, 'Correct, the efficiency with 4A is >= 0.63'];
        effOK = 1;
    else
        msgLog = [msgLog, 'Error, the efficiency at 4A is less than 0.63'];
    end
catch
    msgLog = [msgLog, 'Not enough data'];
end

