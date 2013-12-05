% --- Executes on button press in efficiencyButton.
function [msgLog voutOK effOK iinOK dropOK] = efficiency(model,effM, vmonM, voutTested, voutValue)
% hObject    handle to efficiencyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global voutZERO;
global imonZERO;
msgLog = [];
voutOK = 1;
effOK = 1;
dropOK = 1;
controlOK = 1;
% %[effM, vmonM] = getEfficiency(handles);
% voutValue = get(handles.voutPEdit, 'String');
% voutTested = get(handles.voutTEdit, 'String');
%Depend on the model!!
if(strcmp(model,'AMIS5MP'))
    %Vout tested and real Vout
    if((voutValue*0.97) <= voutZERO && voutZERO <= (voutValue*1.03))
        msgLog = [msgLog, 'Correct, the vout is correct'];
    else
        msgLog = [msgLog, 'Error, the vout is not the expected'];
        voutOK = 0;
    end
    
    if(imonZERO <= 0.05)
        msgLog = [msgLog, 'Correct, has the correct Iin, less than 50mA.'];    
    else
        msgLog = [msgLog, 'Error, the Standby Rating with 4A.'];
    end
    iinOK = imonZERO;
    %Comparing efficiency rating
    if(voutValue == 1.2)
        if(effM(4,2) >= 0.66)
            msgLog = [msgLog, 'Correct, the efficiency with 2A is >= than 0.7'];    
        else
            msgLog = [msgLog, 'Error, the efficiency with 2A is less than 0.7'];
            effOK = 0;
        end
        
        if(effM(4,4) >= 0.61)
            msgLog = [msgLog, 'Correct, the efficiency with 4A is >= 0.63'];
        else
            msgLog = [msgLog, 'Error, the efficiency at 4A is less than 0.63'];
            effOK = 0;
        end
    elseif(voutValue == 1.5)
        if(effM(4,2) >= 0.72)
            msgLog = [msgLog, 'Correct, the efficiency with 2A is >= than 0.7'];    
        else
            msgLog = [msgLog, 'Error, the efficiency with 2A is less than 0.7'];
            effOK = 0;
        end
        
        if(effM(4,4) >= 0.66)
            msgLog = [msgLog, 'Correct, the efficiency with 4A is >= 0.63'];
        else
            msgLog = [msgLog, 'Error, the efficiency at 4A is less than 0.63'];
            effOK = 0;
        end
    elseif(voutValue == 1.8)
    elseif(voutValue == 2.5)
        if(effM(4,2) >= 0.8)
            msgLog = [msgLog, 'Correct, the efficiency with 2A is >= than 0.8', '\n'];    
        else
            msgLog = [msgLog, 'Error, the efficiency with 2A is less than 0.8'];
            effOK = 0;
        end
        if(effM(4,4) >= 0.73)
            msgLog = [msgLog, 'Correct, the efficiency with 4A is >= 0.74'];
        else
            msgLog = [msgLog, 'Error, the efficiency at 4A is less than 0.74'];
            effOK = 0;
        end
    elseif(voutValue == 3.3)
        if(effM(4,2) >= 0.82)
            msgLog = [msgLog, 'Correct, the efficiency with 2A is >= than 0.7'];    
        else
            msgLog = [msgLog, 'Error, the efficiency with 2A is less than 0.7'];
            effOK = 0;
        end
        
        if(effM(4,4) >= 0.77)
            msgLog = [msgLog, 'Correct, the efficiency with 4A is >= 0.63'];
        else
            msgLog = [msgLog, 'Error, the efficiency at 4A is less than 0.63'];
            effOK = 0;
        end
    elseif(voutValue == 5)
        if(effM(4,2) >= 0.86)
            msgLog = [msgLog, 'Correct, the efficiency with 2A is >= than 0.86 '];    
        else
            msgLog = [msgLog, 'Error, the efficiency with 2A is less than 0.86'];
            effOK = 0;
        end
    end
    
    %%%Calculate drop
    %use point 4, becaus Vin = 10 is the point 4
    if(voutZERO - vmonM(4,2) <= 0.01)
        msgLog = [msgLog, 'Correct, the drop at 2A'];
    else
        msgLog = [msgLog, 'Error, the drop at 2A'];
        dropOK = 0;
    end
    
    if(voutZERO - vmonM(4,4) <= 0.02)
        msgLog = [msgLog, 'Correct, the drop at 4A'];
    else
        msgLog = [msgLog, 'Error, the drop at 4A'];
        dropOK = 0;
    end
    
elseif(strcmp(model, 'FEASTMP'))
    %Vout tested and real Vout
    if((voutTested*0.97) <= voutZERO && voutZERO <= (voutTested*1.03))
        msgLog = [msgLog, 'Correct, the vout is correct'];
    else
        msgLog = [msgLog, 'Error, the vout is not the expected'];
        voutOK = 0;
    end
    
    if(imonZERO <= 0.04)
        msgLog = [msgLog, 'Correct, has the correct Iin, less than 50mA.'];    
    else
        msgLog = [msgLog, 'Error, the Standby Rating with 4A.'];
    end
    iinOK = imonZERO;
    %Comparing efficiency rating
    if(voutValue == 1.2) 
        if(effM(4,2) >= 0.7)
            msgLog = [msgLog, 'Correct, the efficiency with 2A is >= than 0.7'];    
        else
            msgLog = [msgLog, 'Error, the efficiency with 2A is less than 0.7'];
            effOK = 0;
        end
        
        if(effM(4,4) >= 0.63)
            msgLog = [msgLog, 'Correct, the efficiency with 4A is >= 0.63'];
        else
            msgLog = [msgLog, 'Error, the efficiency at 4A is less than 0.63'];
            effOK = 0;
        end
    elseif(voutValue == 1.5)
        if(effM(4,2) >= 0.7)
            msgLog = [msgLog, 'Correct, the efficiency with 2A is >= than 0.7'];    
        else
            msgLog = [msgLog, 'Error, the efficiency with 2A is less than 0.7'];
            effOK = 0;
        end
        
        if(effM(4,4) >= 0.63)
            msgLog = [msgLog, 'Correct, the efficiency with 4A is >= 0.63'];
        else
            msgLog = [msgLog, 'Error, the efficiency at 4A is less than 0.63'];
            effOK = 0;
        end
    elseif(voutValue == 1.8)
    elseif(voutValue == 2.5)
        if(effM(4,2) >= 0.8)
            msgLog = [msgLog, 'Correct, the efficiency with 2A is >= than 0.8'];    
        else
            msgLog = [msgLog, 'Error, the efficiency with 2A is less than 0.8'];
            effOK = 0;
        end
        if(effM(4,4) >= 0.74)
            msgLog = [msgLog, 'Correct, he efficiency with 4A is >= 0.74'];
        else
            msgLog = [msgLog, 'Error, the efficiency at 4A is less than 0.74'];
            effOK = 0;
        end
    elseif(voutValue == 3.3)
        
    elseif(voutValue == 5)
        if(effM(4,2) >= 0.86)
            msgLog = [msgLog, 'Correct, the efficiency with 2A is >= than 0.86'];    
        else
            msgLog = [msgLog, 'Error, the efficiency with 2A is less than 0.86'];
            effOK = 0;
        end
    end    
    
    %%%Calculate drop
    %use point 4, becaus Vin = 10 is the point 4
    if(voutZERO - voutTested(4,2) <= 0.01)
        msgLog = [msgLog, 'Correct, the drop at 2A'];
    else
        msgLog = [msgLog, 'Error, the drop at 2A'];
    end
    
    if(voutZERO - voutTested(4,4) <= 0.02)
        msgLog = [msgLog, 'Correct, the drop at 4A'];
    else
        msgLog = [msgLog, 'Error, the drop at 4A'];
    end
else
    msgLog = [''];
end

