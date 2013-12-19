function varargout = insertNewModel(varargin)
% INSERTNEWMODEL MATLAB code for insertNewModel.fig
%      INSERTNEWMODEL by itself, creates a new INSERTNEWMODEL or raises the
%      existing singleton*.
%
%      H = INSERTNEWMODEL returns the handle to a new INSERTNEWMODEL or the handle to
%      the existing singleton*.
%
%      INSERTNEWMODEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INSERTNEWMODEL.M with the given input arguments.
%
%      INSERTNEWMODEL('Property','Value',...) creates a new INSERTNEWMODEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before insertNewModel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to insertNewModel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help insertNewModel

% Last Modified by GUIDE v2.5 10-Dec-2013 11:04:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @insertNewModel_OpeningFcn, ...
                   'gui_OutputFcn',  @insertNewModel_OutputFcn, ...
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

% --- Executes just before insertNewModel is made visible.
function insertNewModel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to insertNewModel (see VARARGIN)

% Choose default command line output for insertNewModel
handles.output = 'Yes';

% Update handles structure
guidata(hObject, handles);

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes insertNewModel wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = insertNewModel_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if(size(handles)~= [0 0])
    varargout{1} = handles.output;
    delete(handles.figure1);
else
    handles.ouput = 'NO';
end
% --- Executes on button press in acceptbutton.
function acceptbutton_Callback(hObject, eventdata, handles)
% hObject    handle to acceptbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%handles.output = get(hObject,'String');

inputDataModel = cell(1,7);
try
    model = get(handles.modelEdit, 'String');
   
    vin = get(handles.editVIN, 'String');
    iload = get(handles.editIload, 'String');
    avgVin = get(handles.editAvgVIN, 'String');
    avgIload_1 = get(handles.editAvgILOAD_1, 'String');
    avgIload_2 = get(handles.editAvgILOAD_2, 'String');
    vin = strsplit(vin,',');
    iload = strsplit(iload,',');
    %Save the inputs, and check the data is correct!
    [inputDataModel{2}, inputDataModel{3}] = checkDATA(vin, iload);
    %Save the position to do the average
    [inputDataModel{4}, inputDataModel{5}, inputDataModel{6}] = checkAvg(vin, iload, avgVin, avgIload_1, avgIload_2);
    if(isempty(find(inputDataModel{3} > 4)) ~= 1)
        'ERROR ILOAD'
        cd('../PopUpWindows');
        errorVinIload;
        cd('../AdminUser');
    elseif(isempty(find(inputDataModel{2} > 12)) ~= 1)
        'ERROR VIN'
        cd('../PopUpWindows');
        errorVinIload;
        cd('../AdminUser');
    else
        inputDataModel{1} = model; %Save the model
        inputDataModel{7} = avgVin; %Save the value to do the average
        inputDataModel{8} = avgIload_1; %Save the value to do the average
        inputDataModel{9} = avgIload_2; %Save the value to do the average
        handles.output = inputDataModel;
        % Update handles structure
        guidata(hObject, handles);

        % Use UIRESUME instead of delete because the OutputFcn needs
        % to get the updated handles structure.
        uiresume(handles.figure1);    
    end
catch
    cd('../PopUpWindows');
    errorValues;
    cd('../AdminUser');
end


% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = 'NO';
% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);

function editVIN_Callback(hObject, eventdata, handles)
% hObject    handle to editVIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editVIN as text
%        str2double(get(hObject,'String')) returns contents of editVIN as a double


% --- Executes during object creation, after setting all properties.
function editVIN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editVIN (see GCBO)
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

function [posVin posIload_1 posIload_2] = checkAvg(inputVin, inputLoad, avgVin, avgLoad_1, avgLoad_2)
    
    for i=1:numel(inputVin)
        if(strcmp(inputVin{i}, avgVin))
            posVin = i;
            break;
        end
    end
    
    for i=1:numel(inputLoad)
        if(strcmp(inputLoad{i}, avgLoad_1))
            posIload_1 = i;
            break;
        end
    end
    
    for i=1:numel(inputLoad)
        if(strcmp(inputLoad{i}, avgLoad_2))
            posIload_2 = i;
            break;
        end
    end

function [vinValues iloadValues] = checkDATA(inputVin, inputLoad)
    
    [row col] = size(inputVin);
    vinValues = [];
    for i=1:col
        vinValues(i) = str2double(cell2mat(inputVin(i)));
    end
    
    [row col] = size(inputLoad);
    iloadValues = [];
    for i=1:col
        iloadValues(i) = str2double(cell2mat(inputLoad(i)));
    end

function nameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to modelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of modelEdit as text
%        str2double(get(hObject,'String')) returns contents of modelEdit as a double


% --- Executes during object creation, after setting all properties.
function nameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function modelEdit_Callback(hObject, eventdata, handles)
% hObject    handle to modelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of modelEdit as text
%        str2double(get(hObject,'String')) returns contents of modelEdit as a double


% --- Executes during object creation, after setting all properties.
function modelEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modelEdit (see GCBO)
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



function editAvgVIN_Callback(hObject, eventdata, handles)
% hObject    handle to editAvgVIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAvgVIN as text
%        str2double(get(hObject,'String')) returns contents of editAvgVIN as a double


% --- Executes during object creation, after setting all properties.
function editAvgVIN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAvgVIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAvgILOAD_1_Callback(hObject, eventdata, handles)
% hObject    handle to editAvgILOAD_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAvgILOAD_1 as text
%        str2double(get(hObject,'String')) returns contents of editAvgILOAD_1 as a double


% --- Executes during object creation, after setting all properties.
function editAvgILOAD_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAvgILOAD_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAvgILOAD_2_Callback(hObject, eventdata, handles)
% hObject    handle to editAvgILOAD_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAvgILOAD_2 as text
%        str2double(get(hObject,'String')) returns contents of editAvgILOAD_2 as a double


% --- Executes during object creation, after setting all properties.
function editAvgILOAD_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAvgILOAD_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
