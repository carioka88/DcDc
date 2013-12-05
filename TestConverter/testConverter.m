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

global exitVar;
global connection;
global TEST_STATE;    
global modeldcdcScan;
global voutdcdcScan;

TEST_STATE = 0;
exitVar = 0;
connectFunction;
msg = '';
while exitVar ~= 3
    while exitVar ~= 3
        systemCommand = ['C:\Python27\python.exe scanner.py ' '' msg '' ];
        [status data] = system(systemCommand);
        dataConverter = {strsplit(data,',')};
        [f c] = size(dataConverter{1});
        if(strfind(data, 'Exit') == 1)
            exitVar = 1;
            break;
        else
            %c = 3 because there are 3 element,
            % model, number, vout
            if (c == 3)
                %Check if the converter is connected
                try 
                    if(checkConnectivity() < 0.3)
                        exitVar = 2;
                        msg = 'CHECK_ALL_THE_INSTRUMENTS';
                    else
                        exitVar = 3;   
                    end
                catch
                    exitVar = 2;
                    msg = 'CHECK_THE_CONNECTIVITY';
                end
            else
                msg = 'ERROR_SCANNING';
            end
        end
    end

    if (exitVar == 1 )
        guidata(hObject, handles);
        return;
    elseif (exitVar == 3)
       %Check that the first argument is a correct dcdc Model
       action = ['SELECT * FROM CONFIG_DCDC WHERE MODEL = ' '''' str2mat(dataConverter{1}(1)) ''' '];
       cursor = exec(connection, action);
       cursor = fetch(cursor);
       if(strcmp(cursor.Data{1},'No Data'))
           exitVar = 2;
       else
           namedcdc = strcat(dataConverter{1}(1),'-',dataConverter{1}(2));
           action = ['SELECT * FROM CONVERTER WHERE MODEL = ' '''' str2mat(dataConverter{1}(1)) ''' AND NAME=' '''' str2mat(namedcdc) ''' '];
           cursor = exec(connection, action);
           cursor = fetch(cursor);
           if(strcmp(cursor.Data{1},'No Data'))
               exitVar = 3;
           else
               exitVar = 2;
           end
       end
    end
end
modeldcdcScan = dataConverter{1}(1);
voutdcdcScan = dataConverter{1}(3);

set(handles.editName, 'String', strcat(dataConverter{1}(1),'-',dataConverter{1}(2)));
set(handles.editVout, 'String', str2mat(dataConverter{1}(3)));

% Update handles structure
guidata(hObject, handles);

% Insert custom Title and Text if specified by the user
% Hint: when choosing keywords, be sure they are not easily confused 
% with existing figure properties.  See the output of set(figure) for
% a list of figure properties.
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'title'
          set(hObject, 'Name', varargin{index+1});
         case 'string'
          set(handles.textVIN, 'String', varargin{index+1});
        end
    end
end

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% Show a question icon from dialogicons.mat - variables questIconData
% and questIconMap
load dialogicons.mat

IconData=questIconData;
questIconMap(256,:) = get(handles.figure1, 'Color');
IconCMap=questIconMap;

set(handles.figure1, 'Colormap', IconCMap);

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes insertNewModel wait for user response (see UIRESUME)
uiwait(handles.figure1);


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
if(TEST_STATE == 0)
    TEST_STATE = 1;
    
    try
        name = get(handles.editName, 'String');
        vout = get(handles.editVout, 'String');
        vout = str2num(vout);

        %address = get(handles.editAddress, 'String');
        channel = str2num(get(handles.editChannel, 'String'));
        if(size(vout) == [0 0] | size(channel) == [0 0])
            errorValues;    
        else
            handles.output = {name, vout, channel};

            doTest(hObject, handles);
            guidata(hObject, handles);
            % Use UIRESUME instead of delete because the OutputFcn needs
            % to get the updated handles structure.
            %uiresume(handles.figure1);
        end
    catch
        TEST_STATE = 0;
        errorValues;
    end
end

function doTest(hObject, handles)
    global connection;
    global modeldcdcScan;
    global voutdcdcScan;
    global voutZERO;
    global imonZERO;
    msgLog = [''];
    %TEST
    [dcdc] = handles.output;

    %after test
    %[sth] = testConverter();
    [row col] = size(dcdc);
    if(col == 3)
        vindcdc = [];
        iloaddcdc = [];

        namedcdc = dcdc(1);
        voutdcdc = dcdc(2);
        channeldcdc = dcdc(3);

        testValue = 1;
        modeldcdc = modeldcdcScan;
        action = ['SELECT * FROM CONVERTER WHERE MODEL = ' '''' str2mat(modeldcdc) '''  AND NAME = ' '''' str2mat(namedcdc{1}) ''' '];
        cursor = exec(connection,  action);
        cursor = fetch(cursor);

        if(strcmp(cursor.Data(1), 'No Data') == 0)
            [numTest col] = size(cursor.Data);
            testValue = numTest + 1;
            %The normal user cannot test twice the same converter
            return;
        end
        testTime = clock;
        startTest = ['Start:', mat2str(testTime(3)), '-' , mat2str(testTime(2)), '-' , mat2str(testTime(1)), ...
            '\t', mat2str(testTime(4)), ':', mat2str(testTime(5))];
        
        set(handles.textInitDark, 'BackgroundColor', [0.788,0.91,0.71]); %Change to lighter
        set(handles.textTest, 'BackgroundColor', [0.608,0.812,0.478]); %Change to dark
%********************* TEST ****************%
%*******************************************%

        try
            if(strcmp(modeldcdc, 'AMIS5MP') == 1)
                %
                'doing test'
                action = ['SELECT ALL POINT, VALUE FROM CONFIG_DCDC WHERE MODEL = ' '''' str2mat(modeldcdc) ''' AND CONFIG = ''VIN'' '];
                cursor = exec(connection,  action);
                cursor = fetch(cursor);
                [row col] = size(cursor.Data);

                for i=1:row
                    index = cursor.Data{i,1};
                    vindcdc(index) = cursor.Data{i,2};
                end

                action = ['SELECT ALL POINT, VALUE FROM CONFIG_DCDC WHERE MODEL = ' '''' str2mat(modeldcdc) ''' AND CONFIG = ''ILOAD'' '];
                cursor = exec(connection,  action);
                cursor = fetch(cursor);
                [row col] = size(cursor.Data);

                for i=1:row
                    index = cursor.Data{i,1};
                    iloaddcdc(index) = cursor.Data{i,2};
                end
                vindcdc
                iloaddcdc
                [vmondcdc imondcdc voutdcdc ioutdcdc] = plot_reg_vin_AMIS5MP(vindcdc, iloaddcdc, namedcdc, handles);
                [voutZERO imonZERO] = checkVoutZero();
            else
                %
            end
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
        effV = Pout./Pin;
        [msg voutTEST effTEST iInTEST dropTEST] = efficiency(modeldcdc, effV, voutdcdc, round(voutdcdc(1,1)*10)/10, str2num(voutdcdcScan{1}));
        passtest = isempty(strfind(msg, 'Error')); %If it is empty, there is not error and the test is correct
                                     %If it is not empty, there is an error and it doesnt pass the test.
                                                   
%********************* SAVE DATA ****************%
%************************************************%
            %Check if there is address
            try
                addressdcdc = '';
                action = {cell2mat(namedcdc{1}), cell2mat(modeldcdc), '1', date, str2double(voutdcdcScan), cell2mat(channeldcdc), addressdcdc, passtest};
                insert(connection, 'CONVERTER', {'NAME','MODEL', 'TEST', 'DATEC','VOUT', 'CHANNEL', 'ADDRESS', 'PASSTEST'}, action);
                [rImon ColIload] = size(iloaddcdc);
                [rImon ColVin] = size(vindcdc);
                % Write data to database.
                for j=1:ColIload
                    for z=1:ColVin
                        action = {cell2mat(namedcdc{1}), vindcdc(z), iloaddcdc(j), imondcdc(z,j), ioutdcdc(z,j), vmondcdc(z,j), voutdcdc(z,j), '1', cell2mat(channeldcdc)};
                        insert(connection, 'DCDC_CONVERTER', {'NAME', 'V_IN', 'I_LOAD','IMON', 'IOUT', 'VMON', 'VOUT', 'TEST', 'CHANNEL'}, action);
                    end
                end
                
                %%Add VoutZERO and IinZERO
                    action = {cell2mat(namedcdc{1}), 10, 0, imonZERO, voutZERO, '1', cell2mat(channeldcdc)};
                    insert(connection, 'DCDC_CONVERTER', {'NAME', 'V_IN', 'I_LOAD','IMON', 'VOUT', 'TEST', 'CHANNEL'}, action);
            catch
                msgLog = [msgLog, 'Error saving data'];
            end
%********************* END SAVE DATA ****************%

%********************* LOGFILE ****************%
%**********************************************%
            fid = fopen('logfile.txt', 'a+');
            fprintf(fid, str2mat(namedcdc{1}));
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

function connectFunction
% hObject    handle to connectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global connection;
connection = open_dcdc_tracking();

if connection.Message ~= 0
    'ERROR'
    return;
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
    disconnected = 0;
    if(disconnected == 0) 
        try
            if(checkConnectivity < 0.3)
                disconnected = 1;
                pushCancel_Callback(hObject, eventdata, handles)
                testConverter;
            end
        catch
            disconnected = 1;
            pushCancel_Callback(hObject, eventdata, handles)
            testConverter;
        end
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

function dcdcConnectivity = checkConnectivity()
    k7001_preset_AMIS5MP();
    hp6051_set_current(3, 15, 1);
    tti_set(2,10,6);
    tti_out(2,1);
    k7001_select_channel(7,CHN_Vout);
    pause(WAITSCAN);
    dcdcConnectivity = k2000_get_volt(1);
    k7001_disconnect(7);
    tti_out(2, 0);

function [dcdcVoutZero ImonZero] = checkVoutZero()
    k7001_preset_AMIS5MP();
    hp6051_set_current(3, 15, 0);
    tti_set(2, 10, 6);  % set vin 
    tti_out(2, 1);          % turn on
    pause(1);
    [dcdcVoutZero, ImonZero] = tti_get(2); % read Vin and Iin at LVPS

    % measure through DVM
% 
%     k7001_select_channel(7, CHN_Vin);
%     pause(WAITSCAN);
%     dcdcVoutZero = k2000_get_volt(1);

    k7001_select_channel(7, CHN_Vout);
    pause(WAITSCAN);
    dcdcVoutZero = k2000_get_volt(1);
    k7001_disconnect(7);

    tti_out(2, 0);          % turn off
    pause(1);
