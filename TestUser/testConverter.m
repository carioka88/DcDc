function varargout = testConverter(varargin)
%TESTCONVERTER M-file for testConverter.fig
%      TESTCONVERTER, by itself, creates a new TESTCONVERTER or raises the existing
%      singleton*.
%
%      H = TESTCONVERTER returns the handle to a new TESTCONVERTER or the handle to
%      the existing singleton*.
%
%      TESTCONVERTER('Property','Value',...) creates a new TESTCONVERTER using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to testConverter_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      TESTCONVERTER('CALLBACK') and TESTCONVERTER('CALLBACK',hObject,...) call the
%      local function named CALLBACK in TESTCONVERTER.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testConverter

% Last Modified by GUIDE v2.5 25-Nov-2013 10:35:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testConverter_OpeningFcn, ...
                   'gui_OutputFcn',  @testConverter_OutputFcn, ...
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


% --- Executes just before testConverter is made visible.
function testConverter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for insertNewModel
handles.output = 'Yes';

global connection;
global TEST_STATE;    
global modeldcdcScan;
global voutdcdcScan;
global namedcdcScan;
global exitVar;

cd('../');
dataConverter = scanBarCode;    %scan the barcode
cd('./TestUser');

if( exitVar ~= 1)
    
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
function varargout = testConverter_OutputFcn(hObject, eventdata, handles)
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


% --- Executes on button press in pushAccept.
function pushAccept_Callback(hObject, eventdata, handles)
% hObject    handle to pushAccept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TEST_STATE;
global connection;
global voutdcdcScan;
global modeldcdcScan;
global namedcdcScan;
global channeldcdc;

if(TEST_STATE == 0)
    TEST_STATE = 1;
    
    try
        channeldcdc = str2double(get(handles.editChannel, 'String'));
        doTest(hObject, handles);
        guidata(hObject, handles);
    catch
        TEST_STATE = 0;
        errorValues;
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
    global avgVIN;
    global avgILOAD_point1;
    global avgILOAD_point2;
    
    msgLog = [''];
    %TEST
    
    if(isnumeric(voutdcdcScan))
        vindcdc = [];
        iloaddcdc = [];
        
        action = ['SELECT * FROM CONVERTER WHERE MODEL = ' '''' char(modeldcdcScan) '''  AND NAME = ' '''' char(namedcdcScan) ''' '];
        cursor = exec(connection,  action);
        cursor = fetch(cursor);

        if(strcmp(cursor.Data(1), 'No Data') == 0)
            return; %The normal user cannot test twice the same converter
        end
        testTime = clock;
        startTest = ['Start:', mat2str(testTime(3)), '-' , mat2str(testTime(2)), '-' , mat2str(testTime(1)), ...
            '\t', mat2str(testTime(4)), ':', mat2str(testTime(5))];
        
        set(handles.textInitDark, 'BackgroundColor', [0.788,0.91,0.71]); %Change to lighter
        set(handles.textTest, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
%********************* TEST ****************%
%*******************************************%

        try
            'doing test'
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
            vindcdc
            iloaddcdc
            
            action = ['SELECT POINT FROM CONFIG_DCDC WHERE MODEL = ' '''' char(modeldcdcScan) ''' AND CONFIG = ''AVG_V'' '];
            cursor = exec(connection,  action);
            cursor = fetch(cursor);
            
            avgVIN = cursor.Data{1};
            
            action = ['SELECT POINT FROM CONFIG_DCDC WHERE MODEL = ' '''' char(modeldcdcScan) ''' AND CONFIG = ''AVG_IL1'' '];
            cursor = exec(connection,  action);
            cursor = fetch(cursor);
            
            avgILOAD_point1 = cursor.Data{1};
            
            action = ['SELECT POINT FROM CONFIG_DCDC WHERE MODEL = ' '''' char(modeldcdcScan) ''' AND CONFIG = ''AVG_IL2'' '];
            cursor = exec(connection,  action);
            cursor = fetch(cursor);
            
            avgILOAD_point2 = cursor.Data{1};
            
            cd('../TestConverter'); %Change folder
            [vmondcdc imondcdc voutdcdc ioutdcdc] = plot_reg_vin_AMIS5MP(vindcdc, iloaddcdc, namedcdcScan, handles);
            [voutZERO imonZERO] = checkVoutZero();
            cd('../TestUser'); %Change folder
        catch
            set(handles.textInitDark, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
            set(handles.textTest, 'BackgroundColor', [0.788,0.91,0.71]); %Change to light
            msgLog = [msgLog,'Error in test'];
        end

%********************* END TEST ****************%

        testTime = clock;
        endTest = ['End:', mat2str(testTime(3)), '-' , mat2str(testTime(2)), '-' , mat2str(testTime(1)), ...
            '\t', mat2str(testTime(4)), ':', mat2str(testTime(5))];
        
        %testMatlab = ['C:\Python27\python.exe thread.py'];
        %[status data] = system(testMatlab)

        %Always the test is saved
        Pout = voutdcdc.*ioutdcdc;
        Pin = vmondcdc.*imondcdc;
        effV = abs(Pout./Pin);
        [msg voutTEST effTEST iInTEST dropTEST] = efficiency(modeldcdcScan, effV, voutdcdc, round(voutdcdc(1,1)*10)/10, voutdcdcScan, avgVIN, avgILOAD_point1, avgILOAD_point2);
        passtest = isempty(strfind(msg, 'Error')); %If it is empty, there is not error and the test is correct
                                     %If it is not empty, there is an error and it doesnt pass the test.
                                                   
%********************* SAVE DATA ****************%
%************************************************%
            %Check if there is address
            try
                addressdcdc = '';
                action = {namedcdcScan{1}, modeldcdcScan{1}, '1', date, voutdcdcScan, channeldcdc, addressdcdc, passtest};
                insert(connection, 'CONVERTER', {'NAME','MODEL', 'TEST', 'DATEC','VOUT', 'CHANNEL', 'ADDRESS', 'PASSTEST'}, action);
                [rImon ColIload] = size(iloaddcdc);
                [rImon ColVin] = size(vindcdc);
                % Write data to database.
                for j=1:ColIload
                    for z=1:ColVin
                        action = {namedcdcScan{1}, vindcdc(z), iloaddcdc(j), imondcdc(z,j), ioutdcdc(z,j), vmondcdc(z,j), voutdcdc(z,j), '1', channeldcdc};
                        insert(connection, 'DCDC_CONVERTER', {'NAME', 'V_IN', 'I_LOAD','IMON', 'IOUT', 'VMON', 'VOUT', 'TEST', 'CHANNEL'}, action);
                    end
                end
                
                %%Add VoutZERO and IinZERO
                    action = {namedcdcScan{1}, 10, 0, imonZERO, voutZERO, '1', channeldcdc};
                    insert(connection, 'DCDC_CONVERTER', {'NAME', 'V_IN', 'I_LOAD','IMON', 'VOUT', 'TEST', 'CHANNEL'}, action);
            catch
                msgLog = [msgLog, 'Error saving data'];
            end
%********************* END SAVE DATA ****************%

%********************* LOGFILE ****************%
%**********************************************%
            fid = fopen('logfile.txt', 'a+');
            fprintf(fid, namedcdcScan{1});
            fprintf(fid, '\t');
            fprintf(fid, startTest);
            fprintf(fid, '\t');
            fprintf(fid, endTest);
            fprintf(fid, '\t');
            fprintf(fid, msgLog); %if there is some errors
            fprintf(fid, '\n');
            fclose(fid);
%********************* END LOGFILE ************%
        %%%%%%%%%% SHOW RESULTS %%%%%%%
        
        set(handles.textTest, 'BackgroundColor', [0.788,0.91,0.71]); %Change to lighter
        set(handles.pushAccept, 'BackgroundColor', [0.788,0.91,0.71]); %Change to lighter
        %set(handles.textResults, 'BackgroundColor', [0.608,0.812,0.478]); %Change to darker
        set(handles.pushCheckConverter, 'BackgroundColor', [0.608,0.812,0.478]); %Change to darker
        set(handles.textDisconnect, 'BackgroundColor', [0.608,0.812,0.478]);
        set(handles.textResults, 'BackgroundColor', [0.608,0.812,0.478]);
        set(handles.textDisconnect, 'Visible', 'on');
        
        if(passtest)
            %There is not error
            set(handles.checkVout, 'Value', 1);
            set(handles.checkEff, 'Value', 1);
            set(handles.checkDrop, 'Value', 1);
            set(handles.checkControl, 'Value', 1);
            set(handles.textIin, 'String', iInTEST);
        else
            if(voutTEST == 0)
                set(handles.checkVout, 'Value', 0);
                %Change color rojo
            else
                set(handles.checkVout, 'Value', 1);
            end
            if(effTEST == 0)
                set(handles.checkEff, 'Value', 0);
            else
                set(handles.checkEff, 'Value', 1);
            end
            %CHECK standby
        end
               
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
if(TEST_STATE == 1 || TEST_STATE == 2)
    TEST_STATE = 2;
    try
        cd('../TestConverter');
        if(checkConnectivity < 0.3)
            cd('../TestUser');
            pushCancel_Callback(hObject, eventdata, handles)
            testConverter;
        else
            cd('../TestUser');
        end
    catch
        cd('../TestUser');
        pushCancel_Callback(hObject, eventdata, handles)
        testConverter;
    end
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

