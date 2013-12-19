function varargout = editConstraints(varargin)
% EDITCONSTRAINTS MATLAB code for editConstraints.fig
%      EDITCONSTRAINTS, by itself, creates a new EDITCONSTRAINTS or raises the existing
%      singleton*.
%
%      H = EDITCONSTRAINTS returns the handle to a new EDITCONSTRAINTS or the handle to
%      the existing singleton*.
%
%      EDITCONSTRAINTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDITCONSTRAINTS.M with the given input arguments.
%
%      EDITCONSTRAINTS('Property','Value',...) creates a new EDITCONSTRAINTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before editConstraints_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to editConstraints_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help editConstraints

% Last Modified by GUIDE v2.5 10-Dec-2013 16:33:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @editConstraints_OpeningFcn, ...
                   'gui_OutputFcn',  @editConstraints_OutputFcn, ...
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


% --- Executes just before editConstraints is made visible.
function editConstraints_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to editConstraints (see VARARGIN)

% Choose default command line output for editConstraints
handles.output = hObject;
global connection;
global modelInfoDCDC;
if(numel(varargin) == 1)
    modelInfoDCDC = varargin{1};
    %vout = varargin{2};
    arrayVIN = [];
    strVIN = '';
    arrayILOAD = [];
    strILOAD = '';
    action = ['SELECT DISTINCT VOUT FROM CONVERTER WHERE MODEL=' '''' char(modelInfoDCDC) ''' '];
    cursor = exec(connection, action);
    cursor = fetch(cursor);
    [row col] = size(cursor.Data);

    typeVout = (cursor.Data)';

    for i=1:row
        selectVout = cell2mat(typeVout(i));
        typeVout(i) = mat2cell(selectVout);
    end

%     for i=1:row
%         if(typeVout{i} == vout)
%             aux = typeVout(1);
%             typeVout(1) = typeVout(i);
%             typeVout(i) = aux;
%             break;
%         end
%     end
    set(handles.popupVout, 'String', typeVout);
    
    set(handles.textModel, 'String', ['Model: ', modelInfoDCDC]);


    action = ['SELECT ALL POINT, VALUE FROM CONFIG_DCDC WHERE MODEL =' '''' char(modelInfoDCDC) ''' AND CONFIG = ''VIN'''];
    cursor = exec(connection, action);
    cursor = fetch(cursor);
    [f c] = size(cursor.Data);
    for i=1:f
        arrayVIN(cursor.Data{i,1}) = cursor.Data{i,2};
    end
    for i =1:f-1
        strVIN = [strVIN, mat2str(arrayVIN(i)), ','];
    end
    strVIN = [strVIN, mat2str(arrayVIN(f))];

    action = ['SELECT ALL POINT, VALUE FROM CONFIG_DCDC WHERE MODEL =' '''' char(modelInfoDCDC) ''' AND CONFIG = ''ILOAD'''];
    cursor = exec(connection, action);
    cursor = fetch(cursor);
    [f c] = size(cursor.Data);
    for i=1:f
        arrayILOAD(cursor.Data{i,1}) = cursor.Data{i,2};
    end

    for i =1:f-1
        strILOAD = [strILOAD, mat2str(arrayILOAD(i)), ','];
    end
    strILOAD = [strILOAD, mat2str(arrayILOAD(f))];

    set(handles.editVin, 'String', strVIN);
    set(handles.editIload, 'String', strILOAD);

    %%Efficiency
    try
        action = ['SELECT V_INIT_MIN, V_INIT_MAX, I_INIT_MAX, V_2_MIN, V_4_MIN, EFF2, EFF4 FROM EFFICIENCY_DCDC WHERE MODEL =' '''' char(modelInfoDCDC) ''' AND VOUT=''' mat2str(typeVout{1}) ''''];
        cursor = exec(connection, action);
        cursor = fetch(cursor);

        set(handles.editVzeroMin, 'String', cursor.Data{1});
        set(handles.editVzeroMax, 'String', cursor.Data{2});
        set(handles.editIin, 'String', cursor.Data{3});
        set(handles.editV_2min, 'String', cursor.Data{4});
        set(handles.editV_4min, 'String', cursor.Data{5});
        set(handles.editEff_2v, 'String', cursor.Data{6});
        set(handles.editEff_4v, 'String', cursor.Data{7});
    catch
    end
    % Update handles structure
    guidata(hObject, handles);
else
    handles.output = 'Error';
end


% UIWAIT makes editConstraints wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% --- Outputs from this function are returned to the command line.
function varargout = editConstraints_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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



function editIin_Callback(hObject, eventdata, handles)
% hObject    handle to editIin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editIin as text
%        str2double(get(hObject,'String')) returns contents of editIin as a double


% --- Executes during object creation, after setting all properties.
function editIin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editIin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editVzeroMin_Callback(hObject, eventdata, handles)
% hObject    handle to editVzeroMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editVzeroMin as text
%        str2double(get(hObject,'String')) returns contents of editVzeroMin as a double


% --- Executes during object creation, after setting all properties.
function editVzeroMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editVzeroMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editVzeroMax_Callback(hObject, eventdata, handles)
% hObject    handle to editVzeroMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editVzeroMax as text
%        str2double(get(hObject,'String')) returns contents of editVzeroMax as a double


% --- Executes during object creation, after setting all properties.
function editVzeroMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editVzeroMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editV_2min_Callback(hObject, eventdata, handles)
% hObject    handle to editV_2min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editV_2min as text
%        str2double(get(hObject,'String')) returns contents of editV_2min as a double


% --- Executes during object creation, after setting all properties.
function editV_2min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editV_2min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editV_4min_Callback(hObject, eventdata, handles)
% hObject    handle to editV_4min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editV_4min as text
%        str2double(get(hObject,'String')) returns contents of editV_4min as a double


% --- Executes during object creation, after setting all properties.
function editV_4min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editV_4min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editEff_2v_Callback(hObject, eventdata, handles)
% hObject    handle to editEff_2v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editEff_2v as text
%        str2double(get(hObject,'String')) returns contents of editEff_2v as a double


% --- Executes during object creation, after setting all properties.
function editEff_2v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editEff_2v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editEff_4v_Callback(hObject, eventdata, handles)
% hObject    handle to editEff_4v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editEff_4v as text
%        str2double(get(hObject,'String')) returns contents of editEff_4v as a double


% --- Executes during object creation, after setting all properties.
function editEff_4v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editEff_4v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushSave.
function pushSave_Callback(hObject, eventdata, handles)
% hObject    handle to pushSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global connection
global modelInfoDCDC;
global voutInfoDCDC;
confirmation = confirmationWindows;
if(strcmp(confirmation,'YES'))
    vInitMin = str2double(get(handles.editVzeroMin, 'String'));
    vInitMax = str2double(get(handles.editVzeroMax, 'String'));
    iInitMax = str2double(get(handles.editIin, 'String'));
    v2Min = str2double(get(handles.editV_2min, 'String'));
    v4Min = str2double(get(handles.editV_4min, 'String'));
    eff2 = str2double(get(handles.editEff_2v, 'String'));
    eff4 = str2double(get(handles.editEff_4v, 'String'));

    %Call another figure to make sure that the admin want to change the values.

    action = ['WHERE MODEL= ''' str2mat(modelInfoDCDC) ''' AND VOUT= ''' str2mat(voutInfoDCDC) ''' '];
    update(connection, 'EFFICIENCY_DCDC', {'V_INIT_MIN', 'V_INIT_MAX','I_INIT_MAX','V_2_MIN','V_4_MIN', ...
         'EFF2', 'EFF4'}, {vInitMin,vInitMax, iInitMax, v2Min, v4Min, eff2, eff4}, action);    
end
% --- Executes on button press in pushCancel.
function pushCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.figure1);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on selection change in popupVout.
function popupVout_Callback(hObject, eventdata, handles)
% hObject    handle to popupVout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupVout contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupVout


% --- Executes during object creation, after setting all properties.
function popupVout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupVout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushAccept.
function pushAccept_Callback(hObject, eventdata, handles)
% hObject    handle to pushAccept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global connection;
global modelInfoDCDC;
global voutInfoDCDC;
listVout = get(handles.popupVout, 'String');
indexVout = get(handles.popupVout, 'Value');
voutToShow = listVout(indexVout);
voutInfoDCDC = voutToShow;

%%Efficiency
try
    action = ['SELECT V_INIT_MIN, V_INIT_MAX, I_INIT_MAX, V_2_MIN, V_4_MIN, EFF2, EFF4 FROM EFFICIENCY_DCDC WHERE MODEL =' '''' char(modelInfoDCDC) ''' AND VOUT=''' str2mat(voutToShow) ''''];
    cursor = exec(connection, action);
    cursor = fetch(cursor);

    set(handles.editVzeroMin, 'String', cursor.Data{1});
    set(handles.editVzeroMax, 'String', cursor.Data{2});
    set(handles.editIin, 'String', cursor.Data{3});
    set(handles.editV_2min, 'String', cursor.Data{4});
    set(handles.editV_4min, 'String', cursor.Data{5});
    set(handles.editEff_2v, 'String', cursor.Data{6});
    set(handles.editEff_4v, 'String', cursor.Data{7});
catch
end
% Update handles structure
guidata(hObject, handles);
