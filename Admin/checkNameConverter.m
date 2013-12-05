function varargout = checkNameConverter(varargin)
%CHECKNAMECONVERTER M-file for checkNameConverter.fig
%      CHECKNAMECONVERTER, by itself, creates a new CHECKNAMECONVERTER or raises the existing
%      singleton*.
%
%      H = CHECKNAMECONVERTER returns the handle to a new CHECKNAMECONVERTER or the handle to
%      the existing singleton*.
%
%      CHECKNAMECONVERTER('Property','Value',...) creates a new CHECKNAMECONVERTER using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to checkNameConverter_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      CHECKNAMECONVERTER('CALLBACK') and CHECKNAMECONVERTER('CALLBACK',hObject,...) call the
%      local function named CALLBACK in CHECKNAMECONVERTER.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help checkNameConverter

% Last Modified by GUIDE v2.5 28-Oct-2013 09:51:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @checkNameConverter_OpeningFcn, ...
                   'gui_OutputFcn',  @checkNameConverter_OutputFcn, ...
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


% --- Executes just before checkNameConverter is made visible.
function checkNameConverter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for insertNewModel
handles.output = 'Yes';

global exitVar;
exitVar = 0;
connectFunction;
global connection;

while exitVar ~= 3
    while exitVar ~= 3
        systemCommand = ['C:\Python27\python.exe scanner.py'];
        [status data] = system(systemCommand);
        dataConverter = {strsplit(data,',')};
        [f c] = size(dataConverter{1});
        if(strfind(data, 'Exit') == 1)
            exitVar = 1;
            break;
        else
            if (c == 3)
                exitVar = 3;
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
       end
    end
end
    
global modeldcdcScan;
modeldcdcScan = dataConverter{1}(1);
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
function varargout = checkNameConverter_OutputFcn(hObject, eventdata, handles)
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
        uiresume(handles.figure1);
    end
catch
    errorValues;
end


function doTest(hObject, handles)
    global connection;
    global modeldcdcScan;
    %TEST
    [dcdc] = handles.output;
    
    %after test
    %[sth] = testConverter();
    [row col] = size(dcdc);
    if(col == 3)
        vindcdc = [];
        iloaddcdc = [];
        vmondcdc = [];
        imondcdc = [];
        ioutdcdc = [];
        voutdcdc = [];

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
%********************* TEST ****************%
%*******************************************%

%         try
%             if(strcmp(modeldcdc, 'AMIS5MP') == 1)
%                 %
%                 'doing test'
%                 action = ['SELECT ALL POINT, VALUE FROM CONFIG_DCDC WHERE MODEL = ' '''' modeldcdc ''' AND CONFIG = ''VIN'' '];
%                 cursor = exec(connection,  action);
%                 cursor = fetch(cursor);
%                 [row col] = size(cursor.Data);
% 
%                 for i=1:row
%                     index = cursor.Data{i,1};
%                     vindcdc(index) = cursor.Data{i,2};
%                 end
% 
%                 action = ['SELECT ALL POINT, VALUE FROM CONFIG_DCDC WHERE MODEL = ' '''' modeldcdc ''' AND CONFIG = ''ILOAD'' '];
%                 cursor = exec(connection,  action);
%                 cursor = fetch(cursor);
%                 [row col] = size(cursor.Data);
% 
%                 for i=1:row
%                     index = cursor.Data{i,1};
%                     iloaddcdc(index) = cursor.Data{i,2};
%                 end
%                 vindcdc
%                 iloaddcdc
%                 [vmondcdc, imondcdc, voutdcdc, ioutdcdc] = plot_reg_vin_AMIS5MP(vindcdc, iloaddcdc, str2mat(namedcdc));
%             else
%                 %
%             end

%********************* END TEST ****************%





        testTime = clock;
        endTest = ['End:', mat2str(testTime(3)), '-' , mat2str(testTime(2)), '-' , mat2str(testTime(1)), ...
            '\t', mat2str(testTime(4)), ':', mat2str(testTime(5))];
        %Always the test is saved
        showResults = displayResultsfig;
            

            
%********************* SAVE DATA ****************%
%************************************************%
%             try
%                 addressdcdc = '00000';
%                 action = {cell2mat(namedcdc), modeldcdc, '1', date, '0', cell2mat(channeldcdc), cell2mat(addressdcdc), passdcdc};
%                 insert(connection, 'CONVERTER', {'NAME','MODEL', 'TEST', 'DATEC','VOUT', 'CHANNEL', 'ADDRESS', 'PASSTEST'}, action);
%                 [rImon ColIload] = size(iloaddcdc);
%                 [rImon ColVin] = size(vindcdc);
%                 % Write data to database.
%                 for j=1:ColIload
%                     for z=1:ColVin
%                         action = {cell2mat(namedcdc), vindcdc(z), iloaddcdc(j), imondcdc(z,j), ioutdcdc(z,j), vmondcdc(z,j), voutdcdc(z,j), '1', cell2mat(channeldcdc)};
%                         insert(connection, 'DCDC_CONVERTER', {'NAME', 'V_IN', 'I_LOAD','IMON', 'IOUT', 'VMON', 'VOUT', 'TEST', 'CHANNEL'}, action);
%                     end
%                 end
%             catch
%                 algo = algo+1;
%             end
%********************* END SAVE DATA ****************%

%********************* LOGFILE ****************%
%**********************************************%
            fid = fopen('logfile.txt', 'a+');
            fprintf(fid, str2mat(namedcdc{1}));
            fprintf(fid, '\t');
            fprintf(fid, startTest);
            fprintf(fid, '\t');
            fprintf(fid, endTest);
            fprintf(fid, '\n');
            fclose(fid);
%********************* END LOGFILE ************%
   
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



% --- Executes on button press in pushScan.
function pushScan_Callback(hObject, eventdata, handles)
% hObject    handle to pushScan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
systemCommand = ['C:\Python27\python.exe scanner.py'];
[status data] = system(systemCommand);
dataConverter = {strsplit(data,',')};
set(handles.editName, 'String', strcat(dataConverter{1}(1),'-',dataConverter{1}(2)));
set(handles.editVout, 'String', dataConverter{1}(3));
guidata(hObject, handles);

function editScan_Callback(hObject, eventdata, handles)
% hObject    handle to editScan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editScan as text
%        str2double(get(hObject,'String')) returns contents of editScan as a double


% --- Executes during object creation, after setting all properties.
function editScan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editScan (see GCBO)
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
