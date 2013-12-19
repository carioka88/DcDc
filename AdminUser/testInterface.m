function varargout = testInterface(varargin)
% TESTINTERFACE MATLAB code for testInterface.fig
%      TESTINTERFACE, by itself, creates a new TESTINTERFACE or raises the existing
%      singleton*.
%
%      H = TESTINTERFACE returns the handle to a new TESTINTERFACE or the handle to
%      the existing singleton*.
%
%      TESTINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTINTERFACE.M with the given input arguments.
%
%      TESTINTERFACE('Property','Value',...) creates a new TESTINTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testInterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testInterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testInterface

% Last Modified by GUIDE v2.5 03-Dec-2013 15:25:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testInterface_OpeningFcn, ...
                   'gui_OutputFcn',  @testInterface_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before testInterface is made visible.
function testInterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testInterface (see VARARGIN)

% Choose default command line output for testInterface
handles.output = hObject;
connectFunction;

global connection;
cursor = exec(connection,'SELECT DISTINCT MODEL FROM CONFIG_DCDC');
cursor = fetch(cursor);
[row col] = size(cursor.Data);

typeModels = (cursor.Data)';

for i=1:row
    finalName = cell2mat(typeModels(i));
    typeModels(i) = mat2cell(finalName);
end

set(handles.popupmenu1, 'String', typeModels);
close(cursor);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testInterface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testInterface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in doTEST.
function doTEST_Callback(hObject, eventdata, handles)
    global connection;    
    try
        testConverter(0);
    catch
        
    end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addModel.
function addModel_Callback(hObject, eventdata, handles)
% hObject    handle to addModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global connection;
newModel = insertNewModel;

% newModel{model, vin, iload, posVin, posIload_1, posIload_2, valueVin, valueIload_1, valueIload_2}
[row col] = size(newModel);

if(col == 9)
    
    [row col] = size(newModel{2});
    try
        for i=1:col
            values = {newModel{1}, 'VIN', i, newModel{2}(i)};
            insert(connection,'CONFIG_DCDC',{'MODEL', 'CONFIG', 'POINT', 'VALUE'}, values);
        end

        [row col] = size(newModel{3});
        for i=1:col
            values = {newModel{1}, 'ILOAD', i, newModel{3}(i)};
            insert(connection,'CONFIG_DCDC',{'MODEL', 'CONFIG', 'POINT', 'VALUE'}, values);
        end
        
        values = {newModel{1}, 'AVG_V', newModel{4}, newModel{7}};
        insert(connection,'CONFIG_DCDC',{'MODEL', 'CONFIG', 'POINT', 'VALUE'}, values);
        
        values = {newModel{1}, 'AVG_IL1', newModel{5}, newModel{8}};
        insert(connection,'CONFIG_DCDC',{'MODEL', 'CONFIG', 'POINT', 'VALUE'}, values);
        
        values = {newModel{1}, 'AVG_IL2', newModel{6}, newModel{9}};
        insert(connection,'CONFIG_DCDC',{'MODEL', 'CONFIG', 'POINT', 'VALUE'}, values);
        
        cursor = exec(connection,'SELECT DISTINCT MODEL FROM DCDC_TRACKING.CONFIG_DCDC');
        cursor = fetch(cursor);
        [row col] = size(cursor.Data);

        typeModels = (cursor.Data)';

        for i=1:row
            finalName = cell2mat(typeModels(i));
            lengthName=1;
            while(numel(finalName) >= lengthName && finalName(lengthName) ~= ' ')
                lengthName = lengthName+1;
            end
            finalName = finalName(1:lengthName-1);
            typeModels(i) = mat2cell(finalName);
        end

        set(handles.popupmenu1, 'String', typeModels);
        close(cursor);
    catch
         cd('../PopUpWindows');
         errorNameExist;
         cd('../AdminUser');
    end
end
guidata(hObject, handles);
% --- Executes on button press in connectButton.
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

function listNames = getNames(cellNames)
    [r c] = size(cellNames);
    for j=1:r
        auxName = strsplit(cellNames{j});
        listNames(j,1) = auxName(1);
    end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% Hint: delete(hObject) closes the figure
global connection;

% e.Data;
close_dcdc_tracking(connection);

delete(hObject);


% --- Executes on button press in pushEditModel.
function pushEditModel_Callback(hObject, eventdata, handles)
% hObject    handle to pushEditModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global connection; 
listModel = get(handles.popupmenu1, 'String');
indexModel = get(handles.popupmenu1, 'Value');
model = listModel(indexModel);

editConstraints(model);
guidata(hObject, handles);

% --- Executes on button press in pushCancel.
function pushCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushAccept.
function pushAccept_Callback(hObject, eventdata, handles)
% hObject    handle to pushAccept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global connection;
inputDataModel = cell(1,2);

try
   
    vin = get(handles.editVin, 'String');
    iload = get(handles.editIload, 'String');
    
    vin = strsplit(vin,',');
    iload = strsplit(iload,',');
    [inputDataModel{1}, inputDataModel{2}] = checkDATA(vin, iload);

    if(isempty(find(inputDataModel{2} > 4)) ~= 1)
        'ERROR ILOAD'
        cd('../PopUpWindows');
        errorVinIload;
        cd('../AdminUser');
    elseif(isempty(find(inputDataModel{1} > 12)) ~= 1)
        'ERROR VIN'
        cd('../PopUpWindows');
        errorVinIload;
        cd('../AdminUser');
    else
        % Update handles structure
        
        %%Introducir un mensaje de si esta realmente seguro!!!!
        
        
        %update(connection, );
        guidata(hObject, handles);
    end
catch
    errorValues;
end


function editVin_Callback(hObject, eventdata, handles)
% hObject    handle to editVin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editVin as text
%        str2double(get(hObject,'String')) returns contents of editVin as a double


% --- Executes during object creation, after setting all properties.
function editVin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editVin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editIload_Callback(hObject, eventdata, handles)
% hObject    handle to editIload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editIload as text
%        str2double(get(hObject,'String')) returns contents of editIload as a double


% --- Executes during object creation, after setting all properties.
function editIload_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editIload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [vinValues iloadValues] = checkDATA(inputVin, inputLoad)
    
    [row col] = size(inputVin);
    vinValues = [];
    for i=1:col
        vinValues(i) = str2num(cell2mat(inputVin(i)));
    end
    
    [row col] = size(inputLoad);
    iloadValues = [];
    for i=1:col
        iloadValues(i) = str2num(cell2mat(inputLoad(i)));
    end


% --- Executes on button press in pushScan.
function pushScan_Callback(hObject, eventdata, handles)
% hObject    handle to pushScan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global connection;    
    try
        scanConverter;
    catch
        
    end
