function varargout = scanConverter(varargin)
%SCANCONVERTER M-file for scanConverter.fig
%      SCANCONVERTER, by itself, creates a new SCANCONVERTER or raises the existing
%      singleton*.
%
%      H = SCANCONVERTER returns the handle to a new SCANCONVERTER or the handle to
%      the existing singleton*.
%
%      SCANCONVERTER('Property','Value',...) creates a new SCANCONVERTER using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to scanConverter_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SCANCONVERTER('CALLBACK') and SCANCONVERTER('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SCANCONVERTER.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help scanConverter

% Last Modified by GUIDE v2.5 04-Dec-2013 19:06:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scanConverter_OpeningFcn, ...
                   'gui_OutputFcn',  @scanConverter_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before scanConverter is made visible.
function scanConverter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

handles.output = 'Yes';

global connection;
global TEST_STATE;    
global modeldcdcScan;
global voutdcdcScan;
global namedcdcScan;
global exitVar;

cd('../');
dataConverter = scanBarCode;    %scan the barcode
cd('./AdminUSer');
if(exitVar ~= 1)
    modeldcdcScan = dataConverter{1}(1);
    voutdcdcScan = str2double(dataConverter{1}(3));
    namedcdcScan = strcat(dataConverter{1}(1), '-',dataConverter{1}(2));

    set(handles.editName, 'String', namedcdcScan);
    set(handles.editVout, 'String', voutdcdcScan);

    % Update handles structure
    guidata(hObject, handles);

    % Make the GUI modal
    set(handles.figure1,'WindowStyle','modal')

    % UIWAIT makes insertNewModel wait for user response (see UIRESUME)
    uiwait(handles.figure1);
else
	delete(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = scanConverter_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if(size(handles)~= [0 0])
    varargout{1} = handles.output;
    delete(handles.figure1);
else
    handles.output = 'NO';
    varargout{1} = handles.output;
end

% --- Executes on button press in pushCancel.
function pushCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);
%clc;

function editName_Callback(hObject, eventdata, handles)
% hObject    handle to editName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editName as text
%        str2double(get(hObject,'String')) returns contents of editName as a double


% --- Executes during object creation, after setting all properties.
function editName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editVout_Callback(hObject, eventdata, handles)
% hObject    handle to editVout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editVout as text
%        str2double(get(hObject,'String')) returns contents of editVout as a double


% --- Executes during object creation, after setting all properties.
function editVout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editVout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushStartTest.
function pushStartTest_Callback(hObject, eventdata, handles)
% hObject    handle to pushStartTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TEST_STATE;
global modeldcdcScan;
global voutdcdcScan;
global namedcdcScan;
global channeldcdc;

if(TEST_STATE == 0)
    TEST_STATE = 1;
    try
        %address = get(handles.editAddress, 'String');
        channeldcdc = str2double(get(handles.editChannel, 'String'));
        doTest(hObject, handles);
    catch
        TEST_STATE = 0;
        %errorValues;
    end
end

function doTest(hObject, handles)
    global connection;
    global modeldcdcScan;
    global voutdcdcScan;
    global namedcdcScan;
    global channeldcdc;
    global voutZERO;
    global imonZERO;
    msgLog = [''];
    %TEST
    [dcdc] = handles.output;

    %after test
    %[sth] = scanConverter();
    [row col] = size(dcdc);
    if(col == 3)
        vindcdc = [];
        iloaddcdc = [];

        action = ['SELECT * FROM CONVERTER WHERE MODEL = ' '''' char(modeldcdcScan) '''  AND NAME = ' '''' char(namedcdcScan) ''' '];
        cursor = exec(connection,  action);
        cursor = fetch(cursor);

        if(strcmp(cursor.Data(1), 'No Data') == 0)
            %The normal user cannot test twice the same converter
            return;
        end
        set(handles.textInitDark, 'BackgroundColor', [0.788,0.91,0.71]); %Change to lighter
        set(handles.textTest, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
%********************* TEST ****************%
%*******************************************%

        try
            action = ['SELECT ALL POINT, VALUE FROM CONFIG_DCDC WHERE MODEL = ' '''' char(modeldcdcScan) ''' AND CONFIG = ''VIN'' '];
            cursor = exec(connection,  action);
            cursor = fetch(cursor);
            [row col] = size(cursor.Data);

            for i=1:row
                index = cursor.Data{i,1};
                vindcdc(index) = cursor.Data{i,2};
            end

            action = ['SELECT ALL POINT, VALUE FROM CONFIG_DCDC WHERE MODEL = ' '''' char(modeldcdcScan) ''' AND CONFIG = ''ILOAD'' '];
            cursor = exec(connection,  action);
            cursor = fetch(cursor);
            [row col] = size(cursor.Data);

            for i=1:row
                index = cursor.Data{i,1};
                iloaddcdc(index) = cursor.Data{i,2};
            end
            
            action = ['SELECT POINT FROM CONFIG_DCDC WHERE MODEL = ' '''' char(modeldcdcScan) ''' AND CONFIG = ''AVG_V'' '];
            cursor = exec(connection,  action);
            cursor = fetch(cursor);
            avgVin = cursor.Data{1};
            
            action = ['SELECT POINT FROM CONFIG_DCDC WHERE MODEL = ' '''' char(modeldcdcScan) ''' AND CONFIG = ''AVG_IL1'' '];
            cursor = exec(connection,  action);
            cursor = fetch(cursor);
            avgIl_point1 = cursor.Data{1};
            
            action = ['SELECT POINT FROM CONFIG_DCDC WHERE MODEL = ' '''' char(modeldcdcScan) ''' AND CONFIG = ''AVG_IL2'' '];
            cursor = exec(connection,  action);
            cursor = fetch(cursor);
            avgIl_point2 = cursor.Data{1};
            
            cd('../TestConverter'); %Change folder
            [vmondcdc imondcdc voutdcdc ioutdcdc] = plot_reg_vin_AMIS5MP(vindcdc, iloaddcdc, namedcdcScan, handles);
            [voutZERO imonZERO] = checkVoutZero();
            cd('../AdminUser');

        catch
            set(handles.textInitDark, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.textTest, 'BackgroundColor', [0.788,0.91,0.71]); %Change to light
            msgLog = [msgLog,'Error in test'];
        end

%********************* END TEST ****************%

        Pout = voutdcdc.*ioutdcdc;
        Pin = vmondcdc.*imondcdc;
        effV = abs(Pout./Pin);
        %[msg voutTEST effTEST iInTEST dropTEST] = efficiency(namedcdcScan, modeldcdcScan, effV, voutdcdc, round(voutdcdc(1,1)*10)/10, str2num(voutdcdcScan{1}));
        [vInitMin vInitMax iInitMax v2Min v4Min eff2 eff4] = featuresTest(effV, voutdcdcScan, voutZERO, imonZERO, voutdcdc, avgVin, avgIl_point1, avgIl_point2);
        %passtest = isempty(strfind(msg, 'Error')); %If it is empty, there is not error and the test is correct
                                     %If it is not empty, there is an error and it doesnt pass the test.
                                                   
        %%%%%%%%%% SHOW RESULTS %%%%%%%
        
        set(handles.textTest, 'BackgroundColor', [0.788,0.91,0.71]); %Change to lighter
        set(handles.pushStartTest, 'BackgroundColor', [0.788,0.91,0.71]); %Change to lighter
        %set(handles.textResults, 'BackgroundColor', [0.608,0.812,0.478]); %Change to darker
        set(handles.pushCheckConverter, 'BackgroundColor', [0.608,0.812,0.478]); %Change to darker
        set(handles.textDisconnect, 'BackgroundColor', [0.608,0.812,0.478]);
        set(handles.textResults, 'BackgroundColor', [0.608,0.812,0.478]);
        set(handles.textDisconnect, 'Visible', 'on');
        
        
        set(handles.vZeroMin, 'String', round(vInitMin*100)/100);
        set(handles.vZeroMax, 'String', round(vInitMax*100)/100);
        set(handles.iZeroMax, 'String', iInitMax);
        set(handles.vMin2A, 'String', round(v2Min*100)/100);
        set(handles.vMin4A, 'String', round(v4Min*100)/100);
        set(handles.eff2A, 'String', round(eff2));
        set(handles.eff4A, 'String', round(eff4));
        
        set(handles.testV2A, 'String', round((voutZERO - voutdcdc(avgIl_point1,avgVin))*100)/100);
        set(handles.testV4A, 'String', round((voutZERO - voutdcdc(avgIl_point2,avgVin))*100)/100);
        set(handles.testeff2A, 'String', round((effV(avgVin,avgIl_point1)*100)));
        set(handles.testeff4A, 'String', round((effV(avgVin,avgIl_point2)*100)));
        set(handles.testiIn0A, 'String', imonZERO*1000);

        close(cursor);
    end

function editChannel_Callback(hObject, eventdata, handles)
% hObject    handle to editChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editChannel as text
%        str2double(get(hObject,'String')) returns contents of editChannel as a double


% --- Executes during object creation, after setting all properties.
function editChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushCheckConverter.
function pushCheckConverter_Callback(hObject, eventdata, handles)
% hObject    handle to pushCheckConverter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Check that the converter is not connected
global TEST_STATE;
global modeldcdcScan;
global voutdcdcScan;
global connection;
if(TEST_STATE == 1 || TEST_STATE == 2)
    TEST_STATE = 2;
    vInitMin = get(handles.vZeroMin, 'String');
    vInitMax = get(handles.vZeroMax, 'String');
    iInitMax = get(handles.iZeroMax, 'String');
    v2Min = get(handles.vMin2A, 'String');
    v4Min = get(handles.vMin4A, 'String');
    eff2 = get(handles.eff2A, 'String');
    eff4 = get(handles.eff4A, 'String');
    
    values = {modeldcdcScan{1}, num2str(voutdcdcScan), vInitMin, vInitMax, iInitMax, v2Min, v4Min, eff2, eff4};
    insert(connection,'EFFICIENCY_DCDC',{'MODEL', 'VOUT', 'V_INIT_MIN', 'V_INIT_MAX', 'I_INIT_MAX',...
        'V_2_MIN', 'V_4_MIN', 'EFF2', 'EFF4'}, values);
    savedData;
    pushCancel_Callback(hObject, eventdata, handles);
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(hObject);


% --- Executes on button press in checkVout.
function checkVout_Callback(hObject, eventdata, handles)
% hObject    handle to checkVout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkVout

%Dont let the user change the values!!
if(get(hObject,'Value') == get(hObject, 'Max'))
    set(hObject, 'Value',0);
else
    set(hObject, 'Value',1);
end


% --- Executes on button press in checkEff.
function checkEff_Callback(hObject, eventdata, handles)
% hObject    handle to checkEff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkEff

%Dont let the user change the values!!
if(get(hObject,'Value') == get(hObject, 'Max'))
    set(hObject, 'Value',0);
else
    set(hObject, 'Value',1);
end


% --- Executes on button press in checkDrop.
function checkDrop_Callback(hObject, eventdata, handles)
% hObject    handle to checkDrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkDrop
%Dont let the user change the values!!
if(get(hObject,'Value') == get(hObject, 'Max'))
    set(hObject, 'Value',0);
else
    set(hObject, 'Value',1);
end


% --- Executes on button press in checkControl.
function checkControl_Callback(hObject, eventdata, handles)
% hObject    handle to checkControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkControl
%Dont let the user change the values!!
if(get(hObject,'Value') == get(hObject, 'Max'))
    set(hObject, 'Value',0);
else
    set(hObject, 'Value',1);
end
function vMin2A_Callback(hObject, eventdata, handles)
% hObject    handle to vMin2A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vMin2A as text
%        str2double(get(hObject,'String')) returns contents of vMin2A as a double


% --- Executes during object creation, after setting all properties.
function vMin2A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vMin2A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vZeroMax_Callback(hObject, eventdata, handles)
% hObject    handle to vZeroMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vZeroMax as text
%        str2double(get(hObject,'String')) returns contents of vZeroMax as a double


% --- Executes during object creation, after setting all properties.
function vZeroMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vZeroMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vMin4A_Callback(hObject, eventdata, handles)
% hObject    handle to vMin4A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vMin4A as text
%        str2double(get(hObject,'String')) returns contents of vMin4A as a double


% --- Executes during object creation, after setting all properties.
function vMin4A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vMin4A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eff2A_Callback(hObject, eventdata, handles)
% hObject    handle to eff2A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eff2A as text
%        str2double(get(hObject,'String')) returns contents of eff2A as a double


% --- Executes during object creation, after setting all properties.
function eff2A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eff2A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eff4A_Callback(hObject, eventdata, handles)
% hObject    handle to eff4A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eff4A as text
%        str2double(get(hObject,'String')) returns contents of eff4A as a double


% --- Executes during object creation, after setting all properties.
function eff4A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eff4A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function testiIn0A_Callback(hObject, eventdata, handles)
% hObject    handle to testiIn0A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of testiIn0A as text
%        str2double(get(hObject,'String')) returns contents of testiIn0A as a double


% --- Executes during object creation, after setting all properties.
function testiIn0A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testiIn0A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function testV2A_Callback(hObject, eventdata, handles)
% hObject    handle to testV2A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of testV2A as text
%        str2double(get(hObject,'String')) returns contents of testV2A as a double


% --- Executes during object creation, after setting all properties.
function testV2A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testV2A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function testV4A_Callback(hObject, eventdata, handles)
% hObject    handle to testV4A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of testV4A as text
%        str2double(get(hObject,'String')) returns contents of testV4A as a double


% --- Executes during object creation, after setting all properties.
function testV4A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testV4A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function testeff2A_Callback(hObject, eventdata, handles)
% hObject    handle to testeff2A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of testeff2A as text
%        str2double(get(hObject,'String')) returns contents of testeff2A as a double


% --- Executes during object creation, after setting all properties.
function testeff2A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testeff2A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function testeff4A_Callback(hObject, eventdata, handles)
% hObject    handle to testeff4A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of testeff4A as text
%        str2double(get(hObject,'String')) returns contents of testeff4A as a double


% --- Executes during object creation, after setting all properties.
function testeff4A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testeff4A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
